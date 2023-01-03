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
#import "HWalkTask.h"
#import "BWChangeTaskStateReq.h"
#import "BWChangeTaskStateResp.h"
#import "HCustomNavigationView.h"
#import "HSmallCardView.h"

#import "HHomeMenuView.h"
#import "HWalkMenuView.h"

#import "HSleepMainView.h"




@interface HMapVC ()<GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic,strong) HMenuHomeVC *menuHomeVC;
@property (nonatomic,strong) HWalkMenuVC *menuWalkVC; //选择散步弹出的页面
@property (nonatomic,strong) HSleepMenuVC *menuSleepVC;//选择午睡弹出的页面
@property (nonatomic,strong) GMSMapView *mapView;//谷歌地图
@property (nonatomic,strong) GMSMarker *marker;//大头针
@property (nonatomic,strong) GMSPlacesClient * placesClient;//可以获取某个地方的信息
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic,strong) NSArray *exceptArray;
@property (nonatomic,strong) NSArray *nomalArray;
@property (nonatomic,assign) BOOL firstLocationUpdate;
@property (nonatomic,assign) BOOL isDrawFence;  //是否画围栏 防止重复画
@property (nonatomic,assign) BOOL isInGard;//在院内
@property (nonatomic,assign) BOOL isInDest;//在目的地
@property (nonatomic,strong) HLocation *fenceLocation;
@property (nonatomic,strong) CLLocation *gpsLocation;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *shakeTimer;
@property (nonatomic,strong) NSTimer *dangerTimer;
@property (nonatomic,strong) HStudentStateInfoView *stateInfoView;//点击地图上小朋友显示详情页
@property (nonatomic,strong) HWalkTask *currentTask;//当前任务
@property (nonatomic,strong) NSMutableArray *makerList;//保存所有孩子maker
@property (nonatomic,strong) HCustomNavigationView *customNavigationView;
@property (nonatomic,assign) BOOL isAlert; //只弹窗一次 仅演示使用
@property (nonatomic,strong) HHomeMenuView *homeMenuTableView; //首页底部菜单
@property (nonatomic,strong) HWalkMenuView *walkMenuTableView; //散步底部菜单

@property (nonatomic,strong) HSleepMainView *sleepMainView;  //开始午睡时展示


@end

@implementation HMapVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置屏幕常亮
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    //开启定时器
     [self.timer setFireDate:[NSDate distantPast]];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //取消设置屏幕常亮
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(startGetStudentLocationRequest) userInfo:nil repeats:YES];
        
//    //获取当前散步的任务情况
//    [self getTaskRequest];
//
    //回调的监控
