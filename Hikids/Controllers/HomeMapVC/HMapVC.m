//
//  HMapVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HMapVC.h"
#import "HMenuHomeVC.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import "HSmallCardView.h"
#import "BWDestnationInfoReq.h"
#import "BWDestnationInfoResp.h"
#import "HDestnationModel.h"
#import "HLocation.h"
#import "BWStudentLocationReq.h"
#import "BWStudentLocationResp.h"
#import "HStudent.h"


@interface HMapVC ()<GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) HMenuHomeVC *menuHomeVC;
@property (nonatomic,strong) HSmallCardView *smallMenuView;
@property (nonatomic,strong) GMSMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic,strong) NSArray *exceptArray;
@property (nonatomic,strong) NSArray *nomalArray;

@property (nonatomic,assign) BOOL firstLocationUpdate ;
@property (nonatomic,strong) GMSMarker *marker;//大头针
@property (nonatomic,strong) GMSPlacesClient * placesClient;//可以获取某个地方的信息
@property (nonatomic,strong) HLocation *myLocation;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation HMapVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //开启定时器
     [self.timer setFireDate:[NSDate distantPast]];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //关闭定时器
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startRequest];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15*60 target:self selector:@selector(startGetStudentLocationRequest) userInfo:nil repeats:YES];

}
- (void)startRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DefineWeakSelf;
    BWDestnationInfoReq *infoReq = [[BWDestnationInfoReq alloc] init];
    infoReq.dId = @"1";
    [NetManger getRequest:infoReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
        BWDestnationInfoResp *infoResp = (BWDestnationInfoResp *)resp;
        [weakSelf changeLocationInfoDataWithModel:[infoResp.itemList safeObjectAtIndex:0]];
        
        [weakSelf startGetStudentLocationRequest];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
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
    
    self.myLocation = myLocation;
    
    [self createMapView];
    [self startDrawFence];
    
//    /* 开始定位*/
//    [self startLocation];
    
    
}
- (void)startGetStudentLocationRequest
{
    NSLog(@"12312312312312312");
    DefineWeakSelf;
    BWStudentLocationReq *locationReq = [[BWStudentLocationReq alloc] init];
    locationReq.latitude = self.myLocation.locationInfo.latitude;
    locationReq.longitude = self.myLocation.locationInfo.longitude;
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
- (void)createMapView
{
    [self.view addSubview:self.mapView];
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
- (void)startDrawFence
{
   
    //替换自己的坐标
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.myLocation.locationInfo.latitude, self.myLocation.locationInfo.longitude);
     
     //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
//        _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
     //移动地图中心到当前位置
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:18];
//    self.marker = [GMSMarker markerWithPosition:coordinate];
//    self.marker.map = self.mapView;
    
    [self drawPolygon];//画围栏
  
    
}
-(void)drawPolygon
{
    GMSMutablePath* path = [[GMSMutablePath alloc] init];
    
    for (NSInteger i = 0; i < self.myLocation.fenceArray.count; i++) {
        HLocationInfo *info = [self.myLocation.fenceArray safeObjectAtIndex:i];
        [path addCoordinate:CLLocationCoordinate2DMake(info.latitude, info.longitude)];
    }

    GMSPolygon* poly = [GMSPolygon polygonWithPath:path];
    poly.strokeWidth = 2.0;
    poly.strokeColor = BWColor(83, 192, 137, 1);
    poly.fillColor = BWColor(0, 176, 107, 0.2);
    poly.map = self.mapView;
}
-(void)addMarkers{
    
    //先清理掉旧的
    [self.marker.map clear];
    self.marker.map = nil;
    
    for (HStudent *student in self.exceptArray) {
                
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
}

//-(void)navRightClick{
//    GMSAutocompleteViewController *autocompleteViewController = [[GMSAutocompleteViewController alloc] init];
//    autocompleteViewController.delegate = self;
//    [self presentViewController:autocompleteViewController animated:YES completion:nil];
//}
- (void)createSmallView
{
    self.menuHomeVC.view.frame = CGRectMake(0, SCREEN_HEIGHT- PAaptation_y(110), SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.menuHomeVC.view];
    
    [self.view addSubview:self.smallMenuView];
    
    self.menuHomeVC.cardView = self.smallMenuView;
    self.menuHomeVC.nomalArray = self.nomalArray;
    self.menuHomeVC.exceptArray = self.exceptArray;
    
    self.smallMenuView.safeLabel.text = [NSString stringWithFormat:@"使用中%ld人",self.nomalArray.count + self.exceptArray.count];
    self.smallMenuView.dangerLabel.text = @"アラート0回";
    
    self.smallMenuView.clickBlock = ^{
        
    };
}

//- (void)startLocation {
//    if ([CLLocationManager locationServicesEnabled] &&
//        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
//        //定位功能可用
//        _locationManager = [[CLLocationManager alloc]init];
//        _locationManager.delegate = self;
//        [_locationManager requestWhenInUseAuthorization];
//        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
//        _locationManager.distanceFilter = 10;//设置定位频率，每隔多少米定位一次
//        [_locationManager startUpdatingLocation];
//    } else {
//        //定位不能用
//        [self locationPermissionAlert];
////        [SVProgressHUD dismiss];
//    }
//}

//#pragma mark - 系统自带location代理定位
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    if ([error code] == kCLErrorDenied) {
//        NSLog(@"访问被拒绝");
////        [self locationPermissionAlert];
//    }
//    if ([error code] == kCLErrorLocationUnknown) {
//        NSLog(@"无法获取位置信息");
//    }
////    [SVProgressHUD dismiss];
//}
//- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations {
//    if(!_firstLocationUpdate){
//        _firstLocationUpdate = YES;//只定位一次的标记值
//        // 获取最新定位 手机自己的定位
////        CLLocation *location = locations.lastObject;
//        // 停止定位
//        [_locationManager stopUpdatingLocation];
//
//
//       //替换自己的坐标
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.myLocation.locationInfo.latitude, self.myLocation.locationInfo.longitude);
//
//        //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
////        _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
//        //移动地图中心到当前位置
//        self.mapView.camera = [GMSCameraPosition cameraWithTarget:coordinate zoom:18];
//
//        self.marker = [GMSMarker markerWithPosition:coordinate];
//        self.marker.map = self.mapView;
//
//        [self drawPolygon];
//
////        [self getPlace:_coordinate2D];
//    }
//}
-(void)mapViewDidFinishTileRendering:(GMSMapView *)mapView{

    
}
//地图移动后的代理方法，我这里的需求是地图移动需要刷新网络请求，查找附近的店铺
-(void)mapView:(GMSMapView*)mapView idleAtCameraPosition:(GMSCameraPosition*)position{
//    //点击一次先清除上一次的大头针
//    [self.marker.map clear];
//    self.marker.map = nil;
//    self.marker = [GMSMarker markerWithPosition:mapView.camera.target];
//    self.marker.map = self.mapView;
//    [self getPlace:mapView.camera.target];
}
-(void)getPlace:(CLLocationCoordinate2D)coordinate2D{

    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(coordinate2D.latitude, coordinate2D.longitude) completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            GMSAddress* addressObj = response.firstResult;
            NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
            NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
            NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
            NSLog(@"locality=%@", addressObj.locality);
            NSLog(@"subLocality=%@", addressObj.subLocality);
            NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
            NSLog(@"postalCode=%@", addressObj.postalCode);
            NSLog(@"country=%@", addressObj.country);
            NSLog(@"lines=%@", addressObj.lines);
        }else{
            NSLog(@"地理反编码错误");
        }
    }];
}
//选择了位置后的回调方法
- (void)viewController:(GMSAutocompleteViewController*)viewController didAutocompleteWithPlace:(GMSPlace*)place {
    //移动地图中心到选择的位置
    _mapView.camera = [GMSCameraPosition cameraWithTarget:place.coordinate zoom:15];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
//失败回调
- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
//取消回调
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)mapView:(GMSMapView *) mapView didTapMarker:(GMSMarker *)marker
{
    HStudent *student = marker.userData;
    NSLog(@"点击了%@",student.name);
    return YES;
}
//// 获取当前位置权限提示图
//- (void)locationPermissionAlert {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"位置访问权限" message:@"请打开位置访问权限,以便于定位您的位置,添加地址信息" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//        if ([[UIApplication sharedApplication]canOpenURL:url]) {
//            [[UIApplication sharedApplication]openURL:url];
//        }
//    }];
//    [alert addAction:cancle];
//    [alert addAction:confirm];
//    [self presentViewController:alert animated:YES completion:nil];
//}

-(void)dealloc{
//    [SVProgressHUD dismiss];
//    [_locationManager stopUpdatingLocation];
    _mapView = nil;
}

#pragma mark - LazyLoad -
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
- (HMenuHomeVC *)menuHomeVC
{
    if (!_menuHomeVC) {
        _menuHomeVC = [[HMenuHomeVC alloc] init];
    }
    return _menuHomeVC;
}
- (HSmallCardView *)smallMenuView
{
    if (!_smallMenuView) {
        _smallMenuView = [[HSmallCardView alloc] initWithFrame:CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - PAaptation_y(200), PAdaptation_x(115), PAaptation_y(79))];
    }
    return _smallMenuView;
}

@end
