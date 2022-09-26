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
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(PAdaptation_x(12));
        make.width.mas_equalTo(PAdaptation_x(300));
    }];
    
    [self.backgroundImageView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(5));
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.backgroundImageView addSubview:self.markImageView];
    [self.markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(self.backgroundImageView.mas_right).offset(-PAdaptation_x(12));
        make.width.mas_equalTo(PAdaptation_x(80));
        make.height.mas_equalTo(PAaptation_y(44));
    }];
}



#pragma mark - LazyLoad -
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView setImage:[UIImage imageNamed:@"nav_background.png"]];
        
    }
    return _backgroundImageView;
}
- (UIImageView *)markImageView
{
    if (!_markImageView) {
        _markImageView = [[UIImageView alloc] init];
    }
    return _markImageView;
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
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:14.0];
        _desLabel.textColor = [UIColor blackColor];
    }
    return _desLabel;
}
@end
