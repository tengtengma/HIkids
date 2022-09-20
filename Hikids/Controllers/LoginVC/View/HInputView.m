//
//  HInputView.m
//  Hikids
//
//  Created by 马腾 on 2022/9/19.
//

#import "HInputView.h"

@interface HInputView()
@property (nonatomic, strong) UIImage *bgImg;
@property (nonatomic, strong) UIImage *iconImg;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation HInputView

- (instancetype)initWithBGImage:(UIImage *)bgImg IconImg:(UIImage *)iconImg
{
    if (self = [super init]) {
        
        self.bgImg = bgImg;
        self.iconImg = iconImg;
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.bgView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(PAdaptation_x(24));
        make.width.mas_equalTo(self.iconImg.size.width);
        make.height.mas_equalTo(self.iconImg.size.height);
    }];
    
    [self.bgView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.left.equalTo(self.iconImageView.mas_right).offset(PAdaptation_x(8));
    }];
}


#pragma mark - LazyLoad -
- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        [_bgView setImage:self.bgImg];
        _bgView.userInteractionEnabled = YES;
        _bgView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _bgView;
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setImage:self.iconImg];
        _bgView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _iconImageView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
//        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:14.0];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }
    return _textField;
}

@end