//    [self modeChangeBlock];
//
    
    //设置地图
    [self createMapView];
    
    //创建导航
    [self createNavigationView];
    //设置导航栏信息
    [self.customNavigationView defautInfomation];
    
    //设置首页底部菜单
    [self setupHomeMenu];
    
    //设置散步页底部菜单
    [self setupWalkMenu];
    //设置小朋友详情页
    [self setupStudentInfoView];
    
    //加载假数据小朋友的
    [self reloadData];

}
- (void)createNavigationView
{
    [self.view addSubview:self.customNavigationView];
    [self.customNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(156));
    }];
}
- (void)createMapView
{
    [self.view addSubview:self.mapView];
    
}
- (void)setupHomeMenu
{
    //20为状态栏高度；tableview设置的大小要和view的大小一致
    HHomeMenuView *homeMenuView = [[HHomeMenuView alloc] initWithFrame:CGRectMake(0, BW_StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.homeMenuTableView = homeMenuView;
    [self.view addSubview:homeMenuView];
    
    DefineWeakSelf;
    homeMenuView.showSleepMenu = ^{
        [weakSelf presentViewController:weakSelf.menuSleepVC animated:YES completion:nil];

    };
    homeMenuView.showWalkMenu = ^{
        [weakSelf presentViewController:weakSelf.menuWalkVC animated:YES completion:nil];
    };

   
    //开始午睡
    weakSelf.menuSleepVC.startSleepBlock = ^{
        [weakSelf startSleepModel];
    };
    
    //开始散步
    weakSelf.menuWalkVC.startWalkBlock = ^(HWalkTask * _Nonnull walkTask) {
        [weakSelf startWalkMode];
    };
}

//设置散步菜单
- (void)setupWalkMenu
{
    //20为状态栏高度；tableview设置的大小要和view的大小一致
    HWalkMenuView *walkMenuView = [[HWalkMenuView alloc] initWithFrame:CGRectMake(0, BW_StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    walkMenuView.hidden = YES;
    self.walkMenuTableView = walkMenuView;
    [self.view addSubview:walkMenuView];
    
    DefineWeakSelf;
    //结束散步
    walkMenuView.walkEndBlock = ^{
        [weakSelf endMode];
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
- (void)setupSleepMainView
{
    [self.view addSubview:self.sleepMainView];
    [self.sleepMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PAaptation_y(148));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height - PAaptation_y(161));
    }];
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
        //任务状态，1新建 2途中，3目的地，4回程，5结束
        
        //测试用
//        [weakSelf startDestMode];
        //测试用
        
        if ([weakSelf.currentTask.status isEqualToString:@"1"]) {
            
            [weakSelf startStayMode];
        }
        if ([weakSelf.currentTask.status isEqualToString:@"2"]) {
            
            [weakSelf startWalkMode];
        }
        if ([weakSelf.currentTask.status isEqualToString:@"3"]) {
           
            [weakSelf startDestMode];
        }
        if ([weakSelf.currentTask.status isEqualToString:@"4"]) {
            
            [weakSelf startBackMode];
        }
        if ([weakSelf.currentTask.status isEqualToString:@"5"]) {
            
            [weakSelf endMode];
        }

//        [weakSelf changeTaskStateRequestWithStatus:@"5"];

        
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
        
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//开启园内模式
- (void)startStayMode
{
    self.isDrawFence = YES;
    
    [self.mapView clear];
    [self.makerList removeAllObjects];

    [self getKinderRequest];
}
//开启散步模式
- (void)startWalkMode
{
    self.isDrawFence = YES;
    
    [self.makerList removeAllObjects];

    [self.mapView clear];
    
    //开启定位
    [self startLocation];
    
    self.homeMenuTableView.hidden = YES;
    self.walkMenuTableView.hidden = NO;
                
//    [self startDestRequest];
    
//    [self changeTaskStateRequestWithStatus:@"2"];
    
}
//开启目的地模式
- (void)startDestMode
{
    [self.makerList removeAllObjects];

    self.isDrawFence = YES;

    [self.mapView clear];

    //开启定位
    [self startLocation];
    
//    self.menuHomeVC.view.hidden = YES;
        
        
//    self.gpsButton.hidden = NO;
    
    [self startDestRequest];
}
//开启返程模式
- (void)startBackMode
{
    [self.makerList removeAllObjects];

    self.isDrawFence = YES;

    [self.mapView clear];

}
//结束任务模式
- (void)endMode
{
    [self.makerList removeAllObjects];

    self.isDrawFence = YES;

    [self.mapView clear];
    
    self.homeMenuTableView.hidden = NO;
    self.walkMenuTableView.hidden = YES;

}
//开始午睡模式
- (void)startSleepModel
{
    [self.makerList removeAllObjects];
    [self.mapView clear];
    [self.mapView removeFromSuperview];
    self.homeMenuTableView.hidden = YES;
    self.walkMenuTableView.hidden = YES;
    
    [self setupSleepMainView];
    
    
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
        
        [weakSelf startGetStudentLocationRequest];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}

//获取目的地接口数据
- (void)startDestRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DefineWeakSelf;
    BWDestnationInfoReq *infoReq = [[BWDestnationInfoReq alloc] init];
//    infoReq.dId = self.currentTask.destinationId; //1目的地
    infoReq.dId = @"1"; //1目的地

    [NetManger getRequest:infoReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWDestnationInfoResp *infoResp = (BWDestnationInfoResp *)resp;
        [weakSelf changeLocationInfoDataWithModel:[infoResp.itemList safeObjectAtIndex:0]];
        
        [weakSelf startGetStudentLocationRequest];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//获取学生坐标信息
- (void)startGetStudentLocationRequest
{
    DefineWeakSelf;
    BWStudentLocationReq *locationReq = [[BWStudentLocationReq alloc] init];
    locationReq.latitude = self.gpsLocation.coordinate.latitude;
    locationReq.longitude = self.gpsLocation.coordinate.longitude;
    [NetManger postRequest:locationReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWStudentLocationResp *locationResp = (BWStudentLocationResp *)resp;
        weakSelf.nomalArray = locationResp.normalKids;
        weakSelf.exceptArray = locationResp.exceptionKids;
        
        [weakSelf reloadData];
        [weakSelf addMarkers]; //添加学生位置坐标
        [weakSelf drawPolygon];
        [weakSelf setupNavInfomation];
        
//        weakSelf.walkStateView.nomalArray = weakSelf.nomalArray;
//        weakSelf.walkStateView.exceptArray = weakSelf.exceptArray;
//
//        if (weakSelf.exceptArray.count != 0) {
//            [weakSelf.walkStateView goCenter];;
//        }
//
//        [weakSelf.walkStateView tableReload];
//        [weakSelf.menuHomeVC tableReload];
        
        
        
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
    
    
}
- (void)modeChangeBlock
{
    DefineWeakSelf;
   
//    //打开午睡菜单
//    self.menuHomeVC.showSleepMenu = ^{
//        [weakSelf presentViewController:weakSelf.menuSleepVC animated:YES completion:nil];
//
//    };
//
//    //打开散步菜单
//    self.menuHomeVC.showWalkMenu = ^{
//        [weakSelf presentViewController:weakSelf.menuWalkVC animated:YES completion:nil];
//    };
//
//    //开启散步模式
//    self.menuWalkVC.startWalkBlock = ^(HWalkTask * _Nonnull walkTask) {
//
//        [weakSelf startWalkMode];
//
//    };
    
//    //结束散步模式
//    self.walkStateView.walkEndBlock = ^{
//
//        [weakSelf startStayMode];
//
////        weakSelf.menuHomeVC.view.hidden = NO;
//        weakSelf.walkStateView.hidden = YES;
//        weakSelf.mapView.myLocationEnabled = NO;
//
//        [weakSelf.locationManager stopUpdatingLocation];
//
//    };
//
//
//
//    self.walkStateView.clickGpsBlock = ^{
//        //替换自己的坐标
//         CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(weakSelf.gpsLocation.coordinate.latitude, weakSelf.gpsLocation.coordinate.longitude);
//        weakSelf.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:16];
//    };
}

- (void)setupNavInfomation{
    
    
    if (self.currentTask.status.integerValue == 1) {
        NSLog(@"在园中模式");
        if (self.exceptArray.count == 0) {
            

            self.customNavigationView.titleLabel.text = @"在園中";
            self.customNavigationView.stateLabel.text = @"安全";
            self.customNavigationView.stateLabel.textColor = BWColor(0, 176, 107, 1);
            [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_safe.png"]];

            self.customNavigationView.updateTimeLabel.text = @"最終更新：20秒";
            self.customNavigationView.updateTimeLabel.textColor = BWColor(0, 176, 107, 1);
            
            self.customNavigationView.userNameLabel.text = @"ひまわり";
            [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"safe.png"]];
            [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"teacher.png"]];
        }else{

            [self showAlertAction];

            
            [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_danger.png"]];
            self.customNavigationView.titleLabel.text = @"在園中";
            self.customNavigationView.stateLabel.text = @"危险";
            self.customNavigationView.stateLabel.textColor = BWColor(164, 0, 0, 1);
            self.customNavigationView.updateTimeLabel.text = @"最終更新：20秒";
            self.customNavigationView.updateTimeLabel.textColor = BWColor(164, 0, 0, 1);
        
            self.customNavigationView.userNameLabel.text = @"ひまわり";
            [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"dangerNav.png"]];
            [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"teacher.png"]];
        }
    }
    if (self.currentTask.status.integerValue == 2) {
        NSLog(@"散步模式");
        
        if (self.exceptArray.count == 0) {
            
            self.customNavigationView.titleLabel.text = @"散歩中（経路）";
            self.customNavigationView.stateLabel.text = @"安全";
            self.customNavigationView.stateLabel.textColor = BWColor(0, 176, 107, 1);
            [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_safe.png"]];

            self.customNavigationView.updateTimeLabel.text = @"最終更新：20秒";
            self.customNavigationView.updateTimeLabel.textColor = BWColor(0, 176, 107, 1);
            
            self.customNavigationView.userNameLabel.text = @"ひまわり";
            [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"safe.png"]];
            [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"teacher.png"]];
        }else{
            
            [self showAlertAction];

            [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_danger.png"]];
            self.customNavigationView.titleLabel.text = @"散歩中（経路）";
            self.customNavigationView.stateLabel.text = @"危险";
            self.customNavigationView.stateLabel.textColor = BWColor(164, 0, 0, 1);
            self.customNavigationView.updateTimeLabel.text = @"最終更新：20秒";
            self.customNavigationView.updateTimeLabel.textColor = BWColor(164, 0, 0, 1);
        
            self.customNavigationView.userNameLabel.text = @"ひまわり";
            [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"dangerNav.png"]];
            [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"teacher.png"]];
        }
    }
    if (self.currentTask.status.integerValue == 3) {
        NSLog(@"目的地模式");
        
        if (self.exceptArray.count == 0) {
            
            self.customNavigationView.titleLabel.text = @"散歩中（目的地）";
            self.customNavigationView.stateLabel.text = @"安全";
            self.customNavigationView.stateLabel.textColor = BWColor(0, 176, 107, 1);
            [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_safe.png"]];

            self.customNavigationView.updateTimeLabel.text = @"最終更新：20秒";
            self.customNavigationView.updateTimeLabel.textColor = BWColor(0, 176, 107, 1);
            
            self.customNavigationView.userNameLabel.text = @"ひまわり";
            [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"safe.png"]];
            [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"teacher.png"]];
        }else{
            
            [self showAlertAction];

            
            [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_danger.png"]];
            self.customNavigationView.titleLabel.text = @"散歩中（目的地）";
            self.customNavigationView.stateLabel.text = @"危险";
            self.customNavigationView.stateLabel.textColor = BWColor(164, 0, 0, 1);
            self.customNavigationView.updateTimeLabel.text = @"最終更新：20秒";
            self.customNavigationView.updateTimeLabel.textColor = BWColor(164, 0, 0, 1);
        
            self.customNavigationView.userNameLabel.text = @"ひまわり";
            [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"dangerNav.png"]];
            [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"teacher.png"]];
        }
    }


    

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
    
    self.isDrawFence = NO;
    
}
-(void)addMarkers{
    
    for (NSInteger i = 0;i<self.exceptArray.count;i++) {
                
        HStudent *student = [self.exceptArray safeObjectAtIndex:i];

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
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
        
        [self dealWithTaskStateChangeWithStudent:student withNomal:NO];
        
        
        if (![self.makerList containsObject:marker]) {
            [self.makerList addObject:marker];
        }
        
    }
    for (NSInteger i = 0;i<self.nomalArray.count;i++) {
        HStudent *student = [self.nomalArray safeObjectAtIndex:i];
        
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
        
        [self dealWithTaskStateChangeWithStudent:student withNomal:YES];
        
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
//分析当前任务状态及切换
- (void)dealWithTaskStateChangeWithStudent:(HStudent *)student withNomal:(BOOL)isNomal
{

    if (self.currentTask.status.integerValue == 1) {
        NSLog(@"当前为院内模式");

        NSLog(@"手动切换到散步模式");
        
    }
    if (self.currentTask.status.integerValue == 2) {
        
        NSLog(@"当前为散步模式");

        if (student.deviceInfo.currentLocation.integerValue != 3) {
            
            self.isInDest = NO;
            return;
        }else{
            self.isInDest = YES;
            NSLog(@"到达目的地");
        }
        
    }
    if (self.currentTask.status.integerValue == 3) {
        
        NSLog(@"当前为目的地模式");

        NSLog(@"手动切换到返回模式");

    }
    if (self.currentTask.status.integerValue == 4) {
        NSLog(@"当前为返程模式");

        if (student.deviceInfo.currentLocation.integerValue != 1) {
            
            self.isInGard = NO;
            return;
        }else{
            self.isInGard = YES;
            NSLog(@"返回到院内");
        }
    }
    if (self.currentTask.status.integerValue == 5) {
        NSLog(@"当前为结束");

    }
    

}

//-(void)navRightClick{
//    GMSAutocompleteViewController *autocompleteViewController = [[GMSAutocompleteViewController alloc] init];
//    autocompleteViewController.delegate = self;
//    [self presentViewController:autocompleteViewController animated:YES completion:nil];
//}
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
            [except addObject:student];
        }

        self.exceptArray = except;
    //
        NSMutableArray *nomal = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i<12; i++) {
            HStudent *student = [[HStudent alloc] init];
            student.avatar = @"https://img0.baidu.com/it/u=2643936262,3742092684&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=357";
            student.sId = [NSString stringWithFormat:@"%ld",300+i];
            student.name = @"asdfsa";
            [nomal addObject:student];
        }

        self.nomalArray = nomal;

    
    self.homeMenuTableView.safeList = self.nomalArray;
    self.homeMenuTableView.exceptList = self.exceptArray;
    [self.homeMenuTableView reloadData];
    
    self.walkMenuTableView.safeList = self.nomalArray;
    self.walkMenuTableView.exceptList = self.exceptArray;
    [self.walkMenuTableView reloadData];
}


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
- (void)showAlertAction
{
//    [self.shakeTimer setFireDate:[NSDate distantPast]];

    if (!self.isAlert) {
        
        [self addLocalNotice];
        //调用系统震动
        [self getChatMessageGoToShake];
        //调用系统声音
        [self getChatMessageGoToSound];
        
        DefineWeakSelf;
        [BWAlertCtrl alertControllerWithTitle:@"ご注意ください！" buttonArray:@[@"アラート停止"] message:@"安全地帯を出てしまったお子さんもいるかもしれませんので、ご確認ください。" preferredStyle:UIAlertControllerStyleAlert clickBlock:^(NSString *buttonTitle) {
            
            if ([buttonTitle isEqualToString:@"アラート停止"]) {
    //            [weakSelf.shakeTimer setFireDate:[NSDate distantFuture]];
                weakSelf.isAlert = YES;

            }
            
        }];
    }

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
- (void)addLocalNotice {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"ご注意ください！";
        content.subtitle = @"危険";
        // 内容
        content.body = @"安全地帯を出てしまったお子さんもいるかもしれませんので、ご確認ください。";
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
        [self startGetStudentLocationRequest];

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

- (HWalkMenuVC *)menuWalkVC
{
    if (!_menuWalkVC) {
        _menuWalkVC = [[HWalkMenuVC alloc] init];

    }
    return _menuWalkVC;
}
- (HSleepMenuVC *)menuSleepVC
{
    if (!_menuSleepVC) {
        _menuSleepVC = [[HSleepMenuVC alloc] init];
    }
    return _menuSleepVC;
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
- (HSleepMainView *)sleepMainView
{
    if (!_sleepMainView) {
        _sleepMainView = [[HSleepMainView alloc] init];
    }
    return _sleepMainView;
}
@end
