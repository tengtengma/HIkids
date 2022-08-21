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

@interface HMapVC ()<GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) GMSMapView *mapView ;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic,assign) BOOL firstLocationUpdate ;
@property (nonatomic,strong) GMSMarker *marker;//大头针
@property (nonatomic,strong) GMSPlacesClient * placesClient;//可以获取某个地方的信息
@end

@implementation HMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [btn addTarget:self action:@selector(navRightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    //设置地图view，这里是随便初始化了一个经纬度，在获取到当前用户位置到时候会直接更新的
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:38.02 longitude:114.52 zoom:15];
    _mapView= [GMSMapView mapWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - BW_TopHeight) camera:camera];
    _mapView.delegate = self;
    _mapView.settings.compassButton = YES;//显示指南针
    //_mapView.settings.myLocationButton = YES;
    //_mapView.myLocationEnabled = NO;
    [self.view addSubview:_mapView];

    /* 开始定位*/
    [self startLocation];

}
-(void)navRightClick{
    GMSAutocompleteViewController *autocompleteViewController = [[GMSAutocompleteViewController alloc] init];
    autocompleteViewController.delegate = self;
    [self presentViewController:autocompleteViewController animated:YES completion:nil];
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
//        [self locationPermissionAlert];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
//    [SVProgressHUD dismiss];
}
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray *)locations {
    if(!_firstLocationUpdate){
        _firstLocationUpdate = YES;//只定位一次的标记值
        // 获取最新定位
        CLLocation *location = locations.lastObject;
        // 停止定位
        [_locationManager stopUpdatingLocation];
        //如果是国内，就会转化坐标系，如果是国外坐标，则不会转换。
//        _coordinate2D = [JZLocationConverter wgs84ToGcj02:location.coordinate];
        //移动地图中心到当前位置
        _mapView.camera = [GMSCameraPosition cameraWithTarget:_coordinate2D zoom:15];

//        self.marker = [GMSMarker markerWithPosition:_coordinate2D];
//        self.marker.map = self.mapView;

        [self getPlace:_coordinate2D];
    }
}
-(void)mapViewDidFinishTileRendering:(GMSMapView *)mapView{

}
//地图移动后的代理方法，我这里的需求是地图移动需要刷新网络请求，查找附近的店铺
-(void)mapView:(GMSMapView*)mapView idleAtCameraPosition:(GMSCameraPosition*)position{
//    //点击一次先清除上一次的大头针
//    [self.marker.map clear];
//    self.marker.map = nil;
//    self.marker = [GMSMarker markerWithPosition:mapView.camera.target];
//    self.marker.map = self.mapView;
    [self getPlace:mapView.camera.target];
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
//-(void)addMarkers{
//    NSArray * latArr = @[@(_coordinate2D.latitude +0.004),@(_coordinate2D.latitude +0.008),@(_coordinate2D.latitude +0.007),@(_coordinate2D.latitude -0.0022),@(_coordinate2D.latitude -0.004)];
//    NSArray * lngArr = @[@(_coordinate2D.longitude+0.007),@(_coordinate2D.longitude+0.001),@(_coordinate2D.longitude+0.003),@(_coordinate2D.longitude+0.003),@(_coordinate2D.longitude-0.008)];
//    for(int i =0;i < latArr.count; i++){
//        GMSMarker *sydneyMarker = [[GMSMarker alloc]init];
//        sydneyMarker.title=@"Sydney!";
//        sydneyMarker.icon= [UIImage imageNamed:@"marker"];
//        sydneyMarker.position=CLLocationCoordinate2DMake([latArr[i]doubleValue], [lngArr[i]doubleValue]);
//        sydneyMarker.map=_mapView;
//    }
//}
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
    _mapView = nil;
}

@end
