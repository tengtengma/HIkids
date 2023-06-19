//
//  HStudentStateInfoView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import "HStudentStateInfoView.h"
#import "HStudent.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>

@interface HStudentStateInfoView()
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *naolingView;
@property (nonatomic, strong) UIImageView *lujingView;
@property (nonatomic, strong) UIImageView *thirdlujingView;
@property (nonatomic, strong) UIImageView *batteryImageView;
@property (nonatomic, strong) UIImageView *wifiImageView;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) HStudent *student;

@end

@implementation HStudentStateInfoView

- (instancetype)init
{
    if (self = [super init]) {
                
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(32));
        }];
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [self.bgView addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(PAdaptation_x(25));
            make.width.mas_equalTo(PAdaptation_x(52));
            make.height.mas_equalTo(PAaptation_y(52));
        }];
        
        [self.bgView addSubview:self.batteryImageView];
        [self.batteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.equalTo(self).offset(PAdaptation_x(25));
            make.width.mas_equalTo(PAdaptation_x(26));
            make.height.mas_equalTo(PAaptation_y(19));
        }];
        
        [self.bgView addSubview:self.wifiImageView];
        [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.equalTo(self.batteryImageView.mas_right).offset(PAdaptation_x(5));
            make.width.mas_equalTo(PAdaptation_x(20));
            make.height.mas_equalTo(PAaptation_y(19));
        }];
        
        [self.bgView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView);
            make.left.equalTo(self.headerView.mas_right).offset(PAdaptation_x(21));
        }];
        
        [self.bgView addSubview:self.locationLabel];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(53));
        }];
        
        [self.bgView addSubview:self.naolingView];
        [self.naolingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(PAaptation_y(30));
            make.left.equalTo(self.headerView);
            make.width.mas_equalTo(PAdaptation_x(160));
            make.height.mas_equalTo(PAaptation_y(100));
        }];
        
        
        [self.bgView addSubview:self.lujingView];
        [self.lujingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naolingView);
            make.left.equalTo(self.naolingView.mas_right).offset(PAdaptation_x(20));
            make.width.mas_equalTo(PAdaptation_x(160));
            make.height.mas_equalTo(PAaptation_y(100));
        }];
        
        [self.bgView addSubview:self.thirdlujingView];
        [self.thirdlujingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lujingView.mas_bottom).offset(PAaptation_y(16));
            make.left.equalTo(self.naolingView);
            make.width.mas_equalTo(PAdaptation_x(340));
            make.height.mas_equalTo(PAaptation_y(88));
        }];
        
        [self.bgView addSubview:self.quitBtn];
        [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
            make.width.mas_equalTo(PAdaptation_x(40));
            make.height.mas_equalTo(PAaptation_y(40));
        }];
        
    }
    return self;
}
- (void)setInfomationWithModel:(HStudent *)student
{
    self.student = student;
    
    self.titleLabel.text = student.name;
    self.locationLabel.text = @"获取中...";
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
    
    [self.batteryImageView setImage:[self batteryLevelImageWithString:student.deviceInfo.batteryLevel]];
    [self.wifiImageView setImage:[UIImage imageNamed:@"wifi.png"]];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(student.deviceInfo.latitude.doubleValue, student.deviceInfo.longitude.doubleValue);
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.871893697139896, 116.28354814224828);


    [self getPlace:coordinate];
    
}
- (UIImage *)batteryLevelImageWithString:(NSString *)rate
{
    UIImage *image = nil;
    
    if(rate.doubleValue >= 0 && rate.doubleValue <= 20.0){
        image = [UIImage imageNamed:@"battery_empty.png"];
        
    }else if(rate.doubleValue > 20.0 && rate.doubleValue <= 40.0){
        image = [UIImage imageNamed:@"battery_low.png"];

    }else if(rate.doubleValue > 40.0 && rate.doubleValue <= 60.0){
        image = [UIImage imageNamed:@"battery_half.png"];

    }else if(rate.doubleValue > 60.0 && rate.doubleValue <= 80.0){
        image = [UIImage imageNamed:@"battery_high.png"];

    }else{
        image = [UIImage imageNamed:@"battery_full.png"];

    }
    return image;
}
- (void)backAction:(id)sender
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)lujingAction
{
    
}
- (void)getPlace:(CLLocationCoordinate2D)coordinate2D{

    DefineWeakSelf;
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
            
            weakSelf.locationLabel.text = [NSString stringWithFormat:@"%@、%@ %@%@",addressObj.postalCode,addressObj.administrativeArea,addressObj.subLocality,addressObj.thoroughfare];

        }else{
            NSLog(@"地理反编码错误");
            weakSelf.locationLabel.text = @"获取位置失败";

        }
    }];
}
- (void)openAppleMap
{
    NSURL * apple_App = [NSURL URLWithString:@"http://maps.apple.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:apple_App]) {
        //将BD-09坐标系转换为GCJ-02坐标系
//        CLLocationCoordinate2D location = [JZLocationConverter bd09ToGcj02:CLLocationCoordinate2DMake([Latitude doubleValue], [Longitude doubleValue])];
        
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.871893697139896, 116.28354814224828);
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.student.deviceInfo.latitude.doubleValue, self.student.deviceInfo.longitude.doubleValue);

        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *tolocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
        tolocation.name = self.locationLabel.text;
        [MKMapItem openMapsWithItems:@[currentLocation,tolocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
    }
}
#pragma mark - LazyLoad -
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
    }
    return _headerView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _titleLabel;
}
- (UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont systemFontOfSize:12];
        _locationLabel.numberOfLines = 2;
        _locationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _locationLabel.textColor = BWColor(118, 144, 156, 1);
    }
    return _locationLabel;
}
- (UIImageView *)naolingView
{
    if (!_naolingView) {
        _naolingView = [[UIImageView alloc] init];
        [_naolingView setImage:[UIImage imageNamed:@"naoling.png"]];
    }
    return _naolingView;
}
- (UIImageView *)lujingView
{
    if (!_lujingView) {
        _lujingView = [[UIImageView alloc] init];
        [_lujingView setImage:[UIImage imageNamed:@"guihualujing.png"]];
        _lujingView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lujingAction)];
        [_lujingView addGestureRecognizer:tap];
    }
    return _lujingView;
}
- (UIImageView *)thirdlujingView
{
    if (!_thirdlujingView) {
        _thirdlujingView = [[UIImageView alloc] init];
        [_thirdlujingView setImage:[UIImage imageNamed:@"thirdlujing.png"]];
        _thirdlujingView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAppleMap)];
        [_thirdlujingView addGestureRecognizer:tap];

    }
    return _thirdlujingView;
}
- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}
- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        [_topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    }
    return _topView;
    
}
- (UIImageView *)batteryImageView
{
    if (!_batteryImageView) {
        _batteryImageView = [[UIImageView alloc] init];
        _batteryImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _batteryImageView;
}
- (UIImageView *)wifiImageView
{
    if (!_wifiImageView) {
        _wifiImageView = [[UIImageView alloc] init];
        _wifiImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _wifiImageView;
}
@end
