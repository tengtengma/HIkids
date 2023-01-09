//
//  HDateCard.m
//  Hikids
//
//  Created by 马腾 on 2023/1/9.
//

#import "HDateCard.h"

@interface HDateCard()
@property (nonatomic, strong) UIButton *button;
@end

@implementation HDateCard

- (instancetype)init
{
    if (self = [super init]) {
                
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.button addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.button);
        }];
        
        [self.imageView addSubview:self.desLabel];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView).offset(PAaptation_y(8));
            make.centerX.equalTo(self.imageView);
        }];
        
        [self.imageView addSubview:self.dayLabel];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageView);
        }];
        
        [self.imageView addSubview:self.monthLabel];
        [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.bottom.equalTo(self.imageView.mas_bottom).offset(-PAaptation_y(8));
        }];
        
        
        
    }
    return self;
}
- (void)selectAction:(id)sender
{
    if (self.clickBlock) {
        self.clickBlock(self);
    };
}

#pragma mark - LazyLoad -
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImage:[UIImage imageNamed:@"date_Default.png"]];
    }
    return _imageView;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:10];
    }
    return _desLabel;
}
- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont boldSystemFontOfSize:24];
    }
    return _dayLabel;
}
- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.font = [UIFont systemFontOfSize:12];
    }
    return _monthLabel;
}
@end
