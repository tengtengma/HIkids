//
//  HSettingVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HSettingVC.h"
#import "HSleepOrWalkSettingView.h"
#import "HAccountVC.h"
#import "HInfomationVC.h"
#import "HSetAlertAccurateVC.h"
#import "HSetAudioVC.h"

@interface HSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.view.backgroundColor = [UIColor clearColor];
    [self createUI];
    
}
- (void)createUI
{

    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-PAaptation_y(120));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    

}
- (void)createTitleView
{
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(38));
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
    
}
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 分组 -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //暂时隐藏01/14/2024
//    return 3;
    
    return 3;
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //暂时隐藏01/14/2024
//    if (indexPath.section == 0) {
//        return PAaptation_y(58);
//    }
//    if (indexPath.section == 1) {
//        return PAaptation_y(58);
//    }
//    if (indexPath.section == 2) {
//        return PAaptation_y(98);
//    }
    if (indexPath.section == 0) {
        return PAaptation_y(58);
    }
    if (indexPath.section == 1) {
        return PAaptation_y(58);
    }
    if (indexPath.section == 2) {
        return PAaptation_y(98);
    }
    return 1;
}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //暂时隐藏01/14/2024
//    if (section == 0) {
//        return 1;
//    }
//    if (section == 1) {
//        return 2;
//    }
//    if (section == 2) {
//        return 1;
//    }
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 1;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , PAaptation_y(30))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(24), 0, headerView.frame.size.width - PAdaptation_x(48), headerView.frame.size.height)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = BWColor(0, 28, 41, 1);
    [headerView addSubview:label];
    
    //暂时隐藏01/14/2024
//    if (section == 0) {
//        label.text = @"クラス管理";
//    }else if (section == 1){
//        label.text = @"午睡・散歩";
//    }else{
//        label.text = @"アプリ・アカウント";
//    }
    
    if (section == 0) {
        label.text = @"クラス管理";
    }else if(section == 1){
        label.text = @"散歩設定";
    }else{
        label.text = @"アプリ・アカウント";
    }
    
    return headerView;
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
    
    //暂时隐藏01/14/2024
