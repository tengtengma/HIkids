//
//  HWalkVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HWalkVC.h"
#import "HWalkMenuVC.h"
#import "HWalkTask.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import "HLocation.h"
#import "BWStudentLocationReq.h"
#import "BWStudentLocationResp.h"
#import "HStudent.h"
#import "HSmallCardView.h"
#import "HStudentStateView.h"

@interface HWalkVC ()<GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) HWalkMenuVC *menuVC;
@property (nonatomic, strong) HWalkTask *myTask;
@property (nonatomic, strong) HSmallCardView *smallMenuView;
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, strong) NSArray *exceptArray;
@property (nonatomic, strong) NSArray *nomalArray;

@property (nonatomic, assign) BOOL firstLocationUpdate ;
@property (nonatomic, strong) GMSMarker *marker;//大头针
@property (nonatomic, strong) GMSPlacesClient * placesClient;//可以获取某个地方的信息
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) HStudentStateView *stateView;
@end

@implementation HWalkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.menuVC.view.frame = CGRectMake(0, BW_StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - BW_StatusBarHeight);
    [self.view addSubview:self.menuVC.view];
    
    
    DefineWeakSelf;
    self.menuVC.startWalkBlock = ^(HWalkTask * _Nonnull walkTask) {
        weakSelf.myTask = walkTask;
        [weakSelf.menuVC.view removeFromSuperview];
        
        [weakSelf startMap];
    };
    
    

}
- (void)startMap
{
    [self.view addSubview:self.mapView];
    
    [self startLocation];
    
    [self.stateView setFrame:CGRectMake(0, self.view.frame.size.height - PAaptation_y(120), SCREEN_WIDTH, self.view.frame.size.height  - PAaptation_y(120))];
    [self.view addSubview:self.stateView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStateView)];
    [self.stateView addGestureRecognizer:tap];
    
    DefineWeakSelf;
    self.stateView.closeBlock = ^{
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.stateView setFrame:CGRectMake(0, weakSelf.view.frame.size.height - PAaptation_y(120), SCREEN_WIDTH, weakSelf.view.frame.size.height  - PAaptation_y(120))];
            
            [weakSelf.smallMenuView setFrame:CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - PAaptation_y(224), PAdaptation_x(115), PAaptation_y(79))];
            
        }];
    };
    
    
}
- (void)showStateView
{
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.stateView setFrame:CGRectMake(0, self.view.frame.size.height/2, SCREEN_WIDTH, self.view.frame.size.height  - self.view.frame.size.height/2)];
        
        [weakSelf.smallMenuView setFrame:CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - self.view.frame.size.height/2 - PAaptation_y(24+79), PAdaptation_x(115), PAaptation_y(79))];

    }];
}
- (void)setupNavInfomation{
    
    if (self.exceptArray.count == 0) {
        
        self.customNavigationView.titleLabel.text = @"在園中";
        self.customNavigationView.stateLabel.text = @"安全";
        self.customNavigationView.stateLabel.textColor = BWColor(0, 176, 107, 1);
        [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_safe.png"]];

        self.customNavigationView.updateTimeLabel.text = @"最终更新：3分钟";
        self.customNavigationView.updateTimeLabel.textColor = BWColor(0, 176, 107, 1);
        
        self.customNavigationView.userNameLabel.text = @"ひまわり";
        [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"safe.png"]];
        [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"safe.png"]];
    }else{
        [self.customNavigationView.backgroundImageView setImage:[UIImage imageNamed:@"navBG_danger.png"]];
        self.customNavigationView.titleLabel.text = @"在園中";
        self.customNavigationView.stateLabel.text = @"危险";
        self.customNavigationView.stateLabel.textColor = BWColor(164, 0, 0, 1);
        self.customNavigationView.updateTimeLabel.text = @"最终更新：3分钟";
        self.customNavigationView.updateTimeLabel.textColor = BWColor(164, 0, 0, 1);
    
        self.customNavigationView.userNameLabel.text = @"ひまわり";
        [self.customNavigationView.stateImageView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
        [self.customNavigationView.userImageView setImage:[UIImage imageNamed:@"safe.png"]];
    }
    

}
- (void)startGetStudentLocationRequest
{
    
    DefineWeakSelf;
    BWStudentLocationReq *locationReq = [[BWStudentLocationReq alloc] init];
    locationReq.latitude = 11;
    locationReq.longitude = 1;
    [NetManger postRequest:locationReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWStudentLocationResp *locationResp = (BWStudentLocationResp *)resp;
        weakSelf.nomalArray = locationResp.normalKids;
        weakSelf.exceptArray = locationResp.exceptionKids;
        
        [weakSelf createSmallView];
        [weakSelf addMarkers]; //添加学生位置坐标
        [weakSelf setupNavInfomation];
        
        

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
-(void)addMarkers{
    
    //先清理掉旧的
    [self.marker.map clear];
    self.marker.map = nil;
    
    NSMutableArray *totalArray = [[NSMutableArray alloc] init];
    
    for (HStudent *student in self.exceptArray) {
                
        [totalArray addObject:student];
        
        CGRect frame = CGRectMake(0, 0, PAdaptation_x(40), PAaptation_y(40));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = PAaptation_y(40)/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = BWColor(255, 75, 0, 1).CGColor;
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        
        
        GMSMarker *marker = [[GMSMarker alloc]init];
        marker.title = student.name;
        marker.iconView = imageView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
    }
    for (HStudent *student in self.nomalArray) {
        
        [totalArray addObject:student];

        
        CGRect frame = CGRectMake(0, 0, PAdaptation_x(40), PAaptation_y(40));
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = PAaptation_y(40)/2;
        imageView.layer.masksToBounds = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;

        GMSMarker *marker = [[GMSMarker alloc]init];
        marker.title = student.name;
        marker.iconView = imageView;
        marker.position = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue,student.deviceInfo.longitude.doubleValue);
        marker.userData = student;
        marker.map = self.mapView;
    }
    
    self.stateView.array = totalArray;
    self.stateView.isSafe = self.exceptArray.count == 0 ? YES:NO;
    [self.stateView tableReload];
}

//-(void)navRightClick{
//    GMSAutocompleteViewController *autocompleteViewController = [[GMSAutocompleteViewController alloc] init];
//    autocompleteViewController.delegate = self;
//    [self presentViewController:autocompleteViewController animated:YES completion:nil];
//}
- (void)createSmallView
{
    
    [self.view addSubview:self.smallMenuView];

    self.smallMenuView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",self.nomalArray.count + self.exceptArray.count];
    self.smallMenuView.dangerLabel.text = @"アラート0回";
    
    self.smallMenuView.clickBlock = ^{
        
    };
}
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
        _locationManager.distanceFilter = 10;//设置定位频率，每隔多少米定位一次
        [_locationManager startUpdatingLocation];
    } else {
        //定位不能用
        [self locationPermissionAlert];
//        [SVProgressHUD dismiss];
    }
}

