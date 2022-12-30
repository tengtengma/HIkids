//
//  HStudentStateInfoView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import "HStudentStateInfoView.h"
#import "HStudent.h"

@interface HStudentStateInfoView()
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIImageView *naolingView;
@property (nonatomic, strong) UIImageView *lujingView;
@property (nonatomic, strong) UIImageView *thirdlujingView;
@property (nonatomic, strong) UIImageView *batteryImageView;
@property (nonatomic, strong) UIImageView *wifiImageView;
@property (nonatomic, strong) UIButton *quitBtn;


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
        
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.equalTo(self).offset(PAdaptation_x(25));
            make.width.mas_equalTo(PAdaptation_x(52));
            make.height.mas_equalTo(PAaptation_y(52));
        }];
        
        [self addSubview:self.batteryImageView];
        [self.batteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.equalTo(self).offset(PAdaptation_x(25));
            make.width.mas_equalTo(PAdaptation_x(26));
            make.height.mas_equalTo(PAaptation_y(19));
        }];
        
        [self addSubview:self.wifiImageView];
        [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom);
            make.left.equalTo(self.batteryImageView.mas_right).offset(PAdaptation_x(5));
            make.width.mas_equalTo(PAdaptation_x(20));
            make.height.mas_equalTo(PAaptation_y(19));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView);
            make.left.equalTo(self.headerView.mas_right).offset(PAdaptation_x(21));
        }];
        
        [self addSubview:self.locationLabel];
        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleLabel);
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(53));
        }];
        
        [self addSubview:self.naolingView];
        [self.naolingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(PAaptation_y(30));
            make.left.equalTo(self.headerView);
            make.width.mas_equalTo(PAdaptation_x(160));
            make.height.mas_equalTo(PAaptation_y(100));
        }];
        
        
        [self addSubview:self.lujingView];
        [self.lujingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naolingView);
            make.left.equalTo(self.naolingView.mas_right).offset(PAdaptation_x(20));
            make.width.mas_equalTo(PAdaptation_x(160));
            make.height.mas_equalTo(PAaptation_y(100));
        }];
        
        [self addSubview:self.thirdlujingView];
        [self.thirdlujingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lujingView.mas_bottom).offset(PAaptation_y(16));
            make.left.equalTo(self.naolingView);
            make.width.mas_equalTo(PAdaptation_x(340));
            make.height.mas_equalTo(PAaptation_y(88));
        }];
        
        [self addSubview:self.quitBtn];
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
    self.titleLabel.text = student.name;
    self.locationLabel.text = @"〒460-0008、愛知県名古屋市中区栄４丁目６−８ 名古屋東急ホテル";
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
    
    [self.batteryImageView setImage:[UIImage imageNamed:@"battery.png"]];
    [self.wifiImageView setImage:[UIImage imageNamed:@"wifi.png"]];
    
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

#pragma mark - LazyLoad -
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