//    if (indexPath.section == 0) {
//        
//        [self setupCell:cell withNameList:@[@"クラス情報"] indexPath:indexPath];
//        
//        
//    }
//    if (indexPath.section == 1) {
//        
//        NSArray *array = @[@"午睡設定",@"散歩設定"];
//        [self setupCell:cell withNameList:array indexPath:indexPath];
//
//    }
//    if (indexPath.section == 2) {
//        
//        UIView *bgView = [[UIView alloc] init];
//        bgView.layer.cornerRadius = 8;
//        bgView.layer.borderWidth = 2;
//        bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
//        [cell.contentView addSubview:bgView];
//        
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(cell.contentView).offset(PAaptation_y(5));
//            make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
//            make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
//            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PAaptation_y(5));
//        }];
//        
//        UIImageView *headerView = [[UIImageView alloc] init];
//        headerView.layer.borderWidth = 2;
//        headerView.layer.cornerRadius = PAdaptation_x(58)/2;
//        headerView.layer.masksToBounds = YES;
//        [headerView sd_setImageWithURL:[NSURL URLWithString:@"https://yunpengmall.oss-cn-beijing.aliyuncs.com/1560875015170428928/material/19181666430944_.pic.jpg"] placeholderImage:[UIImage imageNamed:@"teacher.png"]];
//        [cell.contentView addSubview:headerView];
//        
//        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(bgView);
//            make.left.equalTo(bgView).offset(PAdaptation_x(18));
//            make.width.mas_equalTo(PAdaptation_x(58));
//            make.height.mas_equalTo(PAaptation_y(58));
//        }];
//        
//        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.font = [UIFont boldSystemFontOfSize:24.0];
//        nameLabel.text = @"ひまわり";
//        nameLabel.textColor = BWColor(34, 34, 34, 1.0);
//        [bgView addSubview:nameLabel];
//        
//        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(headerView);
//            make.left.equalTo(headerView.mas_right).offset(PAdaptation_x(16));
//        }];
//        
//        UILabel *desLabel = [[UILabel alloc] init];
//        desLabel.font = [UIFont systemFontOfSize:14.0];
//        desLabel.text = @"アプリ設定・情報確認・ログアウト";
//        desLabel.textColor = BWColor(34, 34, 34, 1.0);
//        [bgView addSubview:desLabel];
//        
//        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(headerView.mas_bottom);
//            make.left.equalTo(nameLabel);
//        }];
//       
//    }
    
    if (indexPath.section == 0) {
        
        [self setupCell:cell withNameList:@[@"クラス情報"] indexPath:indexPath];
        
        
    }
    if (indexPath.section == 1) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSNumber *warnLevel = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AlertLevel];
        NSString *ringNumber = [user objectForKey:KEY_RingNumber];
        
        NSString *showRingName = nil;
        if (ringNumber.integerValue == 0) {
            showRingName = @"アラート通知音設定：ワンちゃん";
        }else{
            showRingName = [NSString stringWithFormat:@"アラート通知音設定：アラ-ト%ld",ringNumber.integerValue];
        }
        
        NSString *showAlertName = nil;
        if (warnLevel.integerValue == 0) {
            showAlertName = @"アラート精度設定：普通";
        }else{
            
            if (warnLevel.integerValue == 1) {
                showAlertName = @"アラート精度設定：高感度";
                
            }else if (warnLevel.integerValue == 2){
                showAlertName = @"アラート精度設定：やや高感度";
                
            }else if (warnLevel.integerValue == 3){
                showAlertName = @"アラート精度設定：普通";

            }else if (warnLevel.integerValue == 4){
                showAlertName = @"アラート精度設定：やや低感度";
                
            }else{
                showAlertName = @"アラート精度設定：低感度";
            }
        }
        
        [self setupCell:cell withNameList:@[showAlertName,showRingName] indexPath:indexPath];

    }
    if (indexPath.section == 2) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.cornerRadius = 8;
        bgView.layer.borderWidth = 2;
        bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
        [cell.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(PAaptation_y(5));
            make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
            make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PAaptation_y(5));
        }];
        
        NSString *teacherUrl = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_Avatar];
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_NickName];
        
        UIImageView *headerView = [[UIImageView alloc] init];
        headerView.layer.borderWidth = 2;
        headerView.layer.cornerRadius = PAdaptation_x(58)/2;
        headerView.layer.masksToBounds = YES;
        [headerView sd_setImageWithURL:[NSURL URLWithString:teacherUrl] placeholderImage:[UIImage imageNamed:@"teacher.png"]];
        [cell.contentView addSubview:headerView];
        
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(PAdaptation_x(18));
            make.width.mas_equalTo(PAdaptation_x(58));
            make.height.mas_equalTo(PAaptation_y(58));
        }];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:24.0];
        nameLabel.text = nickName;
        nameLabel.textColor = BWColor(34, 34, 34, 1.0);
        [bgView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView);
            make.left.equalTo(headerView.mas_right).offset(PAdaptation_x(16));
        }];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.font = [UIFont systemFontOfSize:14.0];
        desLabel.text = @"アプリ設定・情報確認・ログアウト";
        desLabel.textColor = BWColor(34, 34, 34, 1.0);
        [bgView addSubview:desLabel];
        
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(headerView.mas_bottom);
            make.left.equalTo(nameLabel);
        }];
       
    }

    return cell;
}
- (void)setupCell:(UITableViewCell *)cell withNameList:(NSArray *)nameList indexPath:(NSIndexPath *)indexPath
{
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
    [cell.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(PAaptation_y(5));
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
        make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PAaptation_y(5));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [nameList safeObjectAtIndex:indexPath.row];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = BWColor(34, 34, 34, 1);
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(PAdaptation_x(18));
    }];
}
#pragma mark - UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //暂时隐藏01/14/2024
//    if (indexPath.section == 0) {
//        HInfomationVC *infomationVC = [[HInfomationVC alloc] init];
//        [self presentViewController:infomationVC animated:YES completion:nil];
//    }
//    if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            //午睡设置
//            [self showSleepOrWalkViewByTyep:type_Sleep];
//        }
//        if (indexPath.row == 1) {
//            //散步设置
//            [self showSleepOrWalkViewByTyep:type_Walk];
//
//        }
//    }
//    if (indexPath.section == 2) {
//        HAccountVC *accountVC = [[HAccountVC alloc] init];
//        [self presentViewController:accountVC animated:YES completion:nil];
//    }
    if (indexPath.section == 0) {
        HInfomationVC *infomationVC = [[HInfomationVC alloc] init];
        [self presentViewController:infomationVC animated:YES completion:nil];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"精度");
            HSetAlertAccurateVC *accurateVC = [[HSetAlertAccurateVC alloc] init];
            [self presentViewController:accurateVC animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            NSLog(@"声音");
            HSetAudioVC *audioVC = [[HSetAudioVC alloc] init];
            [self presentViewController:audioVC animated:YES completion:nil];
        }
    }
    if (indexPath.section == 2) {
        HAccountVC *accountVC = [[HAccountVC alloc] init];
        [self presentViewController:accountVC animated:YES completion:nil];
    }
}
- (void)showSleepOrWalkViewByTyep:(Type)type
{
    HSleepOrWalkSettingView *swView = [[HSleepOrWalkSettingView alloc] initWithType:type];
    [swView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- PAaptation_y(300))];
    [self.view addSubview:swView];
    
    __block UIView *vi = swView;
    
    [UIView animateWithDuration:0.25 animations:^{
        [vi setFrame:CGRectMake(0, PAaptation_y(300), SCREEN_WIDTH, SCREEN_HEIGHT- PAaptation_y(300))];
    }];
    
    swView.closeSwBlock = ^{
        [UIView animateWithDuration:0.25 animations:^{
            
            [vi setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- PAaptation_y(236))];

        } completion:^(BOOL finished) {
            if (finished) {
                [vi removeFromSuperview];
            }
        }];
    };
}
#pragma mark - LazyLoad -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
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
        _titleLabel.text = @"管理・設定";
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
@end
