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
#import "HSleepMenuView.h"
#import "HSleepMainView.h"
#import "HSleepReportVC.h"
#import "HWalkReportVC.h"
#import "HSettingVC.h"
#import "HDateVC.h"
#import "HWalkDownTimeView.h"
#import "HStudentEclipseView.h"

#import "HBGRunManager.h"
#import "HNomalGroupStudentView.h"


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
@property (nonatomic,strong) NSTimer *sleepTimer;                   //午睡定时器
@property (nonatomic,strong) HStudentStateInfoView *stateInfoView;  //点击地图上小朋友显示详情页
@property (nonatomic,strong) HTask *currentTask;                    //当前任务
@property (nonatomic,strong) NSMutableArray *makerList;             //保存所有孩子maker
@property (nonatomic,strong) HCustomNavigationView *customNavigationView;
//@property (nonatomic,assign) BOOL isAlert; //只弹窗一次 仅演示使用
@property (nonatomic,strong) HHomeMenuView *homeMenuTableView;      //首页底部菜单
@property (nonatomic,strong) HWalkMenuView *walkMenuTableView;      //散步底部菜单
@property (nonatomic,strong) HSleepMenuView *sleepMenuTableView;    //午睡底部菜单
@property (nonatomic,strong) HSleepMainView *sleepMainView;         //开始午睡时展示
@property (nonatomic,strong) HSettingVC *settingVC;                 //设置页面
@property (nonatomic,strong) HWalkDownTimeView *downTimeView;       //提示是否到达目的地弹窗
@property (nonatomic,strong) NSString *destFence;                   //目的地围栏信息
@property (nonatomic,strong) NSString *kinFence;                    //院内围栏信息
@property (nonatomic,assign) BOOL isInFence;                        //是否在围栏内
@property (nonatomic,assign) BOOL firstLocationUpdate;              //第一次定位更新
@property (nonatomic,assign) BOOL isDrawFence;                      //是否画围栏 防止重复画
@property (nonatomic,assign) BOOL isDestMode;                       //是否是目的地模式
@property (nonatomic,strong) GMSPolygon* kinPoly;                   //园区围栏路径
@property (nonatomic,strong) GMSPolygon* destPoly;                  //目的地围栏路径
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
    

//    //开启定时器
//     [self.walkTimer setFireDate:[NSDate distantPast]];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //取消设置屏幕常亮
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
//    //关闭定时器
//    [self.sleepTimer setFireDate:[NSDate distantFuture]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    页面进入逻辑
//    1.当walkTask为 5 或 nil的时候  调用查询sleepTask接口 如果 返回5 或者 nil的时候 就是 在院内模式
//    2.当walkTask为 5 或 nil的时候  调用查询sleepTask接口 如果 返回1就是 午睡模式
//    3.当walkTask为1的时候 就是散步模式 不调用查询sleepTask接口

    
    self.walkTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startGetStudentLocationRequest) userInfo:nil repeats:YES];
    [self.walkTimer setFireDate:[NSDate distantFuture]];

    self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getSleepTaskRequest) userInfo:nil repeats:YES];
    [self.sleepTimer setFireDate:[NSDate distantFuture]];

    //获取当前的任务情况 内部还调用了sleepTask
    [self getTaskRequest];


    //设置地图
    [self createMapView];
    
   

    //创建导航
    [self createNavigationView];
    
    //设置导航栏信息
    [self.customNavigationView defautInfomation];


    //设置首页底部菜单
    [self setupHomeMenu];

    //设置小朋友详情页
    [self setupStudentInfoView];

    
    //开启定位
    [self startLocation];
    
    //检测版本
    [self checkVersion];
    
    //    加载假数据小朋友的
