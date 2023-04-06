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

@interface HMapVC ()<GMSMapViewDelegate,CLLocationManagerDelegate>
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
@property (nonatomic,assign) BOOL isWalkMode;                       //在目的地
@property (nonatomic,assign) BOOL firstLocationUpdate;              //第一次定位更新
@property (nonatomic,assign) BOOL isDrawFence;                      //是否画围栏 防止重复画
@property (nonatomic,assign) BOOL isInGard;                         //在院内
@property (nonatomic,assign) BOOL isInDest;                         //在目的地


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

    
    self.walkTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(startGetStudentLocationRequest) userInfo:nil repeats:YES];

    self.sleepTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getSleepTaskRequest) userInfo:nil repeats:YES];
    
    [self.walkTimer setFireDate:[NSDate distantFuture]];

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

    //加载假数据小朋友的
//    [self reloadData];
    
    //监听危险
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dangerAlertNotifi:) name:@"dangerAlertNotification" object:nil];
    //退出账户
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutAction:) name:@"quitAccountNoti" object:nil];
    

    
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
    homeMenuView.gpsBlock = ^{
        CLLocationCoordinate2D coordinate;
        if (weakSelf.gpsLocation == nil) {
            coordinate = CLLocationCoordinate2DMake(weakSelf.fenceLocation.locationInfo.latitude, weakSelf.fenceLocation.locationInfo.longitude);
        }else{
            coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);
        }
        //移动地图中心到当前位置
        weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
    };
    homeMenuView.toTopBlock = ^{
        weakSelf.homeMenuTableView.gpsButton.hidden = YES;
        weakSelf.homeMenuTableView.smallView.hidden = YES;
    };
    homeMenuView.toBottomBlock = ^{
        weakSelf.homeMenuTableView.gpsButton.hidden = NO;
        weakSelf.homeMenuTableView.smallView.hidden = NO;
    };
    
}

