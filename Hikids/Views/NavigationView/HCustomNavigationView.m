//
//  HCustomNavigationView.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HCustomNavigationView.h"
#import "HLoginVC.h"

@interface HCustomNavigationView()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *stateImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HCustomNavigationView

- (instancetype)init
{
    if (self = [super init]) {
        
        
        [self createUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStyle:) name:@"dangerAlertNotification" object:nil];

    }
    return self;
}
- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(PAaptation_y(BW_StatusBarHeight+5));
        make.left.equalTo(self).offset(PAdaptation_x(12));
        make.width.mas_equalTo(PAdaptation_x(300));
    }];
    
    [self.backgroundImageView addSubview:self.stateImageView];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(8));
        make.left.equalTo(self.titleLabel);
        make.width.mas_equalTo(PAdaptation_x(30));
        make.height.mas_equalTo(PAaptation_y(30));
    }];
    
    [self.backgroundImageView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateImageView);
        make.left.equalTo(self.stateImageView.mas_right).offset(PAdaptation_x(6));
    }];
    
    [self.backgroundImageView addSubview:self.updateTimeLabel];
    [self.updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stateLabel.mas_bottom).offset([BWTools getIsIpad] ? LAdaptation_y(5) : PAaptation_y(2));
        make.left.equalTo(self.stateImageView);
    }];
    
    [self.backgroundImageView addSubview:self.userImageView];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(PAaptation_y(7));
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(56));
        make.height.mas_equalTo(PAaptation_y(56));
    }];
    
    [self.backgroundImageView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userImageView.mas_bottom).offset(PAaptation_y(4));
        make.centerX.equalTo(self.userImageView);
    }];
}
- (void)defautInfomation
{
    self.titleLabel.text = @"--";
    self.stateLabel.text = @"--";
    self.stateLabel.textColor = BWColor(0, 176, 107, 1);

    self.updateTimeLabel.text = @"--";
    self.updateTimeLabel.textColor = BWColor(0, 176, 107, 1);
    
    self.userNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_NickName];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"title_back.png"]];

}
- (void)updateStyle:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.object;
    NSString *name = [userInfo safeObjectForKey:@"name"];
    
    if ([[userInfo safeObjectForKey:@"status"] isEqualToString:@"安全"]) {
        [self safeStyleWithName:name];
    }else{
        [self dangerStyleWithName:name];
    }
    
}
- (void)safeStyleWithName:(NSString *)typeName
{
    self.titleLabel.text = typeName;
    self.stateLabel.text = @"安全";
    self.stateLabel.textColor = BWColor(0, 176, 107, 1);
    self.updateTimeLabel.textColor = BWColor(0, 176, 107, 1);
    [self.stateImageView setImage:[UIImage imageNamed:@"safe.png"]];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"navBG_safe.png"]];

}
- (void)dangerStyleWithName:(NSString *)typeName
{
    self.titleLabel.text = typeName;
    self.stateLabel.text = [typeName isEqualToString:@"午睡中"] ? @"要注意" : @"要注意";
    self.stateLabel.textColor = [typeName isEqualToString:@"午睡中"] ? BWColor(76, 53, 41, 1) :  BWColor(164, 0, 0, 1);
    self.updateTimeLabel.textColor = BWColor(164, 0, 0, 1);
    [self.stateImageView setImage:[typeName isEqualToString:@"午睡中"] ? [UIImage imageNamed:@"attention.png"] : [UIImage imageNamed:@"dangerNav.png"]];
    [self.backgroundImageView setImage:[UIImage imageNamed:@"navBG_danger.png"]];

}

- (void)loginOutAction:(UITapGestureRecognizer *)tap
{
    
    if (self.clickHeader) {
        self.clickHeader();
    }

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - LazyLoad -
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}
- (UIImageView *)stateImageView
{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
    }
    return _stateImageView;
}
- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont boldSystemFontOfSize:24.0];
        _stateLabel.textColor = [UIColor blackColor];
//    background: rgba(0, 176, 107, 1);

    }
    return _stateLabel;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:36.0];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}
- (UILabel *)updateTimeLabel
{
    if (!_updateTimeLabel) {
        _updateTimeLabel = [[UILabel alloc] init];
        _updateTimeLabel.font = [UIFont systemFontOfSize:10.0];
        _updateTimeLabel.textColor = [UIColor blackColor];
    }
    return _updateTimeLabel;
}
- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.userInteractionEnabled = YES;
        _userImageView.layer.borderWidth = 2;
        _userImageView.layer.cornerRadius = PAdaptation_x(56)/2;
        _userImageView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginOutAction:)];
        [_userImageView addGestureRecognizer:tap];
    }
    return _userImageView;
}
- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _userNameLabel.textColor = [UIColor blackColor];
    }
    return _userNameLabel;
}
@end
