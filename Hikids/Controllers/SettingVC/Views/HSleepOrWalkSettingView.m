//
//  HSleepOrWalkSettingView.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HSleepOrWalkSettingView.h"
#import "FFDropDownMenuView.h"

@interface HSleepOrWalkSettingView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UITableView *downTableView;
@property (nonatomic, assign) Type myType;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *saveContent;

@end

@implementation HSleepOrWalkSettingView

- (id)initWithType:(Type)type
{
    if (self = [super init]) {
        
        self.myType = type;

        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(PAaptation_y(32));
        }];
        
        [self createTitleView];
                
        [self createUI];

        
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

- (void)createUI
{
    if (self.myType == type_Sleep) {
        self.titleLabel.text = @"午睡設定";
        self.desLabel.text = @"記録間隔";
        self.dataArray = @[@"15分",@"30分",@"45分"];
        
        NSString *sleepTime = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_SleepTime];
        [self setupContentWithName:sleepTime.length != 0 ? sleepTime : @"15分"];
    }else{
        
        self.titleLabel.text = @"散歩設定";
        self.desLabel.text = @"アラート精度";
        self.dataArray = @[@"低",@"普通",@"高"];
        
        NSString *GPSAccuracy = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_GPSAccuracy];
        [self setupContentWithName:GPSAccuracy.length != 0 ? GPSAccuracy : @"普通"];
    }


}

- (void)setupContentWithName:(NSString *)name
{
    
    self.saveContent = name;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.tag = 3000;
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desLabel.mas_bottom).offset(PAaptation_y(10));
        make.left.equalTo(self).offset(PAdaptation_x(24));
        make.right.equalTo(self.mas_right).offset(-PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(48));
    }];
    
    [self addSubview:self.downTableView];
    [self.downTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom);
        make.left.equalTo(bgView);
        make.width.equalTo(bgView);
        make.height.mas_equalTo(PAaptation_y(0));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.tag = 4000;
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


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrCloseMenuAction)];
    [bgView addGestureRecognizer:tap];
    
}


- (void)backAction:(id)sender
{
    if (self.closeSwBlock) {
        self.closeSwBlock();
    }
}
- (void)showOrCloseMenuAction
{
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.24 animations:^{
        
        UIView *bgView = (UIView *)[weakSelf viewWithTag:3000];
        [self.downTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_bottom);
            make.left.equalTo(bgView);
            make.width.equalTo(bgView);
            make.height.mas_equalTo(self.show ? PAaptation_y(0) :PAaptation_y(44)*3);
        }];
            
    }];
    
    self.show = !self.show;
    
}
- (void)saveAction:(id)sender
{
    if (self.saveContent.length == 0) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.saveContent forKey:self.myType == type_Sleep ? KEY_SleepTime : KEY_GPSAccuracy];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self backAction:nil];

}
#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PAaptation_y(44);
}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - 每个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.font = [UIFont boldSystemFontOfSize:16.0];
    desLabel.text = [self.dataArray safeObjectAtIndex:indexPath.row];
    desLabel.textColor = BWColor(0, 28, 41, 1);
    [cell.contentView addSubview:desLabel];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(18));
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *label = (UILabel *)[self viewWithTag:4000];
    label.text = [self.dataArray safeObjectAtIndex:indexPath.row];
    self.saveContent = [self.dataArray safeObjectAtIndex:indexPath.row];
    [self showOrCloseMenuAction];
    
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
- (UITableView *)downTableView
{
    if (!_downTableView) {
        _downTableView = [[UITableView alloc] init];
        _downTableView.backgroundColor = [UIColor whiteColor];
        _downTableView.delegate = self;
        _downTableView.dataSource = self;
    }
    return _downTableView;
}
@end