#pragma mark - 系统自带location代理定位
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
        [self locationPermissionAlert];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
//    [SVProgressHUD dismiss];
}
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations {
    if(!_firstLocationUpdate){
//        _firstLocationUpdate = YES;//只定位一次的标记值
        // 获取最新定位 手机自己的定位
        CLLocation *location = locations.lastObject;
        // 停止定位
//        [_locationManager stopUpdatingLocation];


       //替换自己的坐标
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);

        //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
//        _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
        //移动地图中心到当前位置
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:18];

        self.marker = [GMSMarker markerWithPosition:coordinate];
        self.marker.map = self.mapView;

        [self startGetStudentLocationRequest];
        
//        [self getPlace:_coordinate2D];
    }
}
// 获取当前位置权限提示图
- (void)locationPermissionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置访问权限" message:@"请打开位置访问权限,以便于定位您的位置,添加地址信息" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alert addAction:cancle];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)dealloc{
//    [SVProgressHUD dismiss];
    [_locationManager stopUpdatingLocation];
    self.mapView = nil;
}
- (void)backAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCNotification" object:@{@"changeName":@"mapVC"}];
}
#pragma mark - LazyLoad -
- (HWalkMenuVC *)menuVC
{
    if (!_menuVC) {
        _menuVC = [[HWalkMenuVC alloc] init];
    }
    return _menuVC;
}
- (GMSMapView *)mapView
{
    if (!_mapView) {
        //设置地图view，这里是随便初始化了一个经纬度，在获取到当前用户位置到时候会直接更新的
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38.02 longitude:114.52 zoom:15];
        _mapView = [GMSMapView mapWithFrame:CGRectMake(0, PAaptation_y(156), SCREEN_WIDTH,self.view.frame.size.height - PAaptation_y(110)-PAaptation_y(156)) camera:camera];
        _mapView.delegate = self;
        _mapView.settings.compassButton = YES;//显示指南针
        //_mapView.settings.myLocationButton = YES;
        //_mapView.myLocationEnabled = NO;
    }
    return _mapView;
}

- (HSmallCardView *)smallMenuView
{
    if (!_smallMenuView) {
        _smallMenuView = [[HSmallCardView alloc] initWithFrame:CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - PAaptation_y(224), PAdaptation_x(115), PAaptation_y(79))];
    }
    return _smallMenuView;
}
- (HStudentStateView *)stateView
{
    if (!_stateView) {
        _stateView = [[HStudentStateView alloc] init];
        _stateView.backgroundColor = [UIColor whiteColor];
    }
    return _stateView;
}
@end
