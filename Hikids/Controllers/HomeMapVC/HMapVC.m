//
//  HMapVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HMapVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import "BWDestnationInfoReq.h"
#import "BWDestnationInfoResp.h"
#import "HDestnationModel.h"
#import "HLocation.h"
#import "BWStudentLocationReq.h"
#import "BWStudentLocationResp.h"
#import "HStudent.h"
#import "HWalkMenuVC.h"
#import "HSleepMenuVC.h"
#import "HStudentStateInfoView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UserNotifications/UserNotifications.h>
#import "BWGetKindergartenReq.h"
#import "BWGetKindergartenResp.h"
#import "BWGetTaskReq.h"
#import "BWGetTaskResp.h"
#import "BWGetSleepTaskReq.h"
#import "BWGetSleepTaskResp.h"
#import "HTask.h"
#import "BWChangeTaskStateReq.h"
#import "BWChangeTaskStateResp.h"
#import "HCustomNavigationView.h"
#import "HSmallCardView.h"
#import "HHomeMenuView.h"
#import "HWalkMenuView.h"
#import "HBusMenuView.h"
#import "HWalkReportVC.h"
#import "HSettingVC.h"
#import "HDateVC.h"
#import "HWalkDownTimeView.h"
#import "HStudentEclipseView.h"
#import "HBGRunManager.h"
#import "HNomalGroupStudentView.h"
#import "HBusGroupStudentView.h"
#import "HConfirmAlertVC.h"
#import "BWGetWarnStrategyReq.h"
#import "BWGetWarnStrategyResp.h"
#import "BWStopWarnReq.h"
#import "BWStopWarnResp.h"
#import "HBusConfirmAlertVC.h"
#import "BWChangeModeReq.h"
#import "BWChangeModeResp.h"
#import "HDtAlertVC.h"



#define default_Zoom 18.5

@interface HMapVC ()<GMSMapViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) GMSMapView *mapView;                   //谷歌地图
@property (nonatomic,strong) GMSMarker *marker;                     //大头针
@property (nonatomic,strong) GMSPlacesClient * placesClient;        //可以获取某个地方的信息
@property (nonatomic,strong) CLLocationManager *locationManager;    //定位manager
@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;   //坐标
@property (nonatomic,strong) HLocation *fenceLocation;              //围栏信息
@property (nonatomic,strong) CLLocation *gpsLocation;               //手机gps信息
@property (nonatomic,strong) NSTimer *walkTimer;                    //散步定时器
@property (nonatomic,strong) HStudentStateInfoView *stateInfoView;  //点击地图上小朋友显示详情页
@property (nonatomic,strong) HTask *currentTask;                    //当前任务
@property (nonatomic,strong) NSMutableArray *makerList;             //保存所有孩子maker
@property (nonatomic,strong) NSMutableArray *circleList;             //保存所有孩子circle
@property (nonatomic,strong) HCustomNavigationView *customNavigationView;
//@property (nonatomic,assign) BOOL isAlert; //只弹窗一次 仅演示使用
@property (nonatomic,strong) HHomeMenuView *homeMenuTableView;      //首页底部菜单
@property (nonatomic,strong) HWalkMenuView *walkMenuTableView;      //散步底部菜单
@property (nonatomic,strong) HBusMenuView *busMenuTableView;        //乘车底部菜单
//@property (nonatomic,strong) HSettingVC *settingVC;               //设置页面
@property (nonatomic,strong) HWalkDownTimeView *downTimeView;       //提示是否到达目的地弹窗
@property (nonatomic,strong) NSString *destFence;                   //目的地围栏信息
@property (nonatomic,strong) NSString *kinFence;                    //院内围栏信息
@property (nonatomic,assign) BOOL isInFence;                        //是否在围栏内
@property (nonatomic,assign) BOOL firstLocationUpdate;              //第一次定位更新
@property (nonatomic,assign) BOOL isDrawFence;                      //是否画围栏 防止重复画
@property (nonatomic,assign) BOOL isDestMode;                       //是否是目的地模式
@property (nonatomic,assign) float lastZoom;                        //上次保存的放大倍数
@property (nonatomic,assign) NSInteger lastMarkerTag;               //上次选中marker的tag

@property (nonatomic,strong) NSString *appUrl;                      //检查更新版本


@end

@implementation HMapVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置屏幕常亮
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //取消设置屏幕常亮
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    页面进入逻辑
//    1.当walkTask为 5 或 nil的时候  调用查询sleepTask接口 如果 返回5 或者 nil的时候 就是 在院内模式
//    2.当walkTask为 5 或 nil的时候  调用查询sleepTask接口 如果 返回1就是 午睡模式
//    3.当walkTask为1的时候 就是散步模式 不调用查询sleepTask接口

    
    self.walkTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startGetStudentLocationRequest) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.walkTimer forMode:NSRunLoopCommonModes];
    
    [self.walkTimer setFireDate:[NSDate distantFuture]];

    //获取当前的任务情况
    [self getTaskRequest];

    //设置地图
    [self createMapView];
    

    //创建导航
    [self createNavigationView];
    

    //设置首页底部菜单
    [self setupHomeMenu];

    //设置小朋友详情页
    [self setupStudentInfoView];

    
    //开启定位
    [self startLocation];
    
    //获取默认警报灵敏度
    [self getWarnStrategyRequest];
    
    //检测版本
    [self checkVersion];
    

    
    //监听危险
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dangerAlertNotifi:) name:@"dangerAlertNotification" object:nil];
    //退出账户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutAction:) name:@"quitAccountNoti" object:nil];
    
    //监听手动解除警报情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmSafeStudentAction:) name:@"confirmSafeStudentNoti" object:nil];

    //app进入前台 关闭长链接模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterActive:) name:@"enterActive" object:nil];
    //app进入后台 开启长链接模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:@"enterBackground" object:nil];
    
    self.lastMarkerTag = -1;
    
//    
    //    加载假数据小朋友的
//        [self reloadData];
    
}
- (void)createNavigationView
{
    //设置导航栏信息
    [self.customNavigationView defautInfomation];
    
    [self.view addSubview:self.customNavigationView];
    [self.customNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(156));
    }];
    
    DefineWeakSelf;
    self.customNavigationView.clickHeader = ^{
        HSettingVC *settingVC = [[HSettingVC alloc] init];
        settingVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:settingVC animated:YES completion:nil];
    };
    
}
- (void)createMapView
{
    [self.view addSubview:self.mapView];
    
}
- (void)setupHomeMenu
{
    CGFloat topH = 0;

    HHomeMenuView *homeMenuView = [[HHomeMenuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(300), SCREEN_WIDTH, SCREEN_HEIGHT-topH)];
    homeMenuView.topH = topH;
    self.homeMenuTableView = homeMenuView;
    self.homeMenuTableView.busOrWalkButton.hidden = YES;
    [self.view addSubview:homeMenuView];

    DefineWeakSelf;
    homeMenuView.showWalkMenu = ^{
        [weakSelf showWalkMenuVC];
    };
    homeMenuView.openReport = ^{
        NSLog(@"home");
        HDateVC *dateVC = [[HDateVC alloc] init];
        [weakSelf presentViewController:dateVC animated:YES completion:nil];
    };
    
    homeMenuView.gpsBlock = ^{
        
        if (weakSelf.gpsLocation == nil) {
            [MBProgressHUD showMessag:@"位置を取得できませんでした" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
        }else{
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);
            //移动地图中心到当前位置
            weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:weakSelf.lastZoom == 0 ? default_Zoom : weakSelf.lastZoom];
            [weakSelf startGetStudentLocationRequest];
        }
        

    };
    homeMenuView.toTopBlock = ^{
        weakSelf.homeMenuTableView.gpsButton.hidden = YES;
        weakSelf.homeMenuTableView.smallView.hidden = YES;
    };
    homeMenuView.toBottomBlock = ^{
        weakSelf.homeMenuTableView.gpsButton.hidden = NO;
        weakSelf.homeMenuTableView.smallView.hidden = NO;
    };
    homeMenuView.showSelectMarkerBlock = ^(HStudent * _Nonnull student) {
        if (student.deviceInfo.latitude.length == 0) {
            [MBProgressHUD showMessag:@"位置情報が取得中" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
            return;
        }
        GMSMarker *marker = [weakSelf findMarkerWithStudentId:student.sId];
        [weakSelf selectMarkerWithStudent:student andMarker:marker];
    };
    
}

