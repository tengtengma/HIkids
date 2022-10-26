//
//  HStudentFooterView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import "HStudentFooterView.h"

@interface HStudentFooterView()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *batteryImageView;
@property (nonatomic, strong) UIImageView *wifiImageView;
@property (nonatomic, strong) UIImageView *gpsImageView;
@property (nonatomic, strong) UIButton *backupBtn;
@property (nonatomic, strong) UIButton *clockBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;


@end

@implementation HStudentFooterView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(58));
            make.height.mas_equalTo(PAaptation_y(58));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView);
            make.left.equalTo(self.headerView.mas_right).offset(PAdaptation_x(12));
        }];
        
        [self addSubview:self.batteryImageView];
        [self.batteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.mas_right).offset(PAdaptation_x(11));
            make.width.mas_equalTo(PAdaptation_x(30));
            make.height.mas_equalTo(PAaptation_y(30));
        }];
        
        [self addSubview:self.wifiImageView];
        [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.batteryImageView.mas_right).offset(PAdaptation_x(11));
            make.width.mas_equalTo(PAdaptation_x(30));
            make.height.mas_equalTo(PAaptation_y(30));
        }];
        
        [self addSubview:self.gpsImageView];
        [self.gpsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(2));
            make.left.equalTo(self.headerView.mas_right).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(27));
            make.height.mas_equalTo(PAaptation_y(29));
        }];
        
        [self addSubview:self.distanceLabel];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.gpsImageView);
            make.left.equalTo(self.gpsImageView.mas_right).offset(PAdaptation_x(6));
        }];
        
        [self addSubview:self.clockBtn];
        [self.clockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView);
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(31));
            make.width.mas_equalTo(PAdaptation_x(18));
            make.height.mas_equalTo(PAaptation_y(20));
        }];
        
        [self addSubview:self.backupBtn];
        [self.backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.headerView);
            make.right.equalTo(self.clockBtn.mas_left).offset(-PAdaptation_x(27));
            make.width.mas_equalTo(PAdaptation_x(15));
            make.height.mas_equalTo(PAaptation_y(20));
        }];
        
        
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-1);
            make.left.equalTo(self).offset(PAdaptation_x(10));
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(10));
            make.height.mas_equalTo(1);
        }];
        
    }
    return self;
}
- (void)setupWithModel:(HStudent *)model;
{
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.batteryImageView setImage:[UIImage imageNamed:@"battery.png"]];
    [self.wifiImageView setImage:[UIImage imageNamed:@"wifi.png"]];

    if (model.exceptionTime) {
        [self.gpsImageView setImage:[UIImage imageNamed:@"gps.png"]];
        self.distanceLabel.textColor = BWColor(255, 75, 0, 1);
        self.distanceLabel.text = [NSString stringWithFormat:@"%ld米",model.distance.integerValue];
        self.headerView.layer.borderColor = BWColor(255, 75, 0, 1).CGColor;

    }else{
        [self.gpsImageView setImage:[UIImage imageNamed:@"xintiao.png"]];
        self.distanceLabel.textColor = BWColor(0, 176, 107, 1);
        if (model.deviceInfo.averangheart.length != 0) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%@bpm",model.deviceInfo.averangheart];
        }else{
            self.distanceLabel.text = [NSString stringWithFormat:@"--bpm"];

        }
        self.headerView.layer.borderColor = BWColor(0, 176, 107, 1).CGColor;

    }
    self.titleLabel.text = model.name;
}
- (void)clickBackupAction
{
    NSLog(@"backup");
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.layer.borderWidth = 2;
        _headerView.layer.cornerRadius = PAdaptation_x(58)/2;
        _headerView.layer.masksToBounds = YES;
    }
    return _headerView;
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
- (UIImageView *)gpsImageView
{
    if (!_gpsImageView) {
        _gpsImageView = [[UIImageView alloc] init];
    }
    return _gpsImageView;
}
- (UIButton *)backupBtn
{
    if (!_backupBtn) {
        _backupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backupBtn setImage:[UIImage imageNamed:@"backup.png"] forState:UIControlStateNormal];
        [_backupBtn addTarget:self action:@selector(clickBackupAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backupBtn;
}
- (UIButton *)clockBtn
{
    if (!_clockBtn) {
        _clockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clockBtn setImage:[UIImage imageNamed:@"clock.png"] forState:UIControlStateNormal];

    }
    return _clockBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
    }
    return _distanceLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BWColor(76, 53, 41, 0.6);
    }
    return _lineView;
}
@end
