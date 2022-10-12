//
//  HCustomNavigationView.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HCustomNavigationView.h"

@interface HCustomNavigationView()


@end

@implementation HCustomNavigationView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    [self addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backgroundImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(PAaptation_y(BW_StatusBarHeight+7));
        make.left.equalTo(self).offset(PAdaptation_x(12));
        make.width.mas_equalTo(PAdaptation_x(300));
    }];
    
    [self.backgroundImageView addSubview:self.stateImageView];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(11));
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
        make.top.equalTo(self.stateLabel.mas_bottom).offset(PAaptation_y(4));
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



#pragma mark - LazyLoad -
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];        
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
