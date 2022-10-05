//
//  HSmallCardView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/3.
//

#import "HSmallCardView.h"

@interface HSmallCardView ()
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIImageView *safeView;
@property (nonatomic, strong) UIImageView *dangerView;


@end

@implementation HSmallCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.backgroundColor = BWColor(255, 253, 252, 1).CGColor;
        self.layer.cornerRadius = 8;
        self.layer.borderWidth = 2;
        self.layer.borderColor = BWColor(76, 53, 41, 1).CGColor;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSmallViewAction:)];
        [self addGestureRecognizer:tap];
        
        [self.desLabel setFrame:CGRectMake(PAdaptation_x(10), PAaptation_y(10), frame.size.width - PAdaptation_x(20), PAaptation_y(17))];
        [self addSubview:self.desLabel];
        
        [self.safeView setFrame:CGRectMake(PAdaptation_x(10), CGRectGetMaxY(self.desLabel.frame)+PAaptation_y(10), PAdaptation_x(6), PAaptation_y(6))];
        [self addSubview:self.safeView];
        
        [self.safeLabel setFrame:CGRectMake(CGRectGetMaxX(self.safeView.frame)+PAdaptation_x(10), CGRectGetMaxY(self.desLabel.frame)+PAaptation_y(5), frame.size.width - PAdaptation_x(36), PAaptation_y(17))];
        [self addSubview:self.safeLabel];
        
        [self.dangerView setFrame:CGRectMake(PAdaptation_x(10), CGRectGetMaxY(self.safeView.frame)+PAaptation_y(14), PAdaptation_x(6), PAaptation_y(6))];
        [self addSubview:self.dangerView];
        
        [self.dangerLabel setFrame:CGRectMake(CGRectGetMaxX(self.safeView.frame)+PAdaptation_x(10), CGRectGetMaxY(self.safeLabel.frame)+PAaptation_y(5), frame.size.width - PAdaptation_x(36), PAaptation_y(17))];
        [self addSubview:self.dangerLabel];
        
        
        
    }
    return self;
}
- (void)clickSmallViewAction:(UITapGestureRecognizer *)tap
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:12.0];
        _desLabel.text = @"今日レポート";
        _desLabel.textColor = BWColor(76, 53, 41, 0.4);
    }
    return _desLabel;
}
- (UIImageView *)safeView
{
    if (!_safeView) {
        _safeView = [[UIImageView alloc] init];
        [_safeView setImage:[UIImage imageNamed:@"safeView.png"]];
    }
    return _safeView;
}
- (UIImageView *)dangerView
{
    if (!_dangerView) {
        _dangerView = [[UIImageView alloc] init];
        [_dangerView setImage:[UIImage imageNamed:@"dangerView.png"]];
    }
    return _dangerView;
}
- (UILabel *)safeLabel
{
    if (!_safeLabel) {
        _safeLabel = [[UILabel alloc] init];
        _safeLabel.font = [UIFont systemFontOfSize:12];
        _safeLabel.textColor = BWColor(102, 102, 102, 1);
    }
    return _safeLabel;
}
- (UILabel *)dangerLabel
{
    if (!_dangerLabel) {
        _dangerLabel = [[UILabel alloc] init];
        _dangerLabel.font = [UIFont systemFontOfSize:12];
        _dangerLabel.textColor = BWColor(102, 102, 102, 1);
    }
    return _dangerLabel;
}

@end