//设置散步菜单
- (void)setupWalkMenu
{
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
    self.walkMenuTableView.openReport = ^{
        NSLog(@"打开日历");
        HDateVC *dateVC = [[HDateVC alloc] init];
        [weakSelf presentViewController:dateVC animated:YES completion:nil];
    };
    self.walkMenuTableView.gpsBlock = ^{
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);
        //移动地图中心到当前位置
        weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
    };
    
}
//设置午睡菜单
- (void)setupSleepMenu
{
//    CGFloat topH = SCREEN_HEIGHT/2-PAaptation_y(121);
    CGFloat topH = 0;

    //20为状态栏高度；tableview设置的大小要和view的大小一致
    self.sleepMenuTableView = [[HSleepMenuView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(400), SCREEN_WIDTH, SCREEN_HEIGHT-topH)];
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
    
    DefineWeakSelf;
    //marks的详情
    self.stateInfoView.closeBlock = ^{
        [weakSelf hideStateInfoView];

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
        weakSelf.isWalkMode = YES;
        [weakSelf startWalkMode];
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
        
//        [weakSelf startStayMode];
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
            weakSelf.isWalkMode = NO;
            [weakSelf startStayMode];
            return;
        }
        //任务状态，1新建 2途中，3目的地，4回程，5结束
        //type 1散步 2午睡
        if ([weakSelf.currentTask.type isEqualToString:@"1"]) {
            
            //散步模式开启
            if ([weakSelf.currentTask.status isEqualToString:@"1"]) {
                weakSelf.isWalkMode = YES;
                [weakSelf startWalkMode];
            }
            //该任务已完成
            if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask == nil) {
                weakSelf.isWalkMode = NO;
                //在院内模式
                [weakSelf startStayMode];
            }
        }else{

            //午睡模式开始
            if ([weakSelf.currentTask.status isEqualToString:@"1"]) {
                
                [weakSelf startSleepMode];
            }
            //午睡模式结束 默认院内模式
            if ([weakSelf.currentTask.status isEqualToString:@"5"] || weakSelf.currentTask == nil) {
               
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
        
        if ([weakSelf.currentTask.type isEqualToString:@"1"]) {
            
            [weakSelf showWalkReport];

        }else{
            [weakSelf showSleepReport];

        }
        
        //结束上一个任务改变该任务状态 并且查寻新的任务；
        [weakSelf getTaskRequest];
        
        
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
    
    [self startLocation];                   //开启定位
    
    [self.sleepTimer setFireDate:[NSDate distantFuture]];
    
    [self getKinderRequest];                //获取围栏的信息
    
    
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
//开启散步模式
- (void)startWalkMode
{
    [self clearMap];
    
    //设置散步页底部菜单
    [self setupWalkMenu];
    
    self.homeMenuTableView.hidden = YES;
    
    //开启定位
    [self startLocation];
    
    [self.walkTimer setFireDate:[NSDate distantPast]];
    [self.sleepTimer setFireDate:[NSDate distantFuture]];

}
//开启目的地模式
//- (void)startDestMode
//{
//
//    [self clearMap];
//
//    //开启定位
//    [self startLocation];
    
//    self.menuHomeVC.view.hidden = YES;
        
        
//    self.gpsButton.hidden = NO;
    
//    [self startDestRequest];
//}
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

    self.isDrawFence = YES;

    [self.mapView clear];
    
    [self.locationManager stopUpdatingLocation];

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
        [weakSelf changeLocationInfoDataWithModel:[kinderResp.itemList safeObjectAtIndex:0]];
        
        //2023.02.16先注释掉
//        [weakSelf startGetStudentLocationRequest];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}

////获取目的地接口数据
//- (void)startDestRequest
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    DefineWeakSelf;
//    BWDestnationInfoReq *infoReq = [[BWDestnationInfoReq alloc] init];
////    infoReq.dId = self.currentTask.destinationId; //1目的地
//    infoReq.dId = @"1"; //1目的地
//
//    [NetManger getRequest:infoReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//
//        BWDestnationInfoResp *infoResp = (BWDestnationInfoResp *)resp;
//        [weakSelf changeLocationInfoDataWithModel:[infoResp.itemList safeObjectAtIndex:0]];
//
//        [weakSelf startGetStudentLocationRequest];
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

    DefineWeakSelf;
    BWStudentLocationReq *locationReq = [[BWStudentLocationReq alloc] init];
    if (self.gpsLocation == nil) {
        //先用围栏坐标替换
        locationReq.latitude = self.fenceLocation.locationInfo.latitude;
        locationReq.longitude = self.fenceLocation.locationInfo.longitude;
    }else{
        locationReq.latitude = self.gpsLocation.coordinate.latitude;
        locationReq.longitude = self.gpsLocation.coordinate.longitude;
    }

    [NetManger postRequest:locationReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWStudentLocationResp *locationResp = (BWStudentLocationResp *)resp;

        if (weakSelf.isWalkMode) {
            NSString *status = locationResp.exceptionKids.count != 0 ? @"危険" : @"安全";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"散步中",@"status":status}];
            
            weakSelf.walkMenuTableView.safeList = locationResp.normalKids;
            weakSelf.walkMenuTableView.exceptList = locationResp.exceptionKids;
            [weakSelf.walkMenuTableView.tableView reloadData];
        }else{
            NSString *status = locationResp.exceptionKids.count != 0 ? @"危険" : @"安全";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dangerAlertNotification" object:@{@"name":@"在園中",@"status":status}];
            
            weakSelf.homeMenuTableView.smallView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",locationResp.normalKids.count];
            weakSelf.homeMenuTableView.smallView.dangerLabel.text = [NSString stringWithFormat:@"アラート%ld回",locationResp.exceptionKids.count];
            weakSelf.homeMenuTableView.safeList = locationResp.normalKids;
            weakSelf.homeMenuTableView.exceptList = locationResp.exceptionKids;
            [weakSelf.homeMenuTableView.tableView reloadData];
        }

//        [weakSelf addMarkersWithNomalList:locationResp.normalKids andExceptList:locationResp.exceptionKids]; //添加学生位置坐标
        [weakSelf drawPolygon];
                
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}

