//
//  HMenuHomeVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HMenuHomeVC.h"
#import "HHomeStateCell.h"
#import "HStudent.h"
#import "HStudentStateView.h"

@interface HMenuHomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger ShowSum;//弹出计数
@property (nonatomic, assign) BOOL expandSafe;
@property (nonatomic, assign) BOOL expandDanger;
@property (nonatomic, strong) HStudentStateView *stateView;


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
    
    [self.stateView setFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, self.view.frame.size.height)];
    [self.view addSubview:self.stateView];

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
    if (self.exceptArray.count != 0) {
        return 3;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (self.exceptArray.count != 0) {
        if (section == 1) {
            return self.expandDanger ? self.exceptArray.count : 0;
        }
        if (section == 2) {
            return self.expandSafe ? self.nomalArray.count : 0;
        }
    }else{
        if (section == 1) {
            return self.expandSafe ? self.nomalArray.count : 0;

        }
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(23), 0, SCREEN_WIDTH, PAaptation_y(30))];
        label.text = @"利用シーン";
        label.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:label];
        
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
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"園児リスト";
        label1.font = [UIFont boldSystemFontOfSize:20];
        [cell.contentView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(walkBtn.mas_bottom).offset(PAaptation_y(PAaptation_y(24)));
            make.left.equalTo(label);
        }];
        
    }


    return cell;
}

#pragma mark-
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return PAaptation_y(125+84);
    }else{
        return PAaptation_y(129);
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return PAaptation_y(129);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }

    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];

    UIView *bgView = [[UIView alloc] init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    [headerView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView);
        make.left.equalTo(headerView).offset(PAdaptation_x(24));
        make.right.equalTo(headerView.mas_right).offset(-PAdaptation_x(24));
        make.bottom.equalTo(headerView.mas_bottom).offset(-PAaptation_y(16));
    }];
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = BWColor(255, 75, 0, 1);
    [bgView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView);
        make.width.equalTo(bgView);
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [bgView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(topView).offset(PAdaptation_x(16));
        make.width.mas_equalTo(PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(24));
    }];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.font = [UIFont systemFontOfSize:20];
    [topView addSubview:stateLabel];
    
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.left.equalTo(iconView.mas_right).offset(PAdaptation_x(10));
    }];
    
    UIView *numberBg = [[UILabel alloc] init];
    numberBg.backgroundColor = [UIColor whiteColor];
    [topView addSubview:numberBg];
    [numberBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.left.equalTo(stateLabel.mas_right).offset(PAdaptation_x(10));
        make.width.mas_equalTo(PAdaptation_x(59));
        make.height.mas_equalTo(PAaptation_y(26));
    }];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.font = [UIFont systemFontOfSize:16];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(numberBg);
    }];
    
    UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    expandBtn.tag = section+1000;
    [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
    [expandBtn setImage:[UIImage imageNamed:@"triangle_small.png"] forState:UIControlStateNormal];
    [topView addSubview:expandBtn];
    [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topView);
        make.right.equalTo(topView.mas_right).offset(-PAdaptation_x(11.5));
        make.width.mas_equalTo(PAdaptation_x(21));
        make.height.mas_equalTo(PAaptation_y(24));
    }];
    
    
    
    if (self.exceptArray.count != 0) {
        if (section == 1) {
            [iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
            stateLabel.text = @"危険";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.exceptArray.count];
            topView.backgroundColor = BWColor(255, 75, 0, 1);
            numberLabel.textColor = BWColor(255, 75, 0, 1);
            numberBg.backgroundColor = [UIColor whiteColor];
            [self createStudentViewWithArray:self.exceptArray topView:topView bgView:bgView];

        }
        if (section == 2) {
            [iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
            stateLabel.text = @"安全";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.nomalArray.count];
            numberBg.backgroundColor = BWColor(5, 70, 11, 1);
            topView.backgroundColor = BWColor(0, 176, 107, 1);
            [self createStudentViewWithArray:self.nomalArray topView:topView bgView:bgView];

        }
    }else{
        if (section == 1) {
            [iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
            stateLabel.text = @"安全";
            numberLabel.text = [NSString stringWithFormat:@"%ld人",self.nomalArray.count];
            numberBg.backgroundColor = BWColor(5, 70, 11, 1);
            topView.backgroundColor = BWColor(0, 176, 107, 1);
            [self createStudentViewWithArray:self.nomalArray topView:topView bgView:bgView];

        }
    }
    

    
    return headerView;
}
- (void)createStudentViewWithArray:(NSArray *)array topView:(UIView *)topView bgView:(UIView *)bgView
{
    UIImageView *tempView = nil;
    for (NSInteger i = 0; i < array.count; i++) {
        
        HStudent *student = [array safeObjectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
        imageView.layer.cornerRadius = PAdaptation_x(36)/2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
        [bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(PAaptation_y(12));
            if (tempView) {
                make.left.equalTo(tempView.mas_right).offset(PAdaptation_x(6));
            }else{
                make.left.equalTo(bgView).offset(PAdaptation_x(6));
            }
            make.width.mas_equalTo(PAdaptation_x(36));
            make.height.mas_equalTo(PAaptation_y(36));
        }];
        
        tempView = imageView;
    }
}
- (void)clickExpandAction:(UIButton *)button
{
    self.stateView.array = button.tag == 1001 ? self.exceptArray : self.nomalArray;
    self.stateView.isSafe = button.tag == 1001 ? NO : YES;
    [self.stateView tableReload];
    
    
    DefineWeakSelf;
    [UIView animateWithDuration:0.25 animations:^{
        
        [weakSelf.stateView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
            
    }];
    
    self.stateView.closeBlock = ^{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [weakSelf.stateView setFrame:CGRectMake(0, weakSelf.view.frame.size.height, SCREEN_WIDTH, weakSelf.view.frame.size.height)];
        }];

    };
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
- (HStudentStateView *)stateView
{
    if (!_stateView) {
        _stateView = [[HStudentStateView alloc] init];
        _stateView.backgroundColor = [UIColor whiteColor];
    }
    return _stateView;
}


@end
