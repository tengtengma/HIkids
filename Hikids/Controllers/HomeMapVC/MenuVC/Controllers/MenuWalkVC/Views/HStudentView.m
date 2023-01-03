//
//  HStudentView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "HStudentView.h"
#import "HStudent.h"

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
        
    }
    return self;
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
    HStudent *student = (HStudent *)model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = student.name;
}
- (void)cellNomal
{
    self.imageView.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
    self.titleLabel.textColor = [UIColor blackColor];
    self.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)cellSelected
{
    self.imageView.layer.borderColor = BWColor(191, 76, 13, 1).CGColor;
    self.titleLabel.textColor = BWColor(191, 76, 13, 1);
    self.layer.borderColor = BWColor(191, 76, 13, 1).CGColor;
    self.backgroundColor = BWColor(244, 207, 184, 1);
}

#pragma mark - LazyLoad -
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.borderWidth = 2;
        _imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
        _imageView.layer.cornerRadius = PAaptation_y(40)/2;
        _imageView.layer.masksToBounds = YES;
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
