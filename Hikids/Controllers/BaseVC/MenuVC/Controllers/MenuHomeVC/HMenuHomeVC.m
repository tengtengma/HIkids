//
//  HMenuHomeVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HMenuHomeVC.h"
#import "HHomeStateCell.h"

@interface HMenuHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger ShowSum;//弹出计数
@property (nonatomic, assign) BOOL expandSafe;
@property (nonatomic, assign) BOOL expandDanger;


@end

@implementation HMenuHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PAaptation_y(32));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-PAaptation_y(32));
    }];

}
- (void)gotoVCAction:(UIButton *)button
{
    NSString *name = button.tag == 1000 ? @"sleepVC" : @"walkVC";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCNotification" object:@{@"changeName":name}];
}
- (void)clickMenuAction:(UITapGestureRecognizer *)tap
{

    if (self.ShowSum == 3) {
        
        [self closeMenuVC];
        self.ShowSum = -1;
    }else{
        [self showMenuVC];
    }
    
    self.ShowSum++;
    
}

- (void)showMenuVC
{
    __block CGRect menuRect;
    __block CGRect cardRect;
    if (self.ShowSum == 0) {
        menuRect = CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(360), SCREEN_WIDTH, SCREEN_HEIGHT);
        cardRect = CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT -  PAaptation_y(451), PAdaptation_x(115), PAaptation_y(79));
    }
    if (self.ShowSum == 1) {
        menuRect = CGRectMake(0, SCREEN_HEIGHT-PAaptation_y(480), SCREEN_WIDTH, SCREEN_HEIGHT);
        cardRect = CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - PAaptation_y(571), PAdaptation_x(115), PAaptation_y(79));

    }
    if (self.ShowSum == 2) {
        menuRect = CGRectMake(0, BW_StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
        cardRect = CGRectMake(0,0,0,0);

        self.cardView.hidden = YES;

    }
    DefineWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.view.frame = menuRect;
        weakSelf.cardView.frame = cardRect;
    }];

}
- (void)closeMenuVC
{
    self.cardView.hidden = NO;
 
    DefineWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.view.frame = CGRectMake(0, SCREEN_HEIGHT- PAaptation_y(110), SCREEN_WIDTH, SCREEN_HEIGHT);
        weakSelf.cardView.frame = CGRectMake(PAdaptation_x(5), SCREEN_HEIGHT - PAaptation_y(200), PAdaptation_x(115), PAaptation_y(79));
    }];
}
#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (self.exceptArray.count != 0) {
        return self.expandDanger ? self.exceptArray.count : 2;
    }else{
        return self.expandSafe ? self.nomalArray.count : 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentify";
    HHomeStateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HHomeStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    if (indexPath.section == 0) {
        
        UIButton *sleepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sleepBtn.tag = 1000;
        [sleepBtn setImage:[UIImage imageNamed:@"btn_menu_sleep.png"] forState:UIControlStateNormal];
        [sleepBtn addTarget:self action:@selector(gotoVCAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:sleepBtn];
        
        [sleepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(PAdaptation_x(23));
            make.width.mas_equalTo(PAdaptation_x(166));
            make.height.mas_equalTo(PAaptation_y(96));
        }];
        
        UIButton *walkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        walkBtn.tag = 1001;
        [walkBtn setImage:[UIImage imageNamed:@"btn_menu_walk.png"] forState:UIControlStateNormal];
        [walkBtn addTarget:self action:@selector(gotoVCAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:walkBtn];
        
        [walkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(sleepBtn.mas_right).offset(PAdaptation_x(12));
            make.width.mas_equalTo(PAdaptation_x(166));
            make.height.mas_equalTo(PAaptation_y(96));
        }];
        
        
    }
    if (indexPath.section == 1) {
        
        if (self.expandDanger) {
            
        }else{
            [cell setupCellWithModel:nil withStyle:CellType_Danger];
            DefineWeakSelf;
            cell.expandBlock = ^{
                weakSelf.expandDanger = !weakSelf.expandDanger;
            };
        }
        if (indexPath.row == 1) {
            [cell setupCellWithModel:nil withStyle:CellType_Safe];
            DefineWeakSelf;
            cell.expandBlock = ^{
                weakSelf.expandSafe = !weakSelf.expandSafe;
            };
        }
        

    }

    return cell;
}

#pragma mark-
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return PAaptation_y(125);
    }else{
        return PAaptation_y(129);
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return PAaptation_y(30);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(23), 0, SCREEN_WIDTH, PAaptation_y(30))];
    if (section == 0) {
        label.text = @"利用シーン";
    }else{
        label.text = @"園児リスト";
    }
    label.font = [UIFont boldSystemFontOfSize:20];
    [headerView addSubview:label];
    
    return headerView;
}

#pragma mark - LazyLoad -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
