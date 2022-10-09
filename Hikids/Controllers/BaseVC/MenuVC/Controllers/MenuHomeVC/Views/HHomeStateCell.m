//
//  HHomeStateCell.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HHomeStateCell.h"



@interface HHomeStateCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *numberBg;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *expandBtn;

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation HHomeStateCell

- (void)setupCellWithModel:(id)model withStyle:(CellType)cellType
{
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(PAaptation_y(16));
        make.left.equalTo(self.contentView).offset(PAdaptation_x(24));
        make.right.equalTo(self.contentView.mas_right).offset(-PAdaptation_x(24));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-PAaptation_y(16));
    }];
    [self.bgView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    [self.topView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(PAdaptation_x(16));
        make.width.mas_equalTo(PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(24));
    }];
    
    [self.topView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.left.equalTo(self.iconView.mas_right).offset(PAdaptation_x(10));
    }];
    
    [self.topView addSubview:self.numberBg];
    [self.numberBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconView);
        make.left.equalTo(self.stateLabel.mas_right).offset(PAdaptation_x(10));
        make.width.mas_equalTo(PAdaptation_x(59));
        make.height.mas_equalTo(PAaptation_y(26));
    }];
    
    [self.topView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.numberBg);
    }];
    
    [self.topView addSubview:self.expandBtn];
    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.topView.mas_right).offset(-PAdaptation_x(11.5));
        make.width.mas_equalTo(PAdaptation_x(21));
        make.height.mas_equalTo(PAaptation_y(24));
    }];
    
    if (cellType == CellType_Danger) {
        
        [self loadDangerStyleWithModel:model];

    }else if (cellType == CellType_Safe){
        
        [self loadSafeStyleWithModel:model];

    }else if (cellType == CellType_Lost){
       
        [self loadLostStyleWithModel:model];
        
    }else{
        
        [self loadChargeStyleWithModel:model];
    }
   
}
- (void)loadDangerStyleWithModel:(id)model
{
    self.stateLabel.text = @"危険";
    self.numberLabel.text = @"3人";
    self.nameLabel.text = @"山上ハナコ";
    
    self.topView.backgroundColor = BWColor(255, 75, 0, 1);
    self.numberLabel.textColor = BWColor(255, 75, 0, 1);
    self.numberBg.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)loadSafeStyleWithModel:(id)model
{
    self.stateLabel.text = @"安全";
    self.numberLabel.text = @"3人";
    self.nameLabel.text = @"山上ハナコ";

    self.numberBg.backgroundColor = BWColor(5, 70, 11, 1);
    self.topView.backgroundColor = BWColor(0, 176, 107, 1);

}
- (void)loadLostStyleWithModel:(id)model
{
    self.stateLabel.text = @"信号なし";
    self.numberLabel.text = @"3人";
    self.nameLabel.text = @"山上ハナコ";

    self.numberBg.backgroundColor = BWColor(85, 85, 85, 1);
    self.topView.backgroundColor = BWColor(246, 209, 71, 1);

}
- (void)loadChargeStyleWithModel:(id)model
{
    self.stateLabel.text = @"充電中";
    self.numberLabel.text = @"3人";
    self.nameLabel.text = @"山上ハナコ";

    self.numberBg.backgroundColor = BWColor(176, 143, 17, 1);
    self.topView.backgroundColor = BWColor(196, 196, 196, 1);

}
- (void)clickExpandAction:(UIButton *)button
{
    if (self.expandBlock) {
        self.expandBlock();
    }
}

#pragma mark - LazyLoad -
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 12;
        _bgView.layer.borderWidth = 2;
        _bgView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    }
    return _bgView;
}
- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.backgroundColor = [UIColor greenColor];
    }
    return _iconView;
}
- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:20];
    }
    return _stateLabel;
}
- (UIView *)numberBg
{
    if (!_numberBg) {
        _numberBg = [[UIView alloc] init];
    }
    return _numberBg;
}
- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:16];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}
- (UIButton *)expandBtn
{
    if (!_expandBtn) {
        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        [_expandBtn setImage:[UIImage imageNamed:@"triangle_small.png"] forState:UIControlStateNormal];
    }
    return _expandBtn;
}
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.backgroundColor = [UIColor greenColor];
    }
    return _headerView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}
@end
