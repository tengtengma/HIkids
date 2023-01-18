//
//  HMddView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import "HMddView.h"
#import "HDestnationModel.h"

@interface HMddView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation HMddView

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
        make.top.equalTo(self).offset(PAaptation_y(6));
        make.left.equalTo(self).offset(PAdaptation_x(6));
        make.width.mas_equalTo(PAdaptation_x(64));
        make.height.mas_equalTo(PAaptation_y(64));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView);
        make.left.equalTo(self.imageView.mas_right).offset(PAdaptation_x(6));
        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(5));
    }];
    
    [self addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-PAaptation_y(2));
        make.left.equalTo(self.imageView.mas_right).offset(PAdaptation_x(6));
        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(5));
    }];
}
- (void)setupWithModel:(id)model
{
    HDestnationModel *destModel = (HDestnationModel *)model;
    
    if (destModel.img) {
        [self.imageView setImage:destModel.img];
        self.distanceLabel.text = [NSString stringWithFormat:@"%@KM",destModel.distance];

    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:destModel.picture] placeholderImage:[UIImage imageNamed:@"default_mdd.png"]];
        self.distanceLabel.text = [NSString stringWithFormat:@"%@m",destModel.distance];
    }
    self.titleLabel.text = destModel.name;

}
- (void)cellNomal
{
    self.imageView.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
    self.titleLabel.textColor = [UIColor blackColor];
    self.distanceLabel.textColor = [UIColor blackColor];
    self.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)cellSelected
{
    self.imageView.layer.borderColor = BWColor(191, 76, 13, 1).CGColor;
    self.titleLabel.textColor = BWColor(191, 76, 13, 1);
    self.distanceLabel.textColor = [UIColor blackColor];
    self.layer.borderColor = BWColor(191, 76, 13, 1).CGColor;
    self.backgroundColor = BWColor(244, 207, 184, 1);
}
#pragma mark - LazyLoad -
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.borderWidth = 1;
        _imageView.layer.borderColor = BWColor(34, 34, 34, 1.0).CGColor;
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
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _distanceLabel;
}
@end
