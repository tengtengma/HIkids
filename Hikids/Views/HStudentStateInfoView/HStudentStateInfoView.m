//
//  HStudentStateInfoView.m
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import "HStudentStateInfoView.h"
#import "HStudent.h"

@interface HStudentStateInfoView()
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *naolingView;
@property (nonatomic, strong) UIImageView *lujingView;
@property (nonatomic, strong) UIImageView *thirdlujingView;
@property (nonatomic, strong) UIButton *quitBtn;


@end

@implementation HStudentStateInfoView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.headerView];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(PAaptation_y(32));
            make.left.equalTo(self).offset(PAdaptation_x(25));
            make.width.mas_equalTo(PAdaptation_x(52));
            make.height.mas_equalTo(PAaptation_y(52));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView);
            make.left.equalTo(self.headerView.mas_right).offset(PAdaptation_x(21));
        }];
        
        [self addSubview:self.naolingView];
        [self.naolingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(PAaptation_y(48));
            make.left.equalTo(self.headerView);
            make.width.mas_equalTo(PAdaptation_x(160));
            make.height.mas_equalTo(PAaptation_y(100));
        }];
        
        
        [self addSubview:self.lujingView];
        [self.lujingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.naolingView);
            make.left.equalTo(self.naolingView.mas_right).offset(PAdaptation_x(20));
            make.width.mas_equalTo(PAdaptation_x(160));
            make.height.mas_equalTo(PAaptation_y(100));
        }];
        
        [self addSubview:self.thirdlujingView];
        [self.thirdlujingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lujingView.mas_bottom).offset(PAaptation_y(16));
            make.left.equalTo(self.naolingView);
            make.width.mas_equalTo(PAdaptation_x(340));
            make.height.mas_equalTo(PAaptation_y(88));
        }];
        
        [self addSubview:self.quitBtn];
        [self.quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
            make.width.mas_equalTo(PAdaptation_x(40));
            make.height.mas_equalTo(PAaptation_y(38));
        }];
        
    }
    return self;
}
- (void)setInfomationWithModel:(HStudent *)student
{
    self.titleLabel.text = student.name;
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
    
}
- (void)backAction:(id)sender
{
    if (self.closeBlock) {
        self.closeBlock();
    }
}
- (void)lujingAction
{
    
}

#pragma mark - LazyLoad -
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
    }
    return _headerView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
- (UIImageView *)naolingView
{
    if (!_naolingView) {
        _naolingView = [[UIImageView alloc] init];
        [_naolingView setImage:[UIImage imageNamed:@"naoling.png"]];
    }
    return _naolingView;
}
- (UIImageView *)lujingView
{
    if (!_lujingView) {
        _lujingView = [[UIImageView alloc] init];
        [_lujingView setImage:[UIImage imageNamed:@"guihualujing.png"]];
        _lujingView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lujingAction)];
        [_lujingView addGestureRecognizer:tap];
    }
    return _lujingView;
}
- (UIImageView *)thirdlujingView
{
    if (!_thirdlujingView) {
        _thirdlujingView = [[UIImageView alloc] init];
        [_thirdlujingView setImage:[UIImage imageNamed:@"thirdlujing.png"]];

    }
    return _thirdlujingView;
}
- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}

@end
