//
//  HStudentTopView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import "HStudentTopView.h"

@interface HStudentTopView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *numberBg;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *expandBtn;
@end

@implementation HStudentTopView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.bgView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.left.equalTo(self.bgView).offset(PAdaptation_x(16));
            make.width.mas_equalTo(PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        
        [self.bgView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.left.equalTo(self.iconView.mas_right).offset(PAdaptation_x(10));
        }];
        
        [self.bgView addSubview:self.numberBg];
        [self.numberBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView);
            make.left.equalTo(self.stateLabel.mas_right).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(59));
            make.height.mas_equalTo(PAaptation_y(26));
        }];
        
        [self.numberBg addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.numberBg);
        }];
        
//        [self.bgView addSubview:self.expandBtn];
//        [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.bgView);
//            make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(11.5));
//            make.width.mas_equalTo(PAdaptation_x(21));
//            make.height.mas_equalTo(PAaptation_y(24));
//        }];
        
    }
    return self;
}
- (void)setDangerStyleWithStudentCount:(NSInteger)count
{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",count];
    self.numberLabel.textColor = BWColor(255, 75, 0, 1);
    self.stateLabel.text = @"危険";
    [self.iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
    [self.bgView setImage:[UIImage imageNamed:@"dangerStatus.png"]];
}
- (void)setSafeStyleWithStudentCount:(NSInteger)count
{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",count];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberBg.backgroundColor = BWColor(5, 70, 11, 1);
    self.stateLabel.text = @"安全エリア内";
    [self.iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
    [self.bgView setImage:[UIImage imageNamed:@"safeStatus.png"]];

}
- (void)clickExpandAction:(UIButton *)button
{
    if (!button.selected) {
        [button setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];

    }else{
        [button setImage:[UIImage imageNamed:@"close_state.png"] forState:UIControlStateNormal];
    }
    
    if (self.expandBlock) {
        self.expandBlock();
    }
    
    button.selected = !button.selected;
    


}

#pragma mark - LazyLoad -
- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}
- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}
- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.text = @"危険";
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:20];
    }
    return _stateLabel;
}
- (UIView *)numberBg
{
    if (!_numberBg) {
        _numberBg = [[UIView alloc] init];
        _numberBg.backgroundColor = [UIColor whiteColor];
    }
    return _numberBg;
}
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
//        _numberLabel.text = [NSString stringWithFormat:@"%ld人",self.exceptArray.count];
        _numberLabel.font = [UIFont systemFontOfSize:16];
        _numberLabel.textColor = BWColor(255, 75, 0, 1);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}



@end
