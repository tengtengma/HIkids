//
//  HConfirmAlertVC.m
//  Hikids
//
//  Created by 马腾 on 2024/4/17.
//

#import "HConfirmAlertVC.h"
#import "HStudent.h"

@interface HConfirmAlertVC ()
@property (nonatomic, strong) HStudent *student;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *studentNameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *cautionBtn;
@property (nonatomic, strong) UIButton *safeAreaBtn;

@end

@implementation HConfirmAlertVC

- (instancetype)initWithStudent:(HStudent *)student
{
    if (self = [super init]) {
        
        self.student = student;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(330));
        make.height.mas_equalTo(PAaptation_y(333));
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(PAaptation_y(25));
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
    }];
    
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.student.avatar] placeholderImage:[UIImage imageNamed:@""]];
    [self.bgView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(20));
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(PAdaptation_x(72));
        make.height.mas_equalTo(PAaptation_y(72));
    }];
    
    self.studentNameLabel.text = self.student.name;
    [self.bgView addSubview:self.studentNameLabel];
    [self.studentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentNameLabel.mas_bottom).offset(PAaptation_y(15));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(50));
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(50));
        
    }];
    
    [self.bgView addSubview:self.cautionBtn];
    [self.cautionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-PAaptation_y(25));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(146));
        make.height.mas_equalTo(PAaptation_y(47));
    }];
    
    [self.bgView addSubview:self.safeAreaBtn];
    [self.safeAreaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cautionBtn);
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(146));
        make.height.mas_equalTo(PAaptation_y(47));
    }];
}
- (void)cautionAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)safeAction:(id)sender
{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}
#pragma mark - Lazy Load -
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 16;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"安全確認";
        _titleLabel.font = [UIFont boldSystemFontOfSize:24.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
    }
    return _headerView;
}
- (UILabel *)studentNameLabel
{
    if (!_studentNameLabel) {
        _studentNameLabel = [[UILabel alloc] init];
        _studentNameLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _studentNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _studentNameLabel;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"園児が安全エリアにいるかどうかを確認してください。";
        _desLabel.numberOfLines = 2;
        _desLabel.lineBreakMode = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _desLabel.textColor = BWColor(102.0, 102.0, 102.0, 1.0);
    }
    return _desLabel;
}
- (UIButton *)cautionBtn
{
    if (!_cautionBtn) {
        _cautionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cautionBtn setImage:[UIImage imageNamed:@"caution_btn.png"] forState:UIControlStateNormal];
        [_cautionBtn addTarget:self action:@selector(cautionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cautionBtn;
}
- (UIButton *)safeAreaBtn
{
    if (!_safeAreaBtn) {
        _safeAreaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_safeAreaBtn setImage:[UIImage imageNamed:@"safe_btn.png"] forState:UIControlStateNormal];
        [_safeAreaBtn addTarget:self action:@selector(safeAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _safeAreaBtn;
}
@end
