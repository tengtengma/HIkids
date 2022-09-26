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

@end

@implementation HMenuHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PAaptation_y(32));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];

}
- (void)gotoVCAction:(UIButton *)button
{
    NSString *name = button.tag == 1000 ? @"sleepVC" : @"walkVC";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCNotification" object:@{@"changeName":name}];
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
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentify";
    HHomeStateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HHomeStateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
            make.height.mas_equalTo(PAaptation_y(79));
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
            make.height.mas_equalTo(PAaptation_y(79));
        }];
        
        
    }
    if (indexPath.section == 1) {
        
    }

    return cell;
}

#pragma mark-
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return PAaptation_y(120);
    }else{
        return PAaptation_y(129);
    }
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"利用シーン";
    }else{
        return @"園児リスト";
    }
    return @"利用シーン";
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