//        [self reloadData];
    
    //监听危险
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dangerAlertNotifi:) name:@"dangerAlertNotification" object:nil];
    //退出账户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutAction:) name:@"quitAccountNoti" object:nil];
    
    //app进入前台 关闭长链接模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterActive:) name:@"enterActive" object:nil];
    //app进入后台 开启长链接模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground:) name:@"enterBackground" object:nil];
    
    self.lastMarkerTag = -1;
    
}
- (void)createNavigationView
{
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
        [weakSelf presentViewController:weakSelf.settingVC animated:YES completion:nil];
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
    [self.view addSubview:homeMenuView];

    DefineWeakSelf;
    homeMenuView.showSleepMenu = ^{
        [weakSelf showSleepMenuVC];
    };
    homeMenuView.showWalkMenu = ^{
        [weakSelf showWalkMenuVC];
    };
    homeMenuView.openReport = ^{
        NSLog(@"home");
        HDateVC *dateVC = [[HDateVC alloc] init];
        [weakSelf presentViewController:dateVC animated:YES completion:nil];
    };
    __block BOOL isSelected = YES;
    homeMenuView.gpsBlock = ^{
        
        if (weakSelf.gpsLocation == nil) {
            [MBProgressHUD showMessag:@"位置を取得できませんでした" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
        }else{
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);
            //移动地图中心到当前位置
            weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:self.lastZoom == 0 ? default_Zoom : self.lastZoom];
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

    //20为状态栏高度；tableview设置的大小要和view的大小一致
    self.walkMenuTableView = [[HWalkMenuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(300), SCREEN_WIDTH, SCREEN_HEIGHT-topH)];
    self.walkMenuTableView.topH = topH;
    self.walkMenuTableView.smallView.hidden = YES;
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
    };
   
    self.walkMenuTableView.showSelectMarkerBlock = ^(HStudent * _Nonnull student) {
        if (student.deviceInfo.latitude.length == 0) {
            [MBProgressHUD showMessag:@"位置情報が取得中" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
            return;
        }
        GMSMarker *marker = [weakSelf findMarkerWithStudentId:student.sId];
        [weakSelf selectMarkerWithStudent:student andMarker:marker];
    };
    
}
//设置午睡菜单
- (void)setupSleepMenu
{
//    CGFloat topH = SCREEN_HEIGHT/2-PAaptation_y(121);
    CGFloat topH = 0;

    //20为状态栏高度；tableview设置的大小要和view的大小一致
    if ([BWTools getIsIpad]) {
        self.sleepMenuTableView = [[HSleepMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - LAdaptation_x(850)/2, SCREEN_HEIGHT-LAdaptation_y(250), LAdaptation_x(850), SCREEN_HEIGHT-topH)];

    }else{
        self.sleepMenuTableView = [[HSleepMenuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(400), SCREEN_WIDTH, SCREEN_HEIGHT-topH)];

    }
    self.sleepMenuTableView.topH = topH;
    self.sleepMenuTableView.smallView.hidden = YES;
    self.sleepMenuTableView.gpsButton.hidden = YES;
    [self.view addSubview:self.sleepMenuTableView];
    
    DefineWeakSelf;
    //结束午睡 弹出午睡报告
    self.sleepMenuTableView.sleepEndBlock = ^{
        //修改任务状态
        [weakSelf changeTaskStateRequestWithStatus:@"5"];
        
    };
    
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
        [lastView setBgImage:lastView.isExcept ? [UIImage imageNamed:@"Ellipse.png"] : [UIImage imageNamed:@"1"]];

    };
}
//设置午睡内容页
- (void)setupSleepMainView
{
    HSleepMainView *sleepMainView = [[HSleepMainView alloc] init];
    self.sleepMainView = sleepMainView;
    [self.view addSubview:sleepMainView];
    [self.view sendSubviewToBack:sleepMainView];
    [sleepMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNavigationView.mas_bottom).offset(-PAaptation_y(10));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    DefineWeakSelf;
    sleepMainView.sleepTimeOverBlock = ^{
        //修改任务状态
        [weakSelf changeTaskStateRequestWithStatus:@"5"];
        
    };
}
//展示午睡菜单
- (void)showSleepMenuVC
{
    HSleepMenuVC *menuSleepVC = [[HSleepMenuVC alloc] init];
    if ([BWTools getIsIpad]) {
        menuSleepVC.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:menuSleepVC animated:YES completion:nil];
    
    //点击开启午睡
    DefineWeakSelf;
    menuSleepVC.startSleepBlock = ^(HTask * _Nonnull sleepTask) {
        
        weakSelf.currentTask = sleepTask;
        
        //开始午睡模式
        [weakSelf startSleepMode];
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
//展示午睡报告
- (void)showSleepReport
{
    HSleepReportVC *sleepReportVC = [[HSleepReportVC alloc] init];
    sleepReportVC.taskId = self.currentTask.tId;
    [self presentViewController:sleepReportVC animated:YES completion:nil];
    
    //午睡报告关闭后 回到在院内模式
    DefineWeakSelf;
    sleepReportVC.closeSleepReportBlock = ^{
        //todo
        [weakSelf.sleepMainView closeTimer];
        
        [weakSelf.sleepMainView removeFromSuperview];//移除午睡主页面
        
        [weakSelf.sleepMenuTableView removeFromSuperview];//移除午睡底部菜单
        

        
//        [weakSelf startStayMode];
    };
}
//展示散步报告
- (void)showWalkReport
{
    HWalkReportVC *walkReportVC = [[HWalkReportVC alloc] init];
    walkReportVC.source = @"1";
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
        //type 1散步 2午睡
        if ([weakSelf.currentTask.type isEqualToString:@"1"]) {
            
            //该任务已完成/无任务
            if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask.status == nil) {
                //在院内模式
                [weakSelf startStayMode];
                
            }else if([weakSelf.currentTask.status isEqualToString:@"2"]){
                
                //设置散步页底部菜单
                [weakSelf setupWalkMenu];
                
                //途中模式开启 只画目的地围栏
                [weakSelf startWalkMode];
                


            }else if([weakSelf.currentTask.status isEqualToString:@"3"]){
                
                //设置散步页底部菜单
                [weakSelf setupWalkMenu];
                
                //目的地模式开启
               
                [weakSelf startDestMode];
                


            }else if([weakSelf.currentTask.status isEqualToString:@"4"]){
                //设置散步页底部菜单
                [weakSelf setupWalkMenu];
                
                //回程模式开启 只画院内围栏
                
                [weakSelf startBackMode];
                


            }
        }else{

            //午睡模式开始
            if ([weakSelf.currentTask.status isEqualToString:@"1"]) {
                
                [weakSelf startSleepMode];
            }
            //午睡模式结束 默认院内模式
            if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask.status == nil) {
                 
                [weakSelf startStayMode];

            }
        }
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//获取午睡小朋友状态接口
- (void)getSleepTaskRequest
{
    
    DefineWeakSelf;
    BWGetSleepTaskReq *getSleepTaskReq = [[BWGetSleepTaskReq alloc] init];
    [NetManger getRequest:getSleepTaskReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        BWGetSleepTaskResp *getTaskResp = (BWGetSleepTaskResp *)resp;
        //任务状态1已经开始，5结束
        //todo 1的时候切换成 午睡模式。5的时候结束午睡 进入园内模式
        
        [weakSelf dealWithSleepStudentDataWithDic:getTaskResp.item];
        
        [weakSelf.sleepMainView setupContent:getTaskResp.item];
        

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)dealWithSleepStudentDataWithDic:(NSDictionary *)studentDic
{
    NSMutableArray *tempDangerArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in  [studentDic safeObjectForKey:@"unnormalList"]) {
        HStudent *student = [[HStudent alloc] init];
        student.sId = [dic safeObjectForKey:@"kidsId"];
        student.name = [dic safeObjectForKey:@"kidsName"];
        student.deviceInfo.averangheart = [dic safeObjectForKey:@"heartRate"];
        student.avatar = [dic safeObjectForKey:@"avatar"];
        [tempDangerArray addObject:student];
    }
    
    NSMutableArray *tempSafeArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [studentDic safeObjectForKey:@"normalList"]) {
        HStudent *student = [[HStudent alloc] init];
        student.sId = [dic safeObjectForKey:@"kidsId"];
        student.name = [dic safeObjectForKey:@"kidsName"];
        student.deviceInfo.averangheart = [dic safeObjectForKey:@"heartRate"];
        student.avatar = [dic safeObjectForKey:@"avatar"];
        [tempSafeArray addObject:student];
    }
    
    self.sleepMenuTableView.smallView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",tempSafeArray.count];
    self.sleepMenuTableView.smallView.dangerLabel.text = [NSString stringWithFormat:@"アラート%ld回",tempDangerArray.count];
    self.sleepMenuTableView.safeList = tempSafeArray;
    self.sleepMenuTableView.exceptList = tempDangerArray;
    [self.sleepMenuTableView.tableView reloadData];
    
    NSString *status = tempDangerArray.count != 0 ? @"危険" : @"安全";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"午睡中",@"status":status}];
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
            
            if ([weakSelf.currentTask.type isEqualToString:@"1"]) {
                
                [weakSelf showWalkReport];

            }else{
                [weakSelf showSleepReport];

            }
            
        }
        //结束上一个任务改变该任务状态 并且查寻新的任务；
        [weakSelf getTaskRequest];
        
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//开始午睡模式
- (void)startSleepMode
{
                
    [self clearMap];
    
    //设置午睡内容view
    [self setupSleepMainView];
    //设置午睡页底部菜单
    [self setupSleepMenu];

    self.mapView.hidden = YES;
    self.homeMenuTableView.hidden = YES;
    
    [self.sleepTimer setFireDate:[NSDate distantPast]];
    [self.walkTimer setFireDate:[NSDate distantFuture]];

}
//开启园内模式
- (void)startStayMode
{
    [self clearMap];
    
    self.mapView.hidden = NO;               //展示地图
    self.homeMenuTableView.hidden = NO;     //展示首页底部菜单
        
    [self.sleepTimer setFireDate:[NSDate distantFuture]];
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
    [self.sleepTimer setFireDate:[NSDate distantFuture]];
    
    [self.locationManager startUpdatingLocation];
    
    [self.walkMenuTableView.changeButton setTitle:@"目的地に到着しました" forState:UIControlStateNormal];


}
//开启目的地模式
- (void)startDestMode
{
    [self clearMap];
    
    self.homeMenuTableView.hidden = YES;
    
//    //开启定位
//    [self startLocation];
    
    [self.walkTimer setFireDate:[NSDate distantPast]];
    [self.sleepTimer setFireDate:[NSDate distantFuture]];
        
    self.isDestMode = YES;
    
    [self.locationManager startUpdatingLocation];
    
    [self.walkMenuTableView.changeButton setTitle:@"帰路に出発" forState:UIControlStateNormal];


}
//开启返回模式
- (void)startBackMode
{
    [self clearMap];
    
    self.homeMenuTableView.hidden = YES;
    
    
    [self.walkTimer setFireDate:[NSDate distantPast]];
    [self.sleepTimer setFireDate:[NSDate distantFuture]];
    
    [self.locationManager startUpdatingLocation];
    
    [self.walkMenuTableView.changeButton setTitle:@"公園に到着しました" forState:UIControlStateNormal];

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

    GMSPolygon* poly = [GMSPolygon polygonWithPath:path];
    poly.strokeWidth = 2.0;
    poly.strokeColor = BWColor(83, 192, 137, 1);
    poly.fillColor = BWColor(0, 176, 107, 0.2);
    poly.map = self.mapView;

    self.isDrawFence = YES;
    
    if(home){
        self.kinPoly = poly;
    }else{
        self.destPoly = poly;

    }

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

        //在院内
        if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask.status == nil) {

            NSString *status = locationResp.exceptionKids.count != 0 ? @"危険" : @"安全";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"在園中",@"status":status}];
            
            weakSelf.homeMenuTableView.smallView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",locationResp.normalKids.count];
            weakSelf.homeMenuTableView.smallView.dangerLabel.text = [NSString stringWithFormat:@"アラート%ld回",locationResp.exceptionKids.count];
            weakSelf.homeMenuTableView.safeList = locationResp.normalKids;
            weakSelf.homeMenuTableView.exceptList = locationResp.exceptionKids;
            [weakSelf.homeMenuTableView.tableView reloadData];
            
        }else{
            
            NSString *status = locationResp.exceptionKids.count != 0 ? @"危険" : @"安全";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"散步中",@"status":status}];
            
            weakSelf.walkMenuTableView.safeList = locationResp.normalKids;
            weakSelf.walkMenuTableView.exceptList = locationResp.exceptionKids;
            [weakSelf.walkMenuTableView.tableView reloadData];
            
            weakSelf.isInFence = locationResp.isSafe;
            weakSelf.destFence = locationResp.desFence;
            weakSelf.kinFence = locationResp.kinFence;
            
            if ([weakSelf.currentTask.status isEqualToString:@"2"]) {
                
                //构建目的地-途中模式（画目的地围栏）
                [weakSelf drawFenceWith:weakSelf.destFence ishome:NO];
                
                if([self isInFenceAction:self.destPoly.path]){
                    //判断是否到了目的地
                    [weakSelf showDestAlertViewWithState:@"3"];
                    NSLog(@"是否到达目的地？");
                }
                
//                if (weakSelf.isInFence) {
//                    //判断是否到了目的地
//                    [weakSelf showDestAlertViewWithState:@"3"];
//                    NSLog(@"是否到达目的地？");
//                }

            }
            //目的地模式
            if ([weakSelf.currentTask.status isEqualToString:@"3"]) {
                
//                if (!weakSelf.isInFence) {
//                    //提示是否开启返程
//                    [weakSelf showDestAlertViewWithState:@"4"];
//                    NSLog(@"是否开启返程？");
//                }
                [weakSelf drawFenceWith:weakSelf.destFence ishome:NO];
                
                if(![self isInFenceAction:self.destPoly.path]){
                    //提示是否开启返程
                    [weakSelf showDestAlertViewWithState:@"4"];
                    NSLog(@"是否开启返程？");
                }

            }
            if ([weakSelf.currentTask.status isEqualToString:@"4"]) {
                
                //返程模式（画园区地围栏）
                [weakSelf drawFenceWith:weakSelf.kinFence ishome:YES];
                if ([weakSelf isInFenceAction:weakSelf.kinPoly.path]) {
                    //判断是否到了园区
                    [weakSelf showDestAlertViewWithState:@"5"];
                    NSLog(@"是否回到了园区？");
                }

            }
            
        }

        //添加/刷新学生位置坐标
        [weakSelf addMarkersWithNomalList:locationResp.normalKids andExceptList:locationResp.exceptionKids];
                
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//前端来判断是否在围栏内(暂时替代后台 仅用在 散步和返程模式)
- (BOOL)isInFenceAction:(GMSPath *)path
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.gpsLocation.coordinate.latitude, self.gpsLocation.coordinate.longitude);
    
    if (GMSGeometryContainsLocation(coordinate, path, YES)) {
        NSLog(@"YES: you are in this polygon.");
        return YES;
    }
    return NO;
}
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
-(void)addMarkersWithNomalList:(NSArray *)normalKids andExceptList:(NSArray *)exceptionKids{
    
    //清除掉过去的点 重新绘制
    NSMutableArray *tempArray = [self.makerList copy];
    
    for (GMSMarker *marker in tempArray) {
        marker.map = nil;
        [self.makerList removeObject:marker];

    }
    
    
    for (NSInteger i = 0;i<exceptionKids.count;i++) {
                
        HStudent *student = [exceptionKids safeObjectAtIndex:i];

        CGRect ellipseframe = CGRectMake(0, 0, PAdaptation_x(80), PAaptation_y(80));
        
        HStudentEclipseView *ellipseView = [[HStudentEclipseView alloc] initWithFrame:ellipseframe withStudent:student];
        if(self.lastMarkerTag == 7000+student.sId.integerValue){
            [ellipseView setBgImage:[UIImage imageNamed:@"studentInfo_yellow.png"]];
        }else{
            [ellipseView setBgImage:[UIImage imageNamed:@"Ellipse.png"]];
        }
        ellipseView.isExcept = YES;
        
        GMSMarker *marker = [self findMarkerWithStudentId:student.sId];
        
        if (marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        marker.title = student.name;
        marker.iconView = ellipseView;
        marker.userData = student;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.map = self.mapView;
        
        
        if (![self.makerList containsObject:marker]) {
            [self.makerList addObject:marker];
        }
        
    }
    
    GMSMarker *marker = nil;
    if(normalKids.count == 0){
        NSLog(@"no nomal student");
        
    }else if (normalKids.count == 1){
        HStudent *student = [normalKids safeObjectAtIndex:0];
        
        CGRect frame = CGRectMake(0, 0, PAdaptation_x(40), PAaptation_y(40));

        HStudentEclipseView *ellipseView = [[HStudentEclipseView alloc] initWithFrame:frame withStudent:student];
        if(self.lastMarkerTag == 7000+student.sId.integerValue){
            [ellipseView setBgImage:[UIImage imageNamed:@"studentInfo_yellow.png"]];
        }else{
            [ellipseView setBgImage:[UIImage imageNamed:@"1"]];
        }
        ellipseView.isExcept = NO;
        
        marker = [self findMarkerWithStudentId:student.sId];
        if (marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        marker.title = student.name;
        marker.iconView = ellipseView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
        
        
        
    }else if (normalKids.count == 2){
        
        //组 只取第一个的坐标
        HStudent *student = [normalKids safeObjectAtIndex:0];
        
        HNomalGroupStudentView *groupView = [[HNomalGroupStudentView alloc] initWithFrame:CGRectMake(0, 0, PAdaptation_x(138), PAaptation_y(87)) withGroupList:normalKids];
        
        marker = [self findMarkerWithStudentId:student.sId];
        if (marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        

        marker.iconView = groupView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;

        
    }else if(normalKids.count == 3){
        //组 只取第一个的坐标
        HStudent *student = [normalKids safeObjectAtIndex:0];
        
        HNomalGroupStudentView *groupView = [[HNomalGroupStudentView alloc] initWithFrame:CGRectMake(0, 0, PAdaptation_x(202), PAaptation_y(87)) withGroupList:normalKids];
        
        marker = [self findMarkerWithStudentId:student.sId];
        if (marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        marker.iconView = groupView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
        
    }else{
        //>3
        //组 只取第一个的坐标
        HStudent *student = [normalKids safeObjectAtIndex:0];
        
        HNomalGroupStudentView *groupView = [[HNomalGroupStudentView alloc] initWithFrame:CGRectMake(0, 0, PAdaptation_x(202), PAaptation_y(87)) withGroupList:normalKids];
        
        marker = [self findMarkerWithStudentId:student.sId];
        if (marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        marker.iconView = groupView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
    }
    
//    if (marker == nil) return;
    if (![self.makerList containsObject:marker]) {
        if (marker != nil) {
            [self.makerList addObject:marker];
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

- (void)reloadData
{
    //    //测试用
        NSMutableArray *except = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<1; i++) {
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
        for (NSInteger i = 0; i<1; i++) {
            HStudent *student = [[HStudent alloc] init];
            student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
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


    [self addMarkersWithNomalList:nomal andExceptList:except];

}


- (void)startLocation {
    if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) && [CLLocationManager locationServicesEnabled]) {
        //定位功能可用

        [self.locationManager startUpdatingLocation];
    } else {
        //定位不能用
//        [self locationPermissionAlert];
//        [SVProgressHUD dismiss];
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
    
    [self.sleepTimer invalidate];
    self.sleepTimer = nil;
    
}
- (void)dangerAlertNotifi:(NSNotification *)noti
{
    
    NSDictionary *userInfo = noti.object;
    NSString *name = [userInfo safeObjectForKey:@"name"];

    if (![[userInfo safeObjectForKey:@"status"] isEqualToString:@"安全"]) {

        if ([name isEqualToString:@"午睡中"]) {
            [self.sleepMenuTableView goCenter];
        }
        if ([name isEqualToString:@"散步中"]) {
            [self.walkMenuTableView goCenter];

        }
        if ([name isEqualToString:@"在園中"]) {
            [self.homeMenuTableView goCenter];
        }
        [self showAlertActionWithName:name];
        
    }

}
- (void)showAlertActionWithName:(NSString *)name
{
    NSString *content = ![name isEqualToString:@"午睡中"] ? @"安全地帯を出てしまったお子さんもいるかもしれませんので、ご確認ください。" : @"お子さまの再確認をお願いします。";
    NSString *sureStr = ![name isEqualToString:@"午睡中"] ? @"アラート停止" : @"確認する";
    
        
    [self addLocalNoticeWithName:name];
        //调用系统震动
        [self getChatMessageGoToShake];
        //调用系统声音
        [self getChatMessageGoToSound];
    
        [BWAlertCtrl alertControllerWithTitle:@"ご注意ください！" buttonArray:@[sureStr] message:content preferredStyle:UIAlertControllerStyleAlert clickBlock:^(NSString *buttonTitle) {
            
            if ([buttonTitle isEqualToString:sureStr]) {
            }
            
        }];
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
    //调用系统声音
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received3",@"caf"];
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
    
    NSString *body = ![name isEqualToString:@"午睡中"] ? @"安全地帯を出てしまったお子さんもいるかもしれませんので、ご確認ください。" : @"お子さまの再確認をお願いします。";
    NSString *subtitle = ![name isEqualToString:@"午睡中"] ? @"危険" : @"要注意";
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"ご注意ください！";
        content.subtitle = subtitle;
        // 内容
        content.body = body;
        // 声音
//        content.sound = [UNNotificationSound defaultSound];
        content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
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
         notif.soundName = UILocalNotificationDefaultSoundName;
         // 每周循环提醒
         notif.repeatInterval = NSCalendarUnitWeekOfYear;
         
         [[UIApplication sharedApplication] scheduleLocalNotification:notif];

    }
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
        [lastView setBgImage:lastView.isExcept ? [UIImage imageNamed:@"Ellipse.png"] : [UIImage imageNamed:@""]];
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
    [lastView setBgImage:lastView.isExcept ? [UIImage imageNamed:@"Ellipse.png"] : [UIImage imageNamed:@""]];
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
        _locationManager.distanceFilter = 20;//设置定位频率，每隔多少米定位一次
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
- (HSettingVC *)settingVC
{
    if (!_settingVC) {
        _settingVC = [[HSettingVC alloc] init];
        _settingVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _settingVC;
}
- (HWalkDownTimeView *)downTimeView
{
    if (!_downTimeView) {
        _downTimeView = [[HWalkDownTimeView alloc] init];
    }
    return _downTimeView;
}
@end
