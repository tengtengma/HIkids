//
//  HHomeMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HHomeMenuView.h"
#import "HStudentStateTopView.h"
#import "HStudentStateBottomView.h"

typedef enum _CellType
{
    CellType_Safe = 0,
    CellType_Danger = 1,
    CellType_Lost = 2,
    CellType_Charge = 3
}CellType;

@interface HHomeMenuView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL safeExpand;
@property (nonatomic, assign) BOOL exceptExpand;
@property (nonatomic, assign) CellType type;

@end

@implementation HHomeMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //tableview不延时
        self.delaysContentTouches = NO;
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)subView).delaysContentTouches = NO;
            }
        }
        
        //tableview下移
        self.contentInset = UIEdgeInsetsMake(500, 0, 0, 0);
    //    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];//去掉头部空白
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.sectionHeaderHeight = 0.0;//消除底部空白
        self.sectionFooterHeight = 0.0;//消除底部空白
        
    }
    return self;
}

#pragma mark - 分组 -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.exceptList.count != 0) {
        return 3;
    }
    return 2;
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return PAaptation_y(125+84);
    }
    if (indexPath.section == 1) {
        if (self.safeExpand) {
            return PAaptation_y(129+47);
            
        }else{
            return PAaptation_y(129);
        }
        return PAaptation_y(129);
    }
    if (indexPath.section == 2) {
        if (self.exceptExpand) {
            if (indexPath.row == 0) {
                return PAaptation_y(129+47);
            }else{
                return PAaptation_y(129);
            }
        }
        return PAaptation_y(129);
    }
    return 1;
}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.safeExpand ? self.safeList.count : 1;
    }
    if (section == 2) {
        return self.exceptExpand ? self.exceptList.count : 1;
    }
    return 2;
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
    if (indexPath.section == 1) {
        
        if (self.safeExpand) {
            
            [self loadExpandWithCell:cell byType:CellType_Safe withIndexPath:indexPath];
            
        }else{
            [self loadNOExpandWithCell:cell byType:CellType_Safe];

        }
        
    }
    if (indexPath.section == 2) {
        
        if (self.exceptExpand) {
            
            [self loadExpandWithCell:cell byType:CellType_Danger withIndexPath:indexPath];
            
        }else{
            [self loadNOExpandWithCell:cell byType:CellType_Danger];

        }
    }

    return cell;
}

- (void)loadNOExpandWithCell:(UITableViewCell *)cell byType:(CellType)type
{
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    [cell.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(PAaptation_y(16));
        make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
        make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
        make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PAaptation_y(16));
    }];
    
    if (type == CellType_Safe) {
    
        HStudentStateTopView *safeTopView = [[HStudentStateTopView alloc] init];
        safeTopView.studentList = self.safeList;
        [safeTopView loadSafeStyle];
        [bgView addSubview:safeTopView];
        [safeTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.left.equalTo(bgView);
            make.width.equalTo(bgView);
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        
        HStudentStateBottomView *safeBottomView = [[HStudentStateBottomView alloc] initWithArray:self.safeList];
        [bgView addSubview:safeBottomView];
        [safeBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(safeTopView.mas_bottom);
            make.left.equalTo(safeTopView);
            make.right.equalTo(safeTopView.mas_right);
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        
        DefineWeakSelf;
        safeTopView.expandBlock = ^{
            weakSelf.safeExpand = !weakSelf.safeExpand;
            [weakSelf reloadData];
        };
        
        
        
    }
    if (type == CellType_Danger) {
        
        HStudentStateTopView *dangerTopView = [[HStudentStateTopView alloc] init];
        dangerTopView.studentList = self.exceptList;
        [dangerTopView loadDangerStyle];
        [bgView addSubview:dangerTopView];
        [dangerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.left.equalTo(bgView);
            make.width.equalTo(bgView);
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        
        HStudentStateBottomView *dangerBottomView = [[HStudentStateBottomView alloc] initWithArray:self.exceptList];
        [bgView addSubview:dangerBottomView];
        [dangerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dangerTopView.mas_bottom);
            make.left.equalTo(dangerTopView);
            make.right.equalTo(dangerTopView.mas_right);
            make.bottom.equalTo(bgView.mas_bottom);
        }];
        
        DefineWeakSelf;
        dangerTopView.expandBlock = ^{
            weakSelf.exceptExpand = !weakSelf.exceptExpand;
            [weakSelf reloadData];
        };
    }
}
- (void)loadExpandWithCell:(UITableViewCell *)cell byType:(CellType)type withIndexPath:(NSIndexPath *)indexPath
{
    if (type == CellType_Safe) {
        
        if (indexPath.row == 0) {
            
            HStudentStateTopView *safeTopView = [[HStudentStateTopView alloc] init];
            safeTopView.studentList = self.safeList;
            [safeTopView loadSafeStyle];
            [cell.contentView addSubview:safeTopView];
            [safeTopView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView);
                make.width.equalTo(cell.contentView);
                make.height.mas_equalTo(PAaptation_y(47));
            }];
            
            DefineWeakSelf;
            safeTopView.expandBlock = ^{
                weakSelf.safeExpand = !weakSelf.safeExpand;
                [weakSelf reloadData];
            };
            
            UIView *vie = [[UIView alloc] init];
            vie.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:vie];
            [vie mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(safeTopView.mas_bottom);
                make.left.equalTo(safeTopView);
                make.right.equalTo(cell.contentView.mas_right);
                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            
        }else{
            
            UIView *vie = [[UIView alloc] init];
            vie.backgroundColor = [UIColor yellowColor];
            [cell.contentView addSubview:vie];
            [vie mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView);
                make.width.equalTo(cell.contentView);
                make.height.equalTo(cell.contentView);
            }];
        }
        
    }
    if (type == CellType_Danger) {
        
        if (indexPath.row == 0) {
            
        }
    }
}
@end
