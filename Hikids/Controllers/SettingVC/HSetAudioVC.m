//
//  HSetAudioVC.m
//  Hikids
//
//  Created by 马腾 on 2024/4/17.
//

#import "HSetAudioVC.h"
#import "HSetAlertView.h"
#import "BWSetRingReq.h"
#import "BWSetRingResp.h"
#import "AVFoundation/AVFoundation.h"

@interface HSetAudioVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *selectSoundId;
@property (nonatomic, strong) NSString *soundName;
@property (nonatomic, strong) NSString *ringPath;
@property (nonatomic, assign) SystemSoundID soundId;

@end

@implementation HSetAudioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array0 = @[@{@"soundId":@"1",@"iconName":@"strong.png",@"text":@"アラ-ト1"},
                        @{@"soundId":@"2",@"iconName":@"strong.png",@"text":@"アラ-ト2"},
                        @{@"soundId":@"3",@"iconName":@"strong.png",@"text":@"アラ-ト3"}];
    
    NSArray *array1 = @[@{@"soundId":@"4",@"iconName":@"normal.png",@"text":@"アラ-ト4"},
                        @{@"soundId":@"5",@"iconName":@"normal.png",@"text":@"アラ-ト5"},
                        @{@"soundId":@"6",@"iconName":@"normal.png",@"text":@"アラ-ト6"}];
    
    NSArray *array2 = @[@{@"soundId":@"7",@"iconName":@"weak.png",@"text":@"アラ-ト7"},
                        @{@"soundId":@"8",@"iconName":@"weak.png",@"text":@"アラ-ト8"},
                        @{@"soundId":@"9",@"iconName":@"weak.png",@"text":@"アラ-ト9"}];
    
    
    self.dataArray = @[array0, array1, array2];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *ringNumber = [user objectForKey:KEY_RingNumber];
    
    if (ringNumber.integerValue != 0) {
        self.selectSoundId = [NSString stringWithFormat:@"%ld",ringNumber.integerValue];
    }else{
        self.selectSoundId = @"1";
    }
    
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
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PAaptation_y(70))];
    self.tableView.tableFooterView = footerView;
    
    [self.saveBtn setFrame:CGRectMake(SCREEN_WIDTH/2 - PAdaptation_x(240)/2, footerView.frame.size.height/2 - PAaptation_y(47)/2, PAdaptation_x(240), PAaptation_y(47))];
    [footerView addSubview:self.saveBtn];

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
- (void)saveAction:(id)sender
{
    NSLog(@"保存sound");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    DefineWeakSelf;
    BWSetRingReq *ringReq = [[BWSetRingReq alloc] init];
    ringReq.ringNumber = [NSNumber numberWithInteger:self.selectSoundId.integerValue];
    [NetManger putRequest:ringReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWSetRingResp *ringResp = (BWSetRingResp *)resp;
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSNumber numberWithInteger:weakSelf.selectSoundId.integerValue] forKey:KEY_RingNumber];
        [user synchronize];
        
        [MBProgressHUD showMessag:@"正常に保存" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];

        NSLog(@"success");
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
#pragma mark - UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *contentView = [[UIView alloc] init];
    contentView.userInteractionEnabled = YES;
    [cell.contentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
        make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
        make.bottom.equalTo(cell.contentView.mas_bottom);
    }];
    
    [self createAlertViewWithArray:self.dataArray[indexPath.section] withContent:contentView];
    
    return cell;
}
- (void)createAlertViewWithArray:(NSArray *)soundList withContent:(UIView *)contentView
{
    for (NSInteger i = 0; i < soundList.count; i++) {
        
        NSDictionary *dic = [soundList safeObjectAtIndex:i];
        NSString *soundId = [dic safeObjectForKey:@"soundId"];
        NSString *iconName = [dic safeObjectForKey:@"iconName"];
        NSString *text = [dic safeObjectForKey:@"text"];
        
        HSetAlertView *alertView = [[HSetAlertView alloc] init];
        alertView.soundId = soundId;
        alertView.nameLabel.text = text;
        [alertView.iconImageView setImage:[UIImage imageNamed:iconName]];
        [contentView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView).offset(PAaptation_y(5));
            if (i == 0) {
                make.left.equalTo(contentView);
            }else if (i == 1){
                make.centerX.equalTo(contentView);
            }else{
                make.right.equalTo(contentView.mas_right);
            }
            make.width.mas_equalTo(PAdaptation_x(96));
            make.height.mas_equalTo(PAaptation_y(128));
                    
        }];

        if ([self.selectSoundId isEqualToString:soundId]) {
            [alertView selectStyle];
        }else{
            [alertView selectNomalStyle];
        }
        
        DefineWeakSelf;
        alertView.selectBlock = ^(NSString * _Nonnull soundId, NSString *soundName) {
            weakSelf.selectSoundId = soundId;
            weakSelf.soundName = soundName;
            [weakSelf getChatMessageGoToSoundWithId:soundId];
            [weakSelf.tableView reloadData];

        };

    }

}
#pragma -mark -调用声音
- (void)getChatMessageGoToSoundWithId:(NSString *)soundId
{

    NSString *audioName = nil;
    if ([soundId isEqualToString:@"1"]) {
        audioName = @"strong_01";
    }else if ([soundId isEqualToString:@"2"]){
        audioName = @"strong_02";
    }else if ([soundId isEqualToString:@"3"]){
        audioName = @"strong_03";
    }else if ([soundId isEqualToString:@"4"]){
        audioName = @"normal_01";
    }else if ([soundId isEqualToString:@"5"]){
        audioName = @"normal_02";
    }else if ([soundId isEqualToString:@"6"]){
        audioName = @"normal_03";
    }else if ([soundId isEqualToString:@"7"]){
        audioName = @"weak_01";
    }else if ([soundId isEqualToString:@"8"]){
        audioName = @"weak_02";
    }else{
        audioName = @"weak_03";
    }
    
    if (self.soundId) {
        AudioServicesDisposeSystemSoundID(self.soundId);
        self.soundId = 0;
    }
    
    self.ringPath = [[NSBundle mainBundle] pathForResource:audioName ofType:@"wav"];


    if (self.ringPath) {
        SystemSoundID sd;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:self.ringPath],&sd);
        if (error != kAudioServicesNoError) {
            NSLog(@"----调用系统声音出错----");
            sd = 0;
        }
        AudioServicesPlaySystemSound(sd);
        
        self.soundId = sd;
    }
}
#pragma mark - UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PAaptation_y(125+10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PAaptation_y(49);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , PAaptation_y(30))];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(24), 0, headerView.frame.size.width - PAdaptation_x(48), PAaptation_y(20))];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = BWColor(0, 28, 41, 1);
    [headerView addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(24), CGRectGetMaxY(label.frame), headerView.frame.size.width - PAdaptation_x(48), PAaptation_y(15))];
    subLabel.font = [UIFont systemFontOfSize:10.5];
    subLabel.textColor = BWColor(0, 28, 41, 1);
    [headerView addSubview:subLabel];
    
    if (section == 0) {
        label.text = @"強い";
        subLabel.text = @"騒がしい環境に適している";
    }else if(section == 1){
        label.text = @"普通";
        subLabel.text = @"日常生活の環境に適している";

    }else{
        label.text = @"弱い";
        subLabel.text = @"静かな環境に適している";

    }
    
    return headerView;
}
#pragma mark - Lazy Load -
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
        _titleLabel.text = @"アラート通知音設定";
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
- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
@end