//设置散步菜单
- (void)setupWalkMenu
{
    if (self.walkMenuTableView != nil) {
        return;
    }
    CGFloat topH = 100;
    NSArray *normalList = self.busMenuTableView.safeList;
    NSArray *exceptList = self.busMenuTableView.exceptList;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.currentTask.warnStrategyLevel forKey:KEY_AlertWalkLevel];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //20为状态栏高度；tableview设置的大小要和view的大小一致
    self.walkMenuTableView = [[HWalkMenuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(300), SCREEN_WIDTH, SCREEN_HEIGHT-topH)];
    self.walkMenuTableView.topH = topH;
    self.walkMenuTableView.smallView.hidden = YES;
    self.walkMenuTableView.safeList = normalList;
    self.walkMenuTableView.exceptList = exceptList;
    self.walkMenuTableView.taskId = self.currentTask.tId;
    [self.view addSubview:self.walkMenuTableView];
    
    DefineWeakSelf;
    //结束散步 修改任务状态 弹出散步报告
    self.walkMenuTableView.walkEndBlock = ^{
        //修改任务状态
        [weakSelf changeTaskStateRequestWithStatus:@"5"];

    };
    self.walkMenuTableView.changeWalkStateBlock = ^(UIButton * _Nonnull button) {
        
        if([button.titleLabel.text isEqualToString:@"目的地に到着しました"]){
            [weakSelf changeTaskStateRequestWithStatus:@"3"];

        }
        if([button.titleLabel.text isEqualToString:@"帰路に出発"]){
            [weakSelf changeTaskStateRequestWithStatus:@"4"];

        }
        if([button.titleLabel.text isEqualToString:@"公園に到着しました"]){
            [weakSelf changeTaskStateRequestWithStatus:@"5"];

        }
        
    };
    self.walkMenuTableView.openReport = ^{
        NSLog(@"打开日历");
        HDateVC *dateVC = [[HDateVC alloc] init];
        [weakSelf presentViewController:dateVC animated:YES completion:nil];
    };
    self.walkMenuTableView.gpsBlock = ^{
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);


        //移动地图中心到当前位置
        weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:weakSelf.lastZoom == 0 ? default_Zoom : weakSelf.lastZoom];
        
        //test
        //测试数据
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(35.0960524118635, 136.9984240729761);
        
//        HDtAlertVC *alertVC = [[HDtAlertVC alloc] init];
//        alertVC.source = @"dest_mode";
//        alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        [weakSelf presentViewController:alertVC animated:NO completion:nil];
//        
//        alertVC.entreBlock = ^{
//            [weakSelf startRequestChangeModeWithType:@"dest"];
//        };
    };
   
    self.walkMenuTableView.showSelectMarkerBlock = ^(HStudent * _Nonnull student) {
        if (student.deviceInfo.latitude.length == 0) {
            [MBProgressHUD showMessag:@"位置情報が取得中" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
            return;
        }
        GMSMarker *marker = [weakSelf findMarkerWithStudentId:student.sId];
        [weakSelf selectMarkerWithStudent:student andMarker:marker];
    };
    
    weakSelf.walkMenuTableView.busBlock = ^{
        //切换bus模式
        NSLog(@"bus mode");
        
        HBusConfirmAlertVC *busAlertVC = [[HBusConfirmAlertVC alloc] initWithType:@"bus"];
        busAlertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:busAlertVC animated:NO completion:nil];
        
        busAlertVC.cancelBlock = ^{
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        };
        
        busAlertVC.confirmBlock = ^(NSString * _Nonnull type) {
            [weakSelf changeModeWithType:type];
        };
        
    };
    
}
- (void)setupBusMenu
{
    if (self.busMenuTableView != nil) {
        return;
    }
    CGFloat topH = 100;
    NSArray *normalList = self.walkMenuTableView.safeList;
    NSArray *exceptList = self.walkMenuTableView.exceptList;
    
    NSString *status = exceptList.count != 0 ? @"要注意" : @"安全";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"乘车中",@"status":status}];

    //20为状态栏高度；tableview设置的大小要和view的大小一致
    self.busMenuTableView = [[HBusMenuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(300), SCREEN_WIDTH, SCREEN_HEIGHT-topH)];
    self.busMenuTableView.topH = topH;
    self.busMenuTableView.smallView.hidden = YES;
    [self.busMenuTableView.busOrWalkButton setImage:[UIImage imageNamed:@"walk_mode.png"] forState:UIControlStateNormal];
    self.busMenuTableView.safeList = normalList;
    self.busMenuTableView.exceptList = exceptList;
    [self.view addSubview:self.busMenuTableView];
    [self.busMenuTableView.tableView reloadData];
    
    DefineWeakSelf;
    self.busMenuTableView.gpsBlock = ^{
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);
        //移动地图中心到当前位置
        weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:weakSelf.lastZoom == 0 ? default_Zoom : weakSelf.lastZoom];
    };
    
    self.busMenuTableView.busBlock = ^{
        //切换walk模式
        NSLog(@"walk mode");
        
        HBusConfirmAlertVC *busAlertVC = [[HBusConfirmAlertVC alloc] initWithType:@"walk"];
        busAlertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [weakSelf presentViewController:busAlertVC animated:NO completion:nil];
        
        busAlertVC.cancelBlock = ^{
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        };
        
        busAlertVC.confirmBlock = ^(NSString * _Nonnull type) {
            [weakSelf changeModeWithType:type];
        };
    };
   
}
//修改bus or walk模式
- (void)changeModeWithType:(NSString *)type
{
    //拿最新的老师坐标，作为他们下车时的位置
    if ([type isEqualToString:@"0"]) {
        DefineWeakSelf;
        BWStudentLocationReq *locationReq = [[BWStudentLocationReq alloc] init];
        locationReq.latitude = self.gpsLocation.coordinate.latitude;
        locationReq.longitude = self.gpsLocation.coordinate.longitude;
        [NetManger postRequest:locationReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
                    
            [weakSelf changeModeWithType:type];
            
        } failure:^(BWBaseReq *req, NSError *error) {
            
        }];
    }else{
        [self startRequestChangeModeWithType:type];
    }
}
- (void)startRequestChangeModeWithType:(NSString *)type
{
    long modeCode = 0;
    if ([type isEqualToString:@"bus"]) {
        modeCode = 2;
    }else if ([type isEqualToString:@"walk"]){
        modeCode = 0;
    }else{
        modeCode = 1;
    }
    
    DefineWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BWChangeModeReq *changeModeReq = [[BWChangeModeReq alloc] init];
    changeModeReq.tId = self.currentTask.tId;
    changeModeReq.modeCode = modeCode;
    [NetManger putRequest:changeModeReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([type isEqualToString:@"bus"]) {
            
            [weakSelf setupBusMenu];

            [weakSelf.walkMenuTableView removeFromSuperview]; //移除散步底部菜单
            weakSelf.walkMenuTableView = nil;
            
            
        }else{
            
            [weakSelf setupWalkMenu];

            [weakSelf.busMenuTableView removeFromSuperview]; //移除乘车底部菜单
            weakSelf.busMenuTableView = nil;
            
            
        }
        
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        [weakSelf startGetStudentLocationRequest];

            
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//设置小朋友详情view
- (void)setupStudentInfoView
{
    //点击头像弹出小朋友详情
    [self.stateInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PAaptation_y(351))];
    [self.view addSubview:self.stateInfoView];
    [self.view bringSubviewToFront:self.stateInfoView];
    
    DefineWeakSelf;
    //marks的详情
    self.stateInfoView.closeBlock = ^{
        [weakSelf hideStateInfoView];
        
        HStudentEclipseView *lastView = (HStudentEclipseView *)[weakSelf.mapView viewWithTag:weakSelf.lastMarkerTag];
//        [lastView setBgImage:lastView.isExcept ? [UIImage imageNamed:@"Ellipse.png"] : [UIImage imageNamed:@"1"]];

    };
}


//展示散步菜单
- (void)showWalkMenuVC
{
    
    HWalkMenuVC *menuWalkVC = [[HWalkMenuVC alloc] init];
    if ([BWTools getIsIpad]) {
        menuWalkVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:menuWalkVC animated:YES completion:nil];

    //点击开启散步
    DefineWeakSelf;
    menuWalkVC.startWalkBlock = ^(HTask * _Nonnull walkTask) {
        
        weakSelf.currentTask = walkTask;
        //修改散步状态为2 在途中
        [weakSelf changeTaskStateRequestWithStatus:@"2"];
        
    };
}

//展示散步报告
- (void)showWalkReport
{
    HWalkReportVC *walkReportVC = [[HWalkReportVC alloc] init];
//    walkReportVC.source = @"1";
    walkReportVC.taskId = self.currentTask.tId;
    [self presentViewController:walkReportVC animated:YES completion:nil];
    
    //散步报告关闭后 回到在院内模式
    DefineWeakSelf;
    walkReportVC.closeWalkReportBlock = ^{
        //todo
        [weakSelf.walkMenuTableView removeFromSuperview]; //移除散步底部菜单
        weakSelf.walkMenuTableView = nil;
    };
    
}
//获取当前任务状态
- (void)getTaskRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DefineWeakSelf;
    BWGetTaskReq *getTaskReq = [[BWGetTaskReq alloc] init];
    [NetManger getRequest:getTaskReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetTaskResp *getTaskResp = (BWGetTaskResp *)resp;
        weakSelf.currentTask = [getTaskResp.itemList safeObjectAtIndex:0];
        
        if (getTaskResp.itemList.count == 0) {
            //第一次打开app 任务为空 默认再院内

            [weakSelf startStayMode];
            return;
        }
        //任务状态，1新建 2途中，3目的地，4回程，5结束
        
        //该任务已完成/无任务
        if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask.status == nil) {
            //在院内模式
            [weakSelf startStayMode];
            
        }else if([weakSelf.currentTask.status isEqualToString:@"2"]){
            
            if ([weakSelf.currentTask.modeCode isEqualToString:@"0"]) {
                //散步模式
                
                //设置散步页底部菜单
                [weakSelf setupWalkMenu];
                
                //途中模式开启 只画目的地围栏
                [weakSelf startWalkMode];
                
            }else if([weakSelf.currentTask.modeCode isEqualToString:@"1"]){
                //目的地模式
                NSLog(@"目的地模式");

                [weakSelf setupWalkMenu];
                
                //途中模式开启 只画目的地围栏
                [weakSelf startWalkMode];

                [weakSelf drawFenceWith:weakSelf.currentTask.destinationFence ishome:NO];
                
                weakSelf.isDestMode = YES;

            }else{
                //乘车模式
                [weakSelf setupBusMenu];
                
                [weakSelf startBusMode];
            }
            

        
        }else if([weakSelf.currentTask.status isEqualToString:@"3"]){
            //已经失效用modeCode替代 10/07/2024
            //设置散步页底部菜单
//            [weakSelf setupWalkMenu];
            
            //目的地模式开启
           
//            [weakSelf startDestMode];
            


        }else if([weakSelf.currentTask.status isEqualToString:@"4"]){
            //已经失效用modeCode替代 10/07/2024
            //设置散步页底部菜单
//            [weakSelf setupWalkMenu];
            
            //回程模式开启 只画院内围栏
            
//            [weakSelf startBackMode];
            


        }
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}


