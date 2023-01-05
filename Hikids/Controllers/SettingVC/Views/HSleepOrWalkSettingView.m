//
//  HSleepOrWalkSettingView.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HSleepOrWalkSettingView.h"

@interface HSleepOrWalkSettingView()
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation HSleepOrWalkSettingView

- (id)initWithType:(Type)type
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(32));
        }];
        
        [self createTitleView];
        
        if (type == type_Sleep) {
            
            [self createSleepUI];
        }
        if (type == type_Walk) {
            [self createWalkUI];

        }
        
        [self addSubview:self.saveBtn];
        [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-PAaptation_y(35));
            make.centerX.equalTo(self);
            make.width.mas_equalTo(PAdaptation_x(240));
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        
    }
    return self;
}
- (void)createTitleView
{
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(PAaptation_y(68));
    }];
    
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(_titleView).offset(PAdaptation_x(24));
    }];
    
    [self.titleView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView);
        make.right.equalTo(self.titleView.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(38));
    }];
    
    [self.titleView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.titleLabel);
    }];
    
}

- (void)createSleepUI
{
    self.titleLabel.text = @"午睡設定";
    self.desLabel.text = @"記録間隔";
    
    [self setupContentWithName:@"15分"];

}
- (void)createWalkUI
{
    self.titleLabel.text = @"散歩設定";
    self.desLabel.text = @"アラート精度";
    [self setupContentWithName:@"普通"];

}
- (void)setupContentWithName:(NSString *)name
{
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(PAaptation_y(10));
        make.left.equalTo(self).offset(PAdaptation_x(24));
        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(48));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = name;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = BWColor(34, 34, 34, 1);
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(PAdaptation_x(18));
    }];
    
    UIImageView *rightView = [[UIImageView alloc] init];
    [rightView setImage:[UIImage imageNamed:@"sw_down.png"]];
    [bgView addSubview:rightView];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView.mas_right).offset(-PAdaptation_x(12));
        make.width.mas_equalTo(PAdaptation_x(21));
        make.height.mas_equalTo(PAaptation_y(21));
    }];
}
- (void)backAction:(id)sender
{
    if (self.closeSwBlock) {
        self.closeSwBlock();
    }
}
- (void)saveAction:(id)sender
{
    
}
#pragma mark - LazyLoad -
- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        [_topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    }
    return _topView;
    
}
- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];

    }
    return _titleView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:32];
    }
    return _titleLabel;
}
- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"backBtn.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:14.0];
        _desLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _desLabel;
}
@end
