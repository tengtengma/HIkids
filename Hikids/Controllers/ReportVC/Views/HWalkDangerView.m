//
//  HWalkDangerView.m
//  Hikids
//
//  Created by 马腾 on 2023/6/13.
//

#import "HWalkDangerView.h"

@interface HWalkDangerView()
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIImageView *gpsView;
@property (nonatomic, strong) UIImageView *redView;
@property (nonatomic, strong) UIImageView *greenView;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *dangerLabel;
@property (nonatomic, strong) UILabel *safeLabel;


@end

@implementation HWalkDangerView

- (instancetype)init
{
    if(self = [super init]){
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(48));
        }];
        
        [self.topView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.topView).offset(PAdaptation_x(13));
            make.width.mas_equalTo(PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        
        [self.topView addSubview:self.dangerLabel];
        [self.dangerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.iconView.mas_right).offset(PAdaptation_x(9));
        }];
        
        [self.topView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self.topView.mas_right).offset(-PAdaptation_x(11));
        }];
        
    }
    return self;
}


#pragma mark - LazyLoad -
- (UIImageView *)topView
{
    if(!_topView){
        _topView = [[UIImageView alloc] init];
        [_topView setImage:[UIImage imageNamed:@"walk_danger_status.png"]];
    }
    return _topView;
}
- (UIImageView *)iconView
{
    if(!_iconView){
        _iconView = [[UIImageView alloc] init];
        [_iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
    }
    return _iconView;
}
- (UIImageView *)gpsView
{
    if(!_gpsView){
        _gpsView = [[UIImageView alloc] init];
        [_gpsView setImage:[UIImage imageNamed:@"walkReport_gps.png"]];
    }
    return _gpsView;
}
- (UIImageView *)redView
{
    if(!_redView){
        _redView = [[UIImageView alloc] init];
        [_redView setImage:[UIImage imageNamed:@"walkReport_red.png"]];
    }
    return _redView;
}
- (UIImageView *)greenView
{
    if(!_greenView){
        _greenView = [[UIImageView alloc] init];
        [_greenView setImage:[UIImage imageNamed:@"walkReport_green.png"]];
    }
    return _greenView;
}
- (UIImageView *)photoView
{
    if(!_photoView){
        _photoView = [[UIImageView alloc] init];
    }
    return _photoView;
}
- (UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.layer.backgroundColor = BWColor(255, 251, 227, 1).CGColor;
        _bottomView.layer.cornerRadius = 12;
        _bottomView.layer.borderWidth = 2;
        _bottomView.layer.borderColor = BWColor(76, 53, 41, 1).CGColor;
    }
    return _bottomView;
}
- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.text = @"危険";
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)timeLabel
{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:20];
        _timeLabel.textColor = [UIColor whiteColor];
    }
    return _timeLabel;
}
@end