- (void)changeTaskStateRequestWithStatus:(NSString *)status
{
    DefineWeakSelf;
    BWChangeTaskStateReq *changeReq = [[BWChangeTaskStateReq alloc] init];
    changeReq.tId = self.currentTask.tId;
    changeReq.status = status;
    [NetManger postRequest:changeReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
        BWChangeTaskStateResp *changeResp = (BWChangeTaskStateResp *)resp;
        weakSelf.currentTask = [changeResp.itemList safeObjectAtIndex:0];
        
        if ([weakSelf.currentTask.status isEqualToString:@"5"]) {
            
            [weakSelf showWalkReport];
            
        }
        //结束上一个任务改变该任务状态 并且查寻新的任务；
        [weakSelf getTaskRequest];
        
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)getWarnStrategyRequest
{
    DefineWeakSelf;
    BWGetWarnStrategyReq *warnReq = [[BWGetWarnStrategyReq alloc] init];
    [NetManger getRequest:warnReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        BWGetWarnStrategyResp *warnResp = (BWGetWarnStrategyResp *)resp;
        NSNumber *warnLevel = [warnResp.item safeObjectForKey:@"warnStrategyLevel"];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:warnLevel forKey:KEY_AlertLevel];
        [user synchronize];
        NSLog(@"%ld",warnLevel.integerValue);

            
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//开启园内模式
- (void)startStayMode
{
    [self clearMap];
    
    self.mapView.hidden = NO;               //展示地图
    self.homeMenuTableView.hidden = NO;     //展示首页底部菜单
        
    [self.walkTimer setFireDate:[NSDate distantPast]];
    
    [self.locationManager stopUpdatingLocation];


    [self getKinderRequest];                //获取围栏的信息
    
//    [self startLocation]; //开启定位
    

    
}
//开启散步模式
- (void)startWalkMode
{
    [self clearMap];
    
    self.homeMenuTableView.hidden = YES;
    
    //开启定位
//    [self startLocation];
    
    [self.walkTimer setFireDate:[NSDate distantPast]];
    
    [self.locationManager startUpdatingLocation];
    
    [self.walkMenuTableView.changeButton setTitle:@"目的地に到着しました" forState:UIControlStateNormal];


}

//开启乘车模式
- (void)startBusMode
{
    [self clearMap];
    
    self.homeMenuTableView.hidden = YES;
    
    [self.walkTimer setFireDate:[NSDate distantPast]];
    
    [self.locationManager startUpdatingLocation];
    
}
//画围栏(在startGetStudentLocationRequest方法里)
- (void)drawFenceWith:(NSString *)fence ishome:(BOOL)home
{

    if (self.isDrawFence) {
        return;
    }

    NSString *fenceStr = fence;

    HLocation *myLocation = [[HLocation alloc] init];
    NSArray *fenceArray = (NSArray *)[BWTools dictionaryWithJsonString:fenceStr];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in fenceArray) {
        HLocationInfo *info = [[HLocationInfo alloc] init];
        info.longitude = [[dic safeObjectForKey:@"longitude"] doubleValue];
        info.latitude = [[dic safeObjectForKey:@"latitude"] doubleValue];
        [array addObject:info];
    }
    myLocation.fenceArray = array;

    GMSMutablePath* path = [[GMSMutablePath alloc] init];

    for (NSInteger i = 0; i < myLocation.fenceArray.count; i++) {
        HLocationInfo *info = [myLocation.fenceArray safeObjectAtIndex:i];
        [path addCoordinate:CLLocationCoordinate2DMake(info.latitude, info.longitude)];
    }

    
    if(home){
        GMSPolygon* poly = [GMSPolygon polygonWithPath:path];
        poly.strokeWidth = 2.0;
        poly.strokeColor = BWColor(83, 192, 137, 1);
        poly.fillColor = BWColor(0, 176, 107, 0.2);
        poly.map = self.mapView;
        
    }else{
        
        GMSPolygon* poly = [GMSPolygon polygonWithPath:path];
        poly.strokeWidth = 0.0;
        poly.strokeColor = BWColor(63.0, 136.0, 150.0, 1.0);
        poly.fillColor = BWColor(17.0, 138.0, 152.0, 0.2);
        poly.map = self.mapView;
        
        
        //虚线无法自动闭合 需要手动添加
        HLocationInfo *info = [myLocation.fenceArray safeObjectAtIndex:0];
        [path addCoordinate:CLLocationCoordinate2DMake(info.latitude, info.longitude)];
        
        
        // 创建实线样式和透明样式
        GMSStrokeStyle *solidStyle = [GMSStrokeStyle solidColor:BWColor(63.0, 136.0, 150.0, 1.0)];
        GMSStrokeStyle *transparentStyle = [GMSStrokeStyle solidColor:[UIColor clearColor]];

        // 创建虚线样式的数组
        NSArray *styles = @[solidStyle, transparentStyle];

        // 设置虚线的间隔
        NSArray *lengths = @[@(1.5), @(1.5)]; // 你可以调整这些值来改变虚线的样式

        // 创建多边形的边界线
        GMSPolyline *border = [GMSPolyline polylineWithPath:path];
        border.spans = GMSStyleSpans(border.path, styles, lengths, kGMSLengthRhumb);
        border.strokeWidth = 3.0;
        border.map = self.mapView;
    }
    
    self.isDrawFence = YES;


}
//开启返程模式
//- (void)startBackMode
//{
//
//    [self clearMap];
//
//}
- (void)clearMap
{
    [self.makerList removeAllObjects];

    self.isDrawFence = NO;
    
    self.isDestMode = NO;

    [self.mapView clear];
    
    [self.locationManager stopUpdatingLocation];
    
    self.lastMarkerTag = -1;

}


//获取园区接口数据
- (void)getKinderRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DefineWeakSelf;
    BWGetKindergartenReq *kinderReq = [[BWGetKindergartenReq alloc] init];
    [NetManger getRequest:kinderReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        BWGetKindergartenResp *kinderResp = (BWGetKindergartenResp *)resp;
        HDestnationModel *kinModel = [kinderResp.itemList safeObjectAtIndex:0];

        [weakSelf drawFenceWith:kinModel.fence ishome:YES];
        


    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
////获取目的地接口数据
//- (void)getDestRequest
//{
//
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    DefineWeakSelf;
//    BWDestnationInfoReq *destReq = [[BWDestnationInfoReq alloc] init];
//    destReq.dId = self.currentTask.destinationId;
//    [NetManger getRequest:destReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//
//        BWDestnationInfoResp *destResp = (BWDestnationInfoResp *)resp;
////        HDestnationModel *kinModel = [kinderResp.itemList safeObjectAtIndex:0];
////
////        [weakSelf dealWithFence:kinModel.fence];
////        [weakSelf startGetStudentLocationRequest];
//
//
//    } failure:^(BWBaseReq *req, NSError *error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
//    }];
//}

//获取学生坐标信息
- (void)startGetStudentLocationRequest
{
    if (self.gpsLocation == nil) {
        NSLog(@"无法获取定位");
        
        [self startLocation];
        return;
    }

    DefineWeakSelf;
    BWStudentLocationReq *locationReq = [[BWStudentLocationReq alloc] init];
//    if (self.gpsLocation == nil) {
//        //先用围栏坐标替换
//        locationReq.latitude = self.fenceLocation.locationInfo.latitude;
//        locationReq.longitude = self.fenceLocation.locationInfo.longitude;
//    }else{
        locationReq.latitude = self.gpsLocation.coordinate.latitude;
        locationReq.longitude = self.gpsLocation.coordinate.longitude;
//    }

    [NetManger postRequest:locationReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWStudentLocationResp *locationResp = (BWStudentLocationResp *)resp;
        
        NSString *updateTime;
        if (locationResp.deviceLastUpload == 0) {
            updateTime = [NSString stringWithFormat:@"最終更新：ただいま"];
        }else{
            updateTime = [NSString stringWithFormat:@"最終更新：%@",[BWTools timeIntervalStringForLastUpdate:locationResp.deviceLastUpload]];

        }
        weakSelf.customNavigationView.updateTimeLabel.text = updateTime;
        
        NSString *teacherUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_Avatar];
        [weakSelf.customNavigationView.userImageView sd_setImageWithURL:[NSURL URLWithString:teacherUrl] placeholderImage:[UIImage imageNamed:@"teacher.png"]];
        
        //在院内
        if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask.status == nil) {

            NSString *status = locationResp.exceptionKids.count != 0 ? @"要注意" : @"安全";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"在園中",@"status":status}];
            
            weakSelf.homeMenuTableView.smallView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",locationResp.normalKids.count];
            weakSelf.homeMenuTableView.smallView.dangerLabel.text = [NSString stringWithFormat:@"アラート%ld人",locationResp.exceptionKids.count];
            weakSelf.homeMenuTableView.safeList = locationResp.normalKids;
            weakSelf.homeMenuTableView.exceptList = locationResp.exceptionKids;
            [weakSelf.homeMenuTableView.tableView reloadData];
            
        }else{
            
            weakSelf.isInFence = locationResp.isSafe;
            weakSelf.destFence = locationResp.desFence;
            weakSelf.kinFence = locationResp.kinFence;
            
            if (weakSelf.busMenuTableView == nil) {
                NSString *status = locationResp.exceptionKids.count != 0 ? @"要注意" : @"安全";
                NSString *name = weakSelf.isDestMode ? @"目的地" : @"散步中";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":name,@"status":status}];
                
                weakSelf.walkMenuTableView.safeList = locationResp.normalKids;
                weakSelf.walkMenuTableView.exceptList = locationResp.exceptionKids;
                [weakSelf.walkMenuTableView.tableView reloadData];
            }else{
                NSString *status = locationResp.exceptionKids.count != 0 ? @"要注意" : @"安全";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"乗車中",@"status":status}];
                
                weakSelf.busMenuTableView.safeList = locationResp.normalKids;
                weakSelf.busMenuTableView.exceptList = locationResp.exceptionKids;
                [weakSelf.busMenuTableView.tableView reloadData];
            }

            if ([weakSelf.currentTask.status isEqualToString:@"2"]) {
                
                //构建目的地-途中模式（画目的地围栏）
                [weakSelf drawFenceWith:weakSelf.currentTask.destinationFence ishome:NO];
                
                if ([locationResp.changeStatus isEqualToString:@"0"]) {
                    NSLog(@"进入散步模式？");
                    weakSelf.isDestMode = NO;

                    HDtAlertVC *alertVC = [[HDtAlertVC alloc] init];
                    alertVC.source = @"walk_mode";
                    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [weakSelf presentViewController:alertVC animated:NO completion:nil];
                    
                    alertVC.entreBlock = ^{
                        [weakSelf startRequestChangeModeWithType:@"walk"];
                    };
                }
                if ([locationResp.changeStatus isEqualToString:@"1"]) {
                    NSLog(@"进入目的地模式？");
                    
                    weakSelf.isDestMode = YES;
                    
                    HDtAlertVC *alertVC = [[HDtAlertVC alloc] init];
                    alertVC.source = @"dest_mode";
                    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [weakSelf presentViewController:alertVC animated:NO completion:nil];
                    
                    alertVC.entreBlock = ^{
                        [weakSelf startRequestChangeModeWithType:@"dest"];
                    };
                    
                    
                }
                

                
//                if([self isInFenceAction:self.destPoly.path]){
//                    //判断是否到了目的地
//                    [weakSelf showDestAlertViewWithState:@"3"];
//                    NSLog(@"是否到达目的地？");
//                }
//                
////                if (weakSelf.isInFence) {
////                    //判断是否到了目的地
////                    [weakSelf showDestAlertViewWithState:@"3"];
////                    NSLog(@"是否到达目的地？");
////                }

            }
            //目的地模式
            if ([weakSelf.currentTask.status isEqualToString:@"3"]) {
                
//                if (!weakSelf.isInFence) {
//                    //提示是否开启返程
//                    [weakSelf showDestAlertViewWithState:@"4"];
//                    NSLog(@"是否开启返程？");
//                }
//                [weakSelf drawFenceWith:weakSelf.destFence ishome:NO];
//                
//                if(![self isInFenceAction:self.destPoly.path]){
//                    //提示是否开启返程
//                    [weakSelf showDestAlertViewWithState:@"4"];
//                    NSLog(@"是否开启返程？");
//                }

            }
            if ([weakSelf.currentTask.status isEqualToString:@"4"]) {
                
                //返程模式（画园区地围栏）
//                [weakSelf drawFenceWith:weakSelf.kinFence ishome:YES];
//                if ([weakSelf isInFenceAction:weakSelf.kinPoly.path]) {
//                    //判断是否到了园区
//                    [weakSelf showDestAlertViewWithState:@"5"];
//                    NSLog(@"是否回到了园区？");
//                }

            }
            
        }
        
        if (self.busMenuTableView == nil) {
            //添加/刷新学生位置坐标
            [weakSelf addMarkersWithNomalList:locationResp.normalKids andExceptList:locationResp.exceptionKids withBus:NO];
        }else{
            //添加/刷新学生位置坐标
            [weakSelf addMarkersWithNomalList:locationResp.normalKids andExceptList:locationResp.exceptionKids withBus:YES];
        }


                
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
////前端来判断是否在围栏内(暂时替代后台 仅用在 散步和返程模式)
//- (BOOL)isInFenceAction:(GMSPath *)path
//{
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.gpsLocation.coordinate.latitude, self.gpsLocation.coordinate.longitude);
//    
//    if (GMSGeometryContainsLocation(coordinate, path, YES)) {
//        NSLog(@"YES: you are in this polygon.");
//        return YES;
//    }
//    return NO;
//}
- (void)showDestAlertViewWithState:(NSString *)state
{
    NSString *content = nil;
    if([state isEqualToString:@"3"]){
        content = @"目的地に着きましたか？";
    }
    if([state isEqualToString:@"4"]){
        content = @"復路を始めますか？";
    }
    if([state isEqualToString:@"5"]){
        content = @"公園に着きましたか？";
    }
        
    [self.downTimeView setupContent:content];
    [self.view addSubview:self.downTimeView];
    [self.downTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(300));
        make.height.mas_equalTo(PAaptation_y(140));
    }];
    
    DefineWeakSelf;
    self.downTimeView.sureBlock = ^{
        [weakSelf changeTaskStateRequestWithStatus:state];
        
    };
}
////处理院内模式围栏数据
//- (void)dealWithFence:(NSString *)fenceDataStr
//{
//    NSString *fenceStr = fenceDataStr;
//
//    HLocation *myLocation = [[HLocation alloc] init];
//    NSArray *fenceArray = (NSArray *)[BWTools dictionaryWithJsonString:fenceStr];
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    for (NSDictionary *dic in fenceArray) {
//        HLocationInfo *info = [[HLocationInfo alloc] init];
//        info.longitude = [[dic safeObjectForKey:@"longitude"] doubleValue];
//        info.latitude = [[dic safeObjectForKey:@"latitude"] doubleValue];
//        [array addObject:info];
//    }
//    myLocation.fenceArray = array;
//
//    //无法获取gps坐标时 使用围栏坐标
//    myLocation.locationInfo = [array safeObjectAtIndex:0];
//
//    //围栏坐标信息
//    self.fenceLocation = myLocation;
//
//    //获取到围栏坐标后 开启刷小朋友信息接口
//    [self.walkTimer setFireDate:[NSDate distantPast]];
//
//    //画围栏
//    [self drawPolygon];
//
//
//}

//画院内模式围栏
//-(void)drawPolygon
//{
//    if (self.isDrawFence) {
//        return;
//    }
//
//    GMSMutablePath* path = [[GMSMutablePath alloc] init];
//
//    for (NSInteger i = 0; i < self.fenceLocation.fenceArray.count; i++) {
//        HLocationInfo *info = [self.fenceLocation.fenceArray safeObjectAtIndex:i];
//        [path addCoordinate:CLLocationCoordinate2DMake(info.latitude, info.longitude)];
//    }
//
//    GMSPolygon* poly = [GMSPolygon polygonWithPath:path];
//    poly.strokeWidth = 2.0;
//    poly.strokeColor = BWColor(83, 192, 137, 1);
//    poly.fillColor = BWColor(0, 176, 107, 0.2);
//    poly.map = self.mapView;
//
//
//    CLLocationCoordinate2D coordinate;
//    if (self.gpsLocation == nil) {
//        coordinate = CLLocationCoordinate2DMake(self.fenceLocation.locationInfo.latitude, self.fenceLocation.locationInfo.longitude);
//    }else{
//        coordinate = CLLocationCoordinate2DMake(self.gpsLocation.coordinate.latitude, self.gpsLocation.coordinate.longitude);
//    }
//    //移动地图中心到当前位置
//    self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
//
//    self.isDrawFence = YES;
//
//    self.kinPoly = poly;
//
//}
-(void)addMarkersWithNomalList:(NSArray *)normalKids andExceptList:(NSArray *)exceptionKids withBus:(BOOL)isBus{
    
    //清除掉过去的点 重新绘制
    NSMutableArray *tempArray = [self.makerList copy];
    
    for (GMSMarker *marker in tempArray) {
        marker.map = nil;
        [self.makerList removeObject:marker];

    }
    
    NSMutableArray *temp2Array = [self.circleList copy];
    
    for (GMSCircle *circle in temp2Array) {
        circle.map = nil;
        [self.circleList removeObject:circle];

    }
    
    //因为bus样式与walk完全不同 所以此处需要区分 10/07/2024
    if (isBus) {
        for (NSInteger i = 0;i<exceptionKids.count;i++) {
                    
            HStudent *student = [exceptionKids safeObjectAtIndex:i];

            [self createOneMarkerStudent:student status:YES];
        }
        
        GMSMarker *marker = nil;
        if(normalKids.count == 0){
            NSLog(@"no nomal student");
            
        }else{
            HStudent *student = [normalKids safeObjectAtIndex:0];
            
            CGRect rect = CGRectMake(0, 0, PAdaptation_x(300), PAaptation_y(87));
            [self createBusGroupMarkerWithSafeStudent:student withList:normalKids withRect:rect];
        }
        
        if (![self.makerList containsObject:marker]) {
            if (marker != nil) {
                [self.makerList addObject:marker];
            }
        }
        
        
    }else{
        for (NSInteger i = 0;i<exceptionKids.count;i++) {
                    
            HStudent *student = [exceptionKids safeObjectAtIndex:i];

            [self createOneMarkerStudent:student status:YES];
        }
        
        GMSMarker *marker = nil;
        if(normalKids.count == 0){
            NSLog(@"no nomal student");
            
        }else if (normalKids.count == 1){
            HStudent *student = [normalKids safeObjectAtIndex:0];
            
            [self createOneMarkerStudent:student status:NO];
            
        }else if (normalKids.count == 2){
            
            //组 只取第一个的坐标
            HStudent *student = [normalKids safeObjectAtIndex:0];
            
            CGRect rect = CGRectMake(0, 0, PAdaptation_x(138), PAaptation_y(87));
            [self createGroupMarkerWithSafeStudent:student withList:normalKids withRect:rect];

            
        }else if(normalKids.count == 3){
            //组 只取第一个的坐标
            HStudent *student = [normalKids safeObjectAtIndex:0];
            
            CGRect rect = CGRectMake(0, 0, PAdaptation_x(202), PAaptation_y(87));
            [self createGroupMarkerWithSafeStudent:student withList:normalKids withRect:rect];
            
            
        }else{
            //>3
            //组 只取第一个的坐标
            HStudent *student = [normalKids safeObjectAtIndex:0];
            
            CGRect rect = CGRectMake(0, 0, PAdaptation_x(202), PAaptation_y(87));
            [self createGroupMarkerWithSafeStudent:student withList:normalKids withRect:rect];
        }
        if (![self.makerList containsObject:marker]) {
            if (marker != nil) {
                [self.makerList addObject:marker];
            }
        }
    }
    

    

}
- (GMSMarker *)findMarkerWithStudentId:(NSString *)studentId
{
    for (GMSMarker *marker in self.makerList) {
        HStudent *student = (HStudent *)marker.userData;
        if (student.sId.integerValue == studentId.integerValue) {
            return marker;
        }
    }
    return nil;
}
- (void)createOneMarkerStudent:(HStudent *)student status:(BOOL)isExcept
{
    CGRect ellipseframe = CGRectMake(0, 0, PAdaptation_x(40), PAaptation_y(40));
    
    HStudentEclipseView *ellipseView = [[HStudentEclipseView alloc] initWithFrame:ellipseframe withStudent:student];
    if(self.lastMarkerTag == 7000+student.sId.integerValue){
//            [ellipseView setBgImage:[UIImage imageNamed:@"studentInfo_yellow.png"]];
    }else{
//            [ellipseView setBgImage:[UIImage imageNamed:@"Ellipse.png"]];
    }
    ellipseView.isExcept = isExcept;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.title = student.name;
    marker.iconView = ellipseView;
    marker.userData = student;
    marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
    marker.map = self.mapView;
    
    GMSCircle *circle = [GMSCircle circleWithPosition:marker.position radius:80];
    if (isExcept) {
        circle.fillColor = [UIColor colorWithRed:236.0/255.0 green:90.0/255.0 blue:41.0/255.0 alpha:0.2];
        circle.strokeColor = [UIColor colorWithRed:236.0/255.0 green:90.0/255.0 blue:41.0/255.0 alpha:0.8];
        circle.strokeWidth = 0.5;
    }else{
        circle.fillColor = [UIColor colorWithRed:78/255.0 green:173.0/255.0 blue:113.0/255.0 alpha:0.2];
        circle.strokeColor = [UIColor colorWithRed:78/255.0 green:173.0/255.0 blue:113.0/255.0 alpha:0.8];
        circle.strokeWidth = 0.5;
    }

    circle.map = self.mapView;
    
    if (![self.makerList containsObject:marker]) {
        [self.makerList addObject:marker];
    }
    
    if (![self.circleList containsObject:circle]) {
        [self.circleList addObject:circle];
    }
}
- (void)createGroupMarkerWithSafeStudent:(HStudent *)student withList:(NSArray *)normalKids withRect:(CGRect)frame
{
    HNomalGroupStudentView *groupView = [[HNomalGroupStudentView alloc] initWithFrame:frame withGroupList:normalKids];
    
    GMSMarker *marker = [self findMarkerWithStudentId:student.sId];
    if (marker == nil) {
        marker = [[GMSMarker alloc] init];
    }
    
    marker.iconView = groupView;
    marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
    marker.userData = student;
    marker.map = self.mapView;
    
    GMSCircle *circle = [GMSCircle circleWithPosition:marker.position radius:80];
    circle.fillColor = [UIColor colorWithRed:78/255.0 green:173.0/255.0 blue:113.0/255.0 alpha:0.2];
    circle.strokeColor = [UIColor colorWithRed:78/255.0 green:173.0/255.0 blue:113.0/255.0 alpha:0.8];
    circle.strokeWidth = 0.5;
    circle.map = self.mapView;
    
    if (![self.makerList containsObject:marker]) {
        [self.makerList addObject:marker];
    }
    
    if (![self.circleList containsObject:circle]) {
        [self.circleList addObject:circle];
    }
}
- (void)createBusGroupMarkerWithSafeStudent:(HStudent *)student withList:(NSArray *)normalKids withRect:(CGRect)frame
{
    HBusGroupStudentView *groupView = [[HBusGroupStudentView alloc] initWithFrame:frame withGroupList:normalKids];
    
    GMSMarker *marker = [self findMarkerWithStudentId:student.sId];
    if (marker == nil) {
        marker = [[GMSMarker alloc] init];
    }
    
    marker.iconView = groupView;
    marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
    marker.userData = student;
    marker.map = self.mapView;
    
    GMSCircle *circle = [GMSCircle circleWithPosition:marker.position radius:80];
    circle.fillColor = [UIColor colorWithRed:246.0/255.0 green:209.0/255.0 blue:71.0/255.0 alpha:0.2];
    circle.strokeColor = [UIColor colorWithRed:246.0/255.0 green:209.0/255.0 blue:71.0/255.0 alpha:0.2];
    circle.strokeWidth = 0.5;
    circle.map = self.mapView;
    
    if (![self.makerList containsObject:marker]) {
        [self.makerList addObject:marker];
    }
    
    if (![self.circleList containsObject:circle]) {
        [self.circleList addObject:circle];
    }
}
- (void)reloadData
{
    //    //测试用
        NSMutableArray *except = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<10; i++) {
            HStudent *student = [[HStudent alloc] init];
            student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
            student.sId = [NSString stringWithFormat:@"%ld",100+i];
            student.name = @"asdfsa";
            student.exceptionTime = @"123";
            student.distance = @"200";
            student.deviceInfo.latitude = @"39.871893697139896";
            student.deviceInfo.longitude = @"116.28354814224828";
            [except addObject:student];
        }

//        self.exceptArray = except;
    //
        NSMutableArray *nomal = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<30; i++) {
            HStudent *student = [[HStudent alloc] init];
            student.avatar = @"https://yunpengmall.oss-cn-beijing.aliyuncs.com/1560875015170428928/material/19181666430944_.pic.jpg";
            student.sId = [NSString stringWithFormat:@"%ld",300+i];
            student.name = @"asdfsa";
            student.deviceInfo.latitude = @"39.871908";
            student.deviceInfo.longitude = @"116.281441";
            [nomal addObject:student];
        }
