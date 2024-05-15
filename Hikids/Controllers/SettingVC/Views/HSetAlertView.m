//
//  HSetAlertCell.m
//  Hikids
//
//  Created by 马腾 on 2024/4/19.
//

#import "HSetAlertView.h"

@interface HSetAlertView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *soundImageView;

@end

@implementation HSetAlertView

- (instancetype)init
{
    if (self = [super init]) {
        
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.bgView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(PAaptation_y(5));
            make.centerX.equalTo(self.bgView);
            make.width.mas_equalTo(PAdaptation_x(84));
            make.height.mas_equalTo(PAaptation_y(64));
        }];
        
        [self.bgView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(PAaptation_y(10));
            make.left.equalTo(self.iconImageView);
            make.width.equalTo(self.iconImageView);
        }];
        
        [self.bgView addSubview:self.soundImageView];
        [self.soundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-PAaptation_y(10));
            make.centerX.equalTo(self.bgView);
            make.width.mas_equalTo(PAdaptation_x(20));
            make.height.mas_equalTo(PAaptation_y(16));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)clickItem:(UITapGestureRecognizer *)tap
{
    HSetAlertView *item = (HSetAlertView *)tap.view;
    NSLog(@"%@",item.soundId);
    if (self.selectBlock) {
        self.selectBlock(item.soundId,item.nameLabel.text);
    }
}
- (void)selectStyle
{
    self.bgView.backgroundColor = BWColor(237, 188, 155, 0.7);
    self.bgView.layer.borderColor = BWColor(191, 76, 13, 1).CGColor;
    [self.soundImageView setImage:[UIImage imageNamed:@"sound_active.png"]];
    self.nameLabel.textColor = BWColor(191, 76, 13, 1);
}
- (void)selectNomalStyle
{
    self.bgView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.soundImageView setImage:[UIImage imageNamed:@"sound.png"]];
    self.nameLabel.textColor = [UIColor blackColor];
}
#pragma mark - Lazy Load -
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 6;
        _bgView.layer.borderColor = [UIColor blackColor].CGColor;
        _bgView.layer.borderWidth = 2.0;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
//        [_iconImageView setImage:[UIImage imageNamed:@"soundIcon.png"]];
    }
    return _iconImageView;
}
- (UIImageView *)soundImageView
{
    if (!_soundImageView) {
        _soundImageView = [[UIImageView alloc] init];
        [_soundImageView setImage:[UIImage imageNamed:@"sound.png"]];
    }
    return _soundImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}
@end
