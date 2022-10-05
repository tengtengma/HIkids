//
//  HStudentView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "HStudentView.h"

@interface HStudentView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HStudentView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.layer.cornerRadius = 8;

        self.layer.borderWidth = 1;

        self.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
        
        [self createUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)clickAction:(UITapGestureRecognizer *)tap
{
    if (self.clickStudentBlock) {
        self.clickStudentBlock(@"a");
    }
}
- (void)createUI
{
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(PAaptation_y(7));
        make.left.equalTo(self).offset(PAdaptation_x(10));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView);
        make.left.equalTo(self.imageView.mas_right).offset(PAdaptation_x(7));
        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(5));
    }];
    
}
- (void)setupWithModel:(id)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = @"山上　ハナコ";
}


#pragma mark - LazyLoad -
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = 0;
    }
    return _titleLabel;
}


@end