//        self.nomalArray = nomal;


    self.homeMenuTableView.safeList = nomal;
    self.homeMenuTableView.exceptList = except;
    [self.homeMenuTableView.tableView reloadData];


    [self addMarkersWithNomalList:nomal andExceptList:except withBus:NO];

}


- (void)startLocation {
    if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) && [CLLocationManager locationServicesEnabled]) {
        //定位功能可用

        [self.locationManager startUpdatingLocation];
    } else {
        //定位不能用
        [MBProgressHUD showMessag:@"位置決めは使用できません。位置決め設定をオンにしてください" toView:self.view hudModel:MBProgressHUDModeText hide:YES];
    }

}
//进入后台 开启长链接模式 用来刷新定位及报警系统
- (void)enterBackground:(NSNotification *)noti
{
    [HBGManager startBGRun];
}
- (void)enterActive:(NSNotification *)noti
{
    [HBGManager stopBGRun];
}
- (void)logOutAction:(NSNotification *)noti
{
    [self.walkTimer invalidate]; // 可以打破相互强引用，真正销毁NSTimer对象
    self.walkTimer = nil; // 对象置nil是一种规范和习惯
    
}
- (void)confirmSafeStudentAction:(NSNotification *)noti
{
    HStudent *student = [noti.object safeObjectForKey:@"student"];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue, student.deviceInfo.longitude.doubleValue);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:self.lastZoom == 0 ? default_Zoom : self.lastZoom];
    
    HConfirmAlertVC *alertCtrl = [[HConfirmAlertVC alloc] initWithStudent:student];
    alertCtrl.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:alertCtrl animated:NO completion:nil];

    DefineWeakSelf;
    alertCtrl.confirmBlock = ^{
        NSLog(@"%@",student.sId);
        //todo 调用接口 接口成功后 将danger小朋友删掉 加入到对应的safelist中，然后reload tableview
        
        
        BWStopWarnReq *warnReq = [[BWStopWarnReq alloc] init];
        warnReq.studentId = student.sId;
        [NetManger postRequest:warnReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
            NSLog(@"stopWarn调用成功");
            
            [weakSelf startGetStudentLocationRequest];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(BWBaseReq *req, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
        }];
    };

}
- (void)dangerAlertNotifi:(NSNotification *)noti
{
    
    NSDictionary *userInfo = noti.object;
    NSString *name = [userInfo safeObjectForKey:@"name"];

    if (![[userInfo safeObjectForKey:@"status"] isEqualToString:@"安全"]) {
        
        if (!self.homeMenuTableView.tableView.dragging || !self.walkMenuTableView.tableView.dragging) {
            if ([name isEqualToString:@"散步中"]) {
                [self.walkMenuTableView goCenter];

            }
            if ([name isEqualToString:@"在園中"]) {
                [self.homeMenuTableView goCenter];
            }
        }


        [self showAlertActionWithName:name];
        
    }

}
- (void)showAlertActionWithName:(NSString *)name
{

//    NSString *content = ![name isEqualToString:@"午睡中"] ? @"安全エリアから離れた園児がいます。ご確認ください。" : @"お子さまの再確認をお願いします。";
//    NSString *sureStr = ![name isEqualToString:@"午睡中"] ? @"アラート停止" : @"確認する";
    
        
    [self addLocalNoticeWithName:name];
    //调用系统震动
    [self getChatMessageGoToShake];
    //调用系统声音
    [self getChatMessageGoToSound];
    
//    [BWAlertCtrl alertControllerWithTitle:@"ご注意ください！" buttonArray:@[sureStr] message:content preferredStyle:UIAlertControllerStyleAlert clickBlock:^(NSString *buttonTitle) {
//        if ([buttonTitle isEqualToString:sureStr]) {
//        }
//    }];
}
#pragma  -mark -调用系统震动
- (void)getChatMessageGoToShake
{
     //调用系统震动
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma -mark -调用系统声音
- (void)getChatMessageGoToSound
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *soundId = [NSString stringWithFormat:@"%@",[user objectForKey:KEY_RingNumber]];
    
    NSString *path = nil;
    if (soundId.length != 0) {
        //调用系统声音
        path = [[NSBundle mainBundle] pathForResource:[self findAudioRingNumber:soundId] ofType:@"wav"];
    }else{
        //调用系统声音
        path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received3",@"caf"];
    }

    if (path) {
        SystemSoundID sd;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sd);
        //获取声音的时候出现错误
        if (error != kAudioServicesNoError) {
            NSLog(@"----调用系统声音出错----");
            sd = 0;
        }
        AudioServicesPlaySystemSound(sd);
    }
}
- (void)addLocalNoticeWithName:(NSString *)name {
    
    NSString *body = ![name isEqualToString:@"午睡中"] ? @"安全エリアから離れた園児がいます。ご確認ください。" : @"お子さまの再確認をお願いします。";
    NSString *subtitle = ![name isEqualToString:@"午睡中"] ? @"要注意" : @"要注意";
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *soundId = [NSString stringWithFormat:@"%@",[user objectForKey:KEY_RingNumber]];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"ご注意ください！";
        content.subtitle = subtitle;
        // 内容
        content.body = body;
        // 声音
        
        NSString *path = [[NSBundle mainBundle] pathForResource:[self findAudioRingNumber:soundId] ofType:@"wav"];

//        content.sound = [UNNotificationSound defaultSound];
        content.sound = [UNNotificationSound soundNamed:path];
        // 角标 （我这里测试的角标无效，暂时没找到原因）
        content.badge = @1;
        // 多少秒后发送,可以将固定的日期转化为时间
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:3] timeIntervalSinceNow];
        //        NSTimeInterval time = 10;
                // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
                
                /*
                //如果想重复可以使用这个,按日期
                // 周一早上 8：00 上班
                NSDateComponents *components = [[NSDateComponents alloc] init];
                // 注意，weekday默认是从周日开始
                components.weekday = 2;
                components.hour = 8;
                UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
                */
                // 添加通知的标识符，可以用于移除，更新等操作
                NSString *identifier = @"noticeId";
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
                
                [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
                    NSLog(@"成功添加推送");
                }];
    }else{
        UILocalNotification *notif = [[UILocalNotification alloc] init];
         // 发出推送的日期
         notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
         // 推送的内容
         notif.alertBody = @"ご注意ください！";
         // 可以添加特定信息
         notif.userInfo = @{@"noticeId":@"00001"};
         // 角标
         notif.applicationIconBadgeNumber = 1;
         // 提示音
        NSString *path = [[NSBundle mainBundle] pathForResource:[self findAudioRingNumber:soundId] ofType:@"wav"];
         notif.soundName = path;
         // 每周循环提醒
         notif.repeatInterval = NSCalendarUnitWeekOfYear;
         
         [[UIApplication sharedApplication] scheduleLocalNotification:notif];

    }
}

