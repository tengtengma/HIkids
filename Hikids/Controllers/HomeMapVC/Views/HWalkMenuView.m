//
//  HWalkMenuView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/30.
//

#import "HWalkMenuView.h"
#import "HStudentStateTopView.h"
#import "HStudentStateBottomView.h"
#import "HStudentFooterView.h"

@interface HWalkMenuView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL safeExpand;
@property (nonatomic, assign) BOOL exceptExpand;

@end

@implementation HWalkMenuView

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
        return 2;
    }
    return 1;
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (self.safeExpand) {
            if (indexPath.row == 0) {
                return PAaptation_y(129);
            }else{
                return PAaptation_y(78);
            }
            
        }else{
            return PAaptation_y(129);
        }
        return PAaptation_y(129);
    }
    if (indexPath.section == 1) {
        if (self.exceptExpand) {
            if (indexPath.row == 0) {
                return PAaptation_y(129);
            }else{
                return PAaptation_y(78);
            }
        }
        return PAaptation_y(129);
    }
    return 1;
}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.safeExpand ? self.safeList.count : 1;
    }
    if (section == 1) {
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
        
        if (self.safeExpand) {
            
            [self loadExpandWithCell:cell byType:CellType_Safe withIndexPath:indexPath];
            
        }else{
            [self loadNOExpandWithCell:cell byType:CellType_Safe];

        }
        
    }
    if (indexPath.section == 1) {
        
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
        make.top.equalTo(cell.contentView);
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
        
        //未展开的bottomView
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
        //未展开的bottomView
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
                make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
                make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
                make.height.mas_equalTo(PAaptation_y(47));
            }];
            
            DefineWeakSelf;
            safeTopView.expandBlock = ^{
                weakSelf.safeExpand = !weakSelf.safeExpand;
                [weakSelf reloadData];
            };
            
            HStudent *student = [self.safeList safeObjectAtIndex:indexPath.row];
            HStudentFooterView *safeFooterView = [[HStudentFooterView alloc] init];
            [safeFooterView setupWithModel:student];
            [safeFooterView setNomalBorder];
            [cell.contentView addSubview:safeFooterView];
            
            [safeFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(safeTopView.mas_bottom);
                make.left.equalTo(safeTopView);
                make.right.equalTo(safeTopView.mas_right);
                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            
        }else{
            

            HStudent *student = [self.safeList safeObjectAtIndex:indexPath.row];
            HStudentFooterView *safeFooterView = [[HStudentFooterView alloc] init];
            [safeFooterView setupWithModel:student];
            [cell.contentView addSubview:safeFooterView];
            
            [safeFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
                make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            
            if (indexPath.row == self.safeList.count -1) {
                [safeFooterView setLastCellBorder];
            }else{
                [safeFooterView setNomalBorder];
            }
        }
        
    }
    if (type == CellType_Danger) {
        
        if (indexPath.row == 0) {
            
            HStudentStateTopView *dangerTopView = [[HStudentStateTopView alloc] init];
            dangerTopView.studentList = self.exceptList;
            [dangerTopView loadDangerStyle];
            [cell.contentView addSubview:dangerTopView];
            [dangerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
                make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
                make.height.mas_equalTo(PAaptation_y(47));
            }];
            
            DefineWeakSelf;
            dangerTopView.expandBlock = ^{
                weakSelf.exceptExpand = !weakSelf.exceptExpand;
                [weakSelf reloadData];
            };
            
            HStudent *student = [self.exceptList safeObjectAtIndex:indexPath.row];
            HStudentFooterView *dangerFooterView = [[HStudentFooterView alloc] init];
            [dangerFooterView setupWithModel:student];
            [dangerFooterView setNomalBorder];
            [cell.contentView addSubview:dangerFooterView];
            
            [dangerFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(dangerTopView.mas_bottom);
                make.left.equalTo(dangerTopView);
                make.right.equalTo(dangerTopView.mas_right);
                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            
        }else{
            

            HStudent *student = [self.exceptList safeObjectAtIndex:indexPath.row];
            HStudentFooterView *dangerFooterView = [[HStudentFooterView alloc] init];
            [dangerFooterView setupWithModel:student];
            [cell.contentView addSubview:dangerFooterView];
            
            [dangerFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView);
                make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
                make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
                make.bottom.equalTo(cell.contentView.mas_bottom);
            }];
            
            if (indexPath.row == self.exceptList.count -1) {
                [dangerFooterView setLastCellBorder];
            }else{
                [dangerFooterView setNomalBorder];
            }
        }
        
    }
}

@end
