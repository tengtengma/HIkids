//
//  HAccountVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HAccountVC.h"
#import "HLoginVC.h"

@interface HAccountVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor clearColor];
    //暂时隐藏 14/01/2024
//    self.dataArray = @[@"アカウント:",@"メール:",@"位置情報",@"通知権限",@"Bluetooth",@"モバイルデータ通信"];
    self.dataArray = @[@"アカウント:",@"位置情報",@"通知権限",@"モバイルデータ通信"];

    [self createUI];
    
}
- (void)createUI
{

    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
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
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PAaptation_y(60))];
    self.tableView.tableFooterView = footerView;
    
    [self.quitBtn setFrame:CGRectMake(SCREEN_WIDTH/2 - PAdaptation_x(240)/2, footerView.frame.size.height/2 - PAaptation_y(47)/2, PAdaptation_x(240), PAaptation_y(47))];
    [footerView addSubview:self.quitBtn];
    

}
- (void)createTitleView
{
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(130));
    }];
    
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(_titleView).offset(PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(192));
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

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return PAaptation_y(120);
    }
    return PAaptation_y(80);
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
    
    if (indexPath.row == 0) {
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.font = [UIFont systemFontOfSize:14.0];
        desLabel.text = [self.dataArray safeObjectAtIndex:indexPath.row];
        desLabel.textColor = BWColor(0, 28, 41, 1);
        
        [cell.contentView addSubview:desLabel];
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(PAaptation_y(5));
            make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
        }];
        
        NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_NickName];
        NSString *emailStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_Email];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
        nameLabel.text = indexPath.row == 0 ? nameStr : emailStr;
        nameLabel.textColor = BWColor(0, 28, 41, 1);
        
        [cell.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(desLabel.mas_bottom).offset(PAaptation_y(6));
            make.left.equalTo(desLabel);
        }];
        
    }else{
        [self setupCell:cell withNameList:self.dataArray indexPath:indexPath];
    }
    
    
    return cell;
}
- (void)setupCell:(UITableViewCell *)cell withNameList:(NSArray *)nameList indexPath:(NSIndexPath *)indexPath
{
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.font = [UIFont systemFontOfSize:14.0];
    desLabel.text = [self.dataArray safeObjectAtIndex:indexPath.row];
    desLabel.textColor = BWColor(0, 28, 41, 1);
    
    [cell.contentView addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(PAaptation_y(5));
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
    }];
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
    [cell.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(PAaptation_y(5));
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
        make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(48));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"現在：ON";
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = BWColor(34, 34, 34, 1);
    [bgView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(PAdaptation_x(18));
    }];
    
    UIImageView *rightView = [[UIImageView alloc] init];
    [rightView setImage:[UIImage imageNamed:@"account_tz.png"]];
    [bgView addSubview:rightView];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView.mas_right).offset(-PAdaptation_x(12));
        make.width.mas_equalTo(PAdaptation_x(21));
        make.height.mas_equalTo(PAaptation_y(21));
    }];
}
#pragma mark - UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

    if([[UIApplication sharedApplication] canOpenURL:url]) {

        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];

    }
    
}


- (void)loginOut
{
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"注意" message:@"ログアウトします。よろしいでしょうか？" preferredStyle:UIAlertControllerStyleAlert];
        

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    
    [alertCtrl addAction:cancel];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:nil forKey:KEY_UserName];
        [user setObject:nil forKey:KEY_Password];
        [user setObject:nil forKey:KEY_Jwtoken];
        [user synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"quitAccountNoti" object:nil];

        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[[HLoginVC alloc] init]];
        app.window.rootViewController = navCtrl;
    }];
    
    
    [alertCtrl addAction:action];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];

    


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
        _titleLabel.text = @"アプリ設定・アカウント";
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = 0;
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
- (UIButton *)quitBtn
{
    if (!_quitBtn) {
        _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitBtn setImage:[UIImage imageNamed:@"quit.png"] forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitBtn;
}
@end