- (NSString *)findAudioRingNumber:(NSString *)soundId
{
    NSString *audioName = nil;
    if ([soundId isEqualToString:@"1"]) {
        audioName = @"strong_01";
    }else if ([soundId isEqualToString:@"2"]){
        audioName = @"strong_02";
    }else if ([soundId isEqualToString:@"3"]){
        audioName = @"strong_03";
    }else if ([soundId isEqualToString:@"4"]){
        audioName = @"normal_01";
    }else if ([soundId isEqualToString:@"5"]){
        audioName = @"normal_02";
    }else if ([soundId isEqualToString:@"6"]){
        audioName = @"normal_03";
    }else if ([soundId isEqualToString:@"7"]){
        audioName = @"weak_01";
    }else if ([soundId isEqualToString:@"8"]){
        audioName = @"weak_02";
    }else{
        audioName = @"weak_03";
    }
    return audioName;
}

#pragma mark - 系统自带location代理定位
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
//        [self locationPermissionAlert];
        [MBProgressHUD showMessag:@"位置決めは使用できません。位置決め設定をオンにしてください" toView:self.view hudModel:MBProgressHUDModeText hide:YES];

    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
        [BWAlertCtrl alertControllerWithTitle:@"ヒント" buttonArray:@[@"設定",@"キャンセル"] message:@"位置を取得できませんでした" preferredStyle:UIAlertControllerStyleAlert clickBlock:^(NSString *buttonTitle) {
            
            if ([buttonTitle isEqualToString:@"設定"]) {
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

                if([[UIApplication sharedApplication] canOpenURL:url]) {

                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        
                    }];

                }
            }
            
        }];

    }
