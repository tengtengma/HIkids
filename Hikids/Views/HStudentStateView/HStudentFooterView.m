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

@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIImageView *lastCellBottomView;
@property (nonatomic, strong) HStudent *student;


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
            make.width.mas_equalTo(PAdaptation_x(30));
            make.height.mas_equalTo(PAaptation_y(30));
        }];
        
        [self addSubview:self.distanceLabel];
        [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.gpsImageView);
            make.left.equalTo(self.gpsImageView.mas_right).offset(PAdaptation_x(6));
        }];
        
//        [self addSubview:self.clockBtn];
//        [self.clockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.headerView);
//            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(31));
//            make.width.mas_equalTo(PAdaptation_x(18));
//            make.height.mas_equalTo(PAaptation_y(20));
//        }];
//
//        [self addSubview:self.backupBtn];
//        [self.backupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.headerView);
//            make.right.equalTo(self.clockBtn.mas_left).offset(-PAdaptation_x(27));
//            make.width.mas_equalTo(PAdaptation_x(15));
//            make.height.mas_equalTo(PAaptation_y(20));
//        }];
        
        
        
    }
    return self;
}
- (void)setNomalBorder
{
    [self addSubview:self.leftLineView];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.mas_equalTo(2);
        make.height.equalTo(self);
    }];
    
    [self addSubview:self.rightLineView];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.width.mas_equalTo(2);
        make.height.equalTo(self);
    }];
    
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-2);
        make.left.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(2);
    }];
}
- (void)setLastCellBorder
{
    [self addSubview:self.lastCellBottomView];
    [self sendSubviewToBack:self.lastCellBottomView];
    [self.lastCellBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)setupWithModel:(HStudent *)model;
{
    self.student = model;
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    [self.batteryImageView setImage:[UIImage imageNamed:@"battery.png"]];
    [self.wifiImageView setImage:[UIImage imageNamed:@"wifi.png"]];
    self.titleLabel.text = model.name;
}
- (void)loadSafeStyle
{
    if (self.student.deviceInfo.averangheart.length != 0) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%@bpm",self.student.deviceInfo.averangheart];
    }else{
        self.distanceLabel.text = [NSString stringWithFormat:@"--bpm"];
    }
    [self.gpsImageView setImage:[UIImage imageNamed:@"xintiao_safe.png"]];
    self.distanceLabel.textColor = BWColor(0, 176, 107, 1);
    self.headerView.layer.borderColor = BWColor(0, 176, 107, 1).CGColor;
    self.leftLineView.backgroundColor = BWColor(45, 100, 29, 1);
    self.rightLineView.backgroundColor = BWColor(45, 100, 29, 1);
    self.bottomLineView.backgroundColor = BWColor(45, 100, 29, 1);
    [self.lastCellBottomView setImage:[UIImage imageNamed:@"listBottom_safe.png"]];
}
- (void)loadDangerStyle
{
    if (self.type == FootTYPE_WALK) {
        self.distanceLabel.text = [NSString stringWithFormat:@"%ld米",self.student.distance.integerValue];
        [self.gpsImageView setImage:[UIImage imageNamed:@"gps.png"]];
        self.headerView.layer.borderColor = BWColor(255, 75, 0, 1).CGColor;

    }else{
        if (self.student.deviceInfo.averangheart.length != 0) {
            self.distanceLabel.text = [NSString stringWithFormat:@"%@bpm",self.student.deviceInfo.averangheart];
        }else{
            self.distanceLabel.text = [NSString stringWithFormat:@"--bpm"];
        }
        [self.gpsImageView setImage:[UIImage imageNamed:@"xintiao_danger.png"]];
        self.headerView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;

    }
    self.distanceLabel.textColor = BWColor(255, 75, 0, 1);
    self.leftLineView.backgroundColor = BWColor(76, 40, 11, 1);
    self.rightLineView.backgroundColor = BWColor(76, 40, 11, 1);
    self.bottomLineView.backgroundColor = BWColor(76, 40, 11, 1);
    [self.lastCellBottomView setImage:[UIImage imageNamed:@"listBottom_danger.png"]];
}
- (void)clickBackupAction
{
    NSLog(@"backup");
}

#pragma mark - LazyLoad -
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
- (UIView *)leftLineView
{
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
    }
    return _leftLineView;
}
- (UIView *)rightLineView
{
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
    }
    return _rightLineView;
}
- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
    }
    return _bottomLineView;
}
- (UIImageView *)lastCellBottomView
{
    if (!_lastCellBottomView) {
        _lastCellBottomView = [[UIImageView alloc] init];
        _lastCellBottomView.userInteractionEnabled = YES;
    }
    return _lastCellBottomView;
}
@end