//画围栏
- (void)changeLocationInfoDataWithModel:(HDestnationModel *)model
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    HLocation *myLocation = [[HLocation alloc] init];
    NSArray *fence = [model.fence componentsSeparatedByString:@"_"];
    for (NSInteger i = 0; i< fence.count; i++) {
        NSString *gpsStr = [fence safeObjectAtIndex:i];
        NSArray *gpsArray = [gpsStr componentsSeparatedByString:@","];
        HLocationInfo *info = [[HLocationInfo alloc] init];
        info.longitude = [[gpsArray safeObjectAtIndex:0] doubleValue];
        info.latitude = [[gpsArray safeObjectAtIndex:1] doubleValue];
        [tempArray addObject:info];
    }
    NSString *currentStr = model.location;
    NSArray *currentArray = [currentStr componentsSeparatedByString:@","];
    myLocation.fenceArray = tempArray;
    HLocationInfo *currentInfo = [[HLocationInfo alloc] init];
    currentInfo.longitude = [[currentArray safeObjectAtIndex:0] doubleValue];
    currentInfo.latitude = [[currentArray safeObjectAtIndex:1] doubleValue];
    myLocation.locationInfo = currentInfo;
    
    //围栏坐标信息
    self.fenceLocation = myLocation;
    
    //获取到围栏坐标后 开启刷小朋友信息接口
    [self.walkTimer setFireDate:[NSDate distantPast]];

}

//画围栏
-(void)drawPolygon
{
    if (!self.isDrawFence) {
        return;
    }

    GMSMutablePath* path = [[GMSMutablePath alloc] init];
    
    for (NSInteger i = 0; i < self.fenceLocation.fenceArray.count; i++) {
        HLocationInfo *info = [self.fenceLocation.fenceArray safeObjectAtIndex:i];
        [path addCoordinate:CLLocationCoordinate2DMake(info.latitude, info.longitude)];
    }

    GMSPolygon* poly = [GMSPolygon polygonWithPath:path];
    poly.strokeWidth = 2.0;
    poly.strokeColor = BWColor(83, 192, 137, 1);
    poly.fillColor = BWColor(0, 176, 107, 0.2);
    poly.map = self.mapView;
    
    
    CLLocationCoordinate2D coordinate;
    if (self.gpsLocation == nil) {
        coordinate = CLLocationCoordinate2DMake(self.fenceLocation.locationInfo.latitude, self.fenceLocation.locationInfo.longitude);
    }else{
        coordinate = CLLocationCoordinate2DMake(self.gpsLocation.coordinate.latitude, self.gpsLocation.coordinate.longitude);
    }
    //移动地图中心到当前位置
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
    
    self.isDrawFence = NO;
    
}
-(void)addMarkersWithNomalList:(NSArray *)normalKids andExceptList:(NSArray *)exceptionKids{
    
    for (NSInteger i = 0;i<exceptionKids.count;i++) {
                
        HStudent *student = [exceptionKids safeObjectAtIndex:i];

        CGRect ellipseframe = CGRectMake(0, 0, PAdaptation_x(80), PAaptation_y(80));
        UIImageView *ellipseView = [[UIImageView alloc] initWithFrame:ellipseframe];
        [ellipseView setImage:[UIImage imageNamed:@"Ellipse.png"]];
        
        CGRect frame = CGRectMake(PAdaptation_x(80)/2 - PAdaptation_x(40)/2, PAaptation_y(80)/2 - PAaptation_y(40)/2, PAdaptation_x(40), PAaptation_y(40));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = PAaptation_y(40)/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = BWColor(255, 75, 0, 1).CGColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        [ellipseView addSubview:imageView];
        
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
    for (NSInteger i = 0;i<normalKids.count;i++) {
        HStudent *student = [normalKids safeObjectAtIndex:i];
        
        CGRect frame = CGRectMake(0, 0, PAdaptation_x(40), PAaptation_y(40));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = PAaptation_y(40)/2;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
        
        GMSMarker *marker = [self findMarkerWithStudentId:student.sId];
        if (marker == nil) {
            marker = [[GMSMarker alloc] init];
        }
        marker.title = student.name;
        marker.iconView = imageView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
                
        if (![self.makerList containsObject:marker]) {
            [self.makerList addObject:marker];
        }
    }
    

//
//    if (self.myLocation.fenceArray.count == 0) {
//        return;
//    }
//
//    if (self.isDrawFence) {
//
//        if (self.currentTask.status.integerValue == 1) {
//            //替换自己的坐标
//            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.myLocation.locationInfo.latitude, self.myLocation.locationInfo.longitude);
//             //移动地图中心到当前位置
//            self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:18];
//
//        }
//
//        [self drawPolygon];//画围栏
//
//        self.isDrawFence = NO;//每个状态围栏就画一次
//
//    }
    
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

//- (void)reloadData
//{
//    //    //测试用
//        NSMutableArray *except = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i<10; i++) {
//            HStudent *student = [[HStudent alloc] init];
//            student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
//            student.sId = [NSString stringWithFormat:@"%ld",100+i];
//            student.name = @"asdfsa";
//            student.exceptionTime = @"123";
//            student.distance = @"200";
//            [except addObject:student];
//        }
//
//        self.exceptArray = except;
//    //
//        NSMutableArray *nomal = [[NSMutableArray alloc] init];
//        for (NSInteger i = 0; i<12; i++) {
//            HStudent *student = [[HStudent alloc] init];
//            student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
//            student.sId = [NSString stringWithFormat:@"%ld",300+i];
//            student.name = @"asdfsa";
//            [nomal addObject:student];
//        }
//
//        self.nomalArray = nomal;
//
//
//    self.homeMenuTableView.safeList = self.nomalArray;
//    self.homeMenuTableView.exceptList = self.exceptArray;
//    [self.homeMenuTableView reloadData];
//
//
//}


- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用

        [self.locationManager startUpdatingLocation];
    } else {
        //定位不能用
//        [self locationPermissionAlert];
//        [SVProgressHUD dismiss];
        [MBProgressHUD showMessag:@"定位不可用，请开启定位设置" toView:self.view hudModel:MBProgressHUDModeText hide:YES];
    }

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
//    [self.shakeTimer setFireDate:[NSDate distantPast]];

//    if (!self.isAlert) {
    
    NSString *content = ![name isEqualToString:@"午睡中"] ? @"安全地帯を出てしまったお子さんもいるかもしれませんので、ご確認ください。" : @"お子さまの再確認をお願いします。";
    NSString *sureStr = ![name isEqualToString:@"午睡中"] ? @"アラート停止" : @"確認する";
    
        
    [self addLocalNoticeWithName:name];
        //调用系统震动
        [self getChatMessageGoToShake];
        //调用系统声音
        [self getChatMessageGoToSound];
        
//        DefineWeakSelf;

    
        [BWAlertCtrl alertControllerWithTitle:@"ご注意ください！" buttonArray:@[sureStr] message:content preferredStyle:UIAlertControllerStyleAlert clickBlock:^(NSString *buttonTitle) {
            
            if ([buttonTitle isEqualToString:sureStr]) {
    //            [weakSelf.shakeTimer setFireDate:[NSDate distantFuture]];
//                weakSelf.isAlert = YES;

            }
            
        }];
//    }

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
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
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
         self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
        
//        [self startGetStudentLocationRequest];

    } else {
        [self.locationManager stopUpdatingLocation]; //停止获取
        [NSThread sleepForTimeInterval:10]; //阻塞10秒
        [self.locationManager startUpdatingLocation]; //重新获取
        
    }