//    [SVProgressHUD dismiss];
}
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations {

    // 获取最新定位 手机自己的定位
    CLLocation *location = locations.lastObject;

    if (location.horizontalAccuracy < 200 && location.horizontalAccuracy != -1){   //Many many code here...
        //数据可用
        //散步模式和返程模式 需要手机真实坐标
        self.gpsLocation = location;
        
        //替换自己的坐标
         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);

         //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
 //        _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
         //移动地图中心到当前位置
         self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:self.lastZoom == 0 ? default_Zoom : self.lastZoom];
        
//        if(self.isDestMode){
//            return;
//        }
//
//        [self startGetStudentLocationRequest];
        
        NSLog(@"调用定位111111");
        

    } else {
        [self.locationManager stopUpdatingLocation]; //停止获取
        [NSThread sleepForTimeInterval:10]; //阻塞10秒
        [self.locationManager startUpdatingLocation]; //重新获取
        
    }
}

#pragma mark -
#pragma mark - GoogleDelegate -
-(BOOL)mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    [self hideStateInfoView];
    
    HStudent *student = marker.userData;
    if (student.exceptionTime.length == 0) {
        return NO;
    }
    NSLog(@"点击了%@",student.name);
    [self.stateInfoView setInfomationWithModel:student];
    [self showStateInfoView];
    
    
    [self selectMarkerWithStudent:student andMarker:marker];

    

    return YES;
}
- (void)selectMarkerWithStudent:(HStudent *)student andMarker:(GMSMarker *)marker
{
    if (self.lastMarkerTag != -1) {
        HStudentEclipseView *lastView = (HStudentEclipseView *)[self.mapView viewWithTag:self.lastMarkerTag];
//        [lastView setBgImage:lastView.isExcept ? [UIImage imageNamed:@"Ellipse.png"] : [UIImage imageNamed:@""]];
    }
    
    self.lastMarkerTag = 7000 + student.sId.integerValue;
    
//    CGRect ellipseframe = CGRectMake(0, 0, PAdaptation_x(80), PAaptation_y(80));
//    HStudentEclipseView *ellipseView = [[HStudentEclipseView alloc] initWithFrame:ellipseframe withStudent:student];
//    [ellipseView setBgImage:[UIImage imageNamed:@"studentInfo_yellow.png"]];
//    ellipseView.isExcept = student.exceptionTime.length == 0 ? NO : YES;
//    ellipseView.tag = self.lastMarkerTag;
//    marker.iconView = ellipseView;
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue, student.deviceInfo.longitude.doubleValue);
    //移动地图中心到当前位置
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:self.lastZoom == 0 ? default_Zoom : self.lastZoom];
    

}
//点击地图空白处取消选中maker
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self hideStateInfoView];

    HStudentEclipseView *lastView = (HStudentEclipseView *)[mapView viewWithTag:self.lastMarkerTag];
