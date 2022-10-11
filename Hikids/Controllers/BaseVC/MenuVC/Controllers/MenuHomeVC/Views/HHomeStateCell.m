//
//  HHomeStateCell.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HHomeStateCell.h"
#import "HStudent.h"



@interface HHomeStateCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIView *numberBg;
@property (nonatomic, strong) UIButton *expandBtn;
@property (nonatomic, strong) UILabel *numberLabel;


@end

@implementation HHomeStateCell

- (void)setupCellwithStyle:(CellType)cellType
{
    [self createTopView];
    
    if (cellType == CellType_Danger) {
        
        [self loadDangerStyle];

    }else if (cellType == CellType_Safe){
        
        [self loadSafeStyle];

    }else if (cellType == CellType_Lost){
       
        [self loadLostStyle];
        
    }else{
        
        [self loadChargeStyle];
    }

}
- (void)createTopView
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
}
- (void)loadDangerStyle
{
    self.stateLabel.text = @"危険";
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.exceptArray.count];
    
    self.topView.backgroundColor = BWColor(255, 75, 0, 1);
    self.numberLabel.textColor = BWColor(255, 75, 0, 1);
    self.numberBg.backgroundColor = [UIColor whiteColor];
    
    [self createStudentViewWithArray:self.exceptArray];
    
}
- (void)loadSafeStyle
{
    self.stateLabel.text = @"安全";
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.nomalArray.count];

    self.numberBg.backgroundColor = BWColor(5, 70, 11, 1);
    self.topView.backgroundColor = BWColor(0, 176, 107, 1);
    
    [self createStudentViewWithArray:self.nomalArray];


}
- (void)loadLostStyle
{
    self.stateLabel.text = @"信号なし";
    self.numberLabel.text = @"3人";
    self.numberBg.backgroundColor = BWColor(85, 85, 85, 1);
    self.topView.backgroundColor = BWColor(246, 209, 71, 1);

}
- (void)loadChargeStyle
{
    self.stateLabel.text = @"充電中";
    self.numberLabel.text = @"3人";
    self.numberBg.backgroundColor = BWColor(176, 143, 17, 1);
    self.topView.backgroundColor = BWColor(196, 196, 196, 1);

}

- (void)createStudentViewWithArray:(NSArray *)array
{
    UIImageView *tempView = nil;
    for (NSInteger i = 0; i < array.count; i++) {
        
        HStudent *student = [array safeObjectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        imageView.layer.cornerRadius = PAdaptation_x(36)/2;
        imageView.layer.masksToBounds = YES;
        [self.bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom).offset(PAaptation_y(12));
            if (tempView) {
                make.left.equalTo(tempView.mas_right).offset(PAdaptation_x(6));
            }else{
                make.left.equalTo(self.bgView).offset(PAdaptation_x(6));
            }
            make.width.mas_equalTo(PAdaptation_x(36));
            make.height.mas_equalTo(PAaptation_y(36));
        }];
        
        tempView = imageView;
    }
}
- (void)setupCellWithExpandWithModel:(id)model withIndex:(NSInteger)index
{
    if (index == 0) {
        [self createTopView];
    }
    HStudent *student = (HStudent *)model;
    
    UIImageView *header = [[UIImageView alloc] init];
    [header sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
    [self.contentView addSubview:header];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(PAdaptation_x(58));
        make.height.mas_equalTo(PAaptation_y(58));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = student.name;
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header);
        make.left.equalTo(header.mas_right).offset(PAdaptation_x(12));
    }];
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


@end
