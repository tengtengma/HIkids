//
//  HSleepMainView.m
//  Hikids
//
//  Created by 马腾 on 2023/1/3.
//

#import "HSleepMainView.h"

@interface HSleepMainView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *contentView;

@end

@implementation HSleepMainView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.bgView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgView);
            make.width.mas_equalTo(PAdaptation_x(356));
            make.height.mas_equalTo(PAaptation_y(278));
        }];
    }
    return self;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
    }
    return _bgView;
}
- (UIImageView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        _contentView.backgroundColor = [UIColor redColor];
    }
    return _contentView;
}
@end