//    [lastView setBgImage:lastView.isExcept ? [UIImage imageNamed:@"Ellipse.png"] : [UIImage imageNamed:@""]];
    

}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{

    self.lastZoom = position.zoom;
}

- (void)showStateInfoView
{
    self.walkMenuTableView.hidden = YES;
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.stateInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT - PAaptation_y(351), SCREEN_WIDTH, PAaptation_y(351))];
    }];
}
- (void)hideStateInfoView
{
    self.walkMenuTableView.hidden = NO;
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.stateInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PAaptation_y(351))];
    }];
}
- (void)checkVersion
{
    //获取当前版本号

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    CFShow((__bridge CFTypeRef)(infoDictionary));

    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    //获取苹果商店的版本号

    NSError  *error;

    NSString * urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=6447280569"];

    NSURL * url =[NSURL URLWithString:urlStr];

    NSURLRequest * request =[NSURLRequest requestWithURL:url];

    NSData * response =[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSDictionary * appInfo =[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

    if (error) {

        NSLog(@"error:%@",[error description]);

    }

    NSArray *resultsArray =[appInfo objectForKey:@"results"];

    if (![resultsArray count]) {

        NSLog( @"error: nil");

        return;
    }

    NSDictionary * infoDic =[resultsArray safeObjectAtIndex:0];

    NSString * appVersion = [infoDic objectForKey:@"version"];

    self.appUrl = [infoDic objectForKey:@"trackViewUrl"];

    double doucurrV =[app_Version doubleValue];

    double  douappV= [appVersion doubleValue];

    //判断版本号对比

    if (doucurrV < douappV) {
        NSString * titleStr =[NSString stringWithFormat:@"检查更新"];

        NSString * message =[NSString stringWithFormat:@"发现新版本，是否更新？"];

        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:titleStr message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];

        alert.tag = 1001;

        [alert show];


    }else{
        NSLog(@"已是最新版本");


    }
}
//跳转更新
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1001) {
        
        if (buttonIndex == 1) {
            //        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.appUrl]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appUrl] options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }
}

-(void)dealloc{
//    [SVProgressHUD dismiss];
    [self.locationManager stopUpdatingLocation];
    self.mapView = nil;
    
}

#pragma mark - LazyLoad -
- (GMSMapView *)mapView
{
    if (!_mapView) {
        //设置地图view，这里是随便初始化了一个经纬度，在获取到当前用户位置到时候会直接更新的
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38.02 longitude:114.52 zoom:default_Zoom];
        _mapView = [GMSMapView mapWithFrame:CGRectMake(0, PAaptation_y(148), SCREEN_WIDTH,self.view.frame.size.height - PAaptation_y(300)) camera:camera];
        _mapView.delegate = self;
        _mapView.settings.myLocationButton = NO;
        _mapView.myLocationEnabled = YES;
    }
    return _mapView;
}
- (HStudentStateInfoView *)stateInfoView
{
    if (!_stateInfoView) {
        _stateInfoView = [[HStudentStateInfoView alloc] init];
        _stateInfoView.backgroundColor = [UIColor clearColor];
        _stateInfoView.vc = self;
        
    }
    return _stateInfoView;
}
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//设置定位精度
        _locationManager.distanceFilter = 50;//设置定位频率，每隔多少米定位一次
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    return _locationManager;
}
- (NSMutableArray *)makerList
{
    if (!_makerList) {
        _makerList = [[NSMutableArray alloc] init];
    }
    return _makerList;
}
- (NSMutableArray *)circleList
{
    if (!_circleList) {
        _circleList = [[NSMutableArray alloc] init];
    }
    return _circleList;
}
- (HCustomNavigationView *)customNavigationView
{
    if (!_customNavigationView) {
        _customNavigationView = [[HCustomNavigationView alloc] init];
    }
    return _customNavigationView;
}
//- (HSleepMainView *)sleepMainView
//{
//    if (!_sleepMainView) {
//        _sleepMainView = [[HSleepMainView alloc] init];
//
//    }
//    return _sleepMainView;
//}

- (HWalkDownTimeView *)downTimeView
{
    if (!_downTimeView) {
        _downTimeView = [[HWalkDownTimeView alloc] init];
    }
    return _downTimeView;
}
@end