//        [self getPlace:_coordinate2D];
//    }
    
}


//-(void)getPlace:(CLLocationCoordinate2D)coordinate2D{
//
//    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coordinate2D.latitude, coordinate2D.longitude) completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
//        if(!error){
//            GMSAddress* addressObj = response.firstResult;
//            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
//            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
//            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
//            NSLog(@"locality=%@", addressObj.locality);
//            NSLog(@"subLocality=%@", addressObj.subLocality);
//            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
//            NSLog(@"postalCode=%@", addressObj.postalCode);
//            NSLog(@"country=%@", addressObj.country);
//            NSLog(@"lines=%@", addressObj.lines);
//        }else{
//            NSLog(@"地理反编码错误");
//        }
//    }];
//}

-(BOOL)mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    [self hideStateInfoView];
    
    HStudent *student = marker.userData;
    NSLog(@"点击了%@",student.name);
    [self.stateInfoView setInfomationWithModel:student];
    [self showStateInfoView];

    return YES;
}
- (void)showStateInfoView
{
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.stateInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT - PAaptation_y(351), SCREEN_WIDTH, PAaptation_y(351))];
    }];
}
- (void)hideStateInfoView
{
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.stateInfoView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, PAaptation_y(351))];
    }];
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
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38.02 longitude:114.52 zoom:15];
        _mapView = [GMSMapView mapWithFrame:CGRectMake(0, PAaptation_y(148), SCREEN_WIDTH,self.view.frame.size.height - PAaptation_y(161)) camera:camera];
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
        _stateInfoView.backgroundColor = [UIColor whiteColor];
        
    }
    return _stateInfoView;
}
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
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
@end
