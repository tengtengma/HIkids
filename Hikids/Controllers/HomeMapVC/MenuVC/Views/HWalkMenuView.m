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
#import "HSetAlertAccurateVC.h"


@interface HWalkMenuView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL safeExpand;
@property (nonatomic, assign) BOOL exceptExpand;

@end

@implementation HWalkMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self createTableFooterView];
        
    }
    return self;
}
- (void)createTableFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, PAaptation_y(164))];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"アラート感度";
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = [UIColor grayColor];
    [footerView addSubview:desLabel];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(PAaptation_y(20));
        make.left.equalTo(footerView).offset(PAdaptation_x(18));
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 8;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
    bgView.userInteractionEnabled = YES;
    [footerView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(desLabel.mas_bottom).offset(PAaptation_y(5));
        make.left.equalTo(footerView).offset(PAdaptation_x(24));
        make.right.equalTo(footerView.mas_right).offset(-PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(44));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAlertAccurateVC:)];
    [bgView addGestureRecognizer:tap];
    

    
    NSNumber *alertWalkLevel = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AlertWalkLevel];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [self showAlertWalkName:alertWalkLevel];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = BWColor(34, 34, 34, 1);
    label.tag = 1001;
    [footerView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.equalTo(bgView).offset(PAdaptation_x(18));
    }];


    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom ];
    [button setImage:[UIImage imageNamed:@"walkEnd.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(walkEndAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(PAaptation_y(20));
        make.centerX.equalTo(bgView);
        make.width.mas_equalTo(PAdaptation_x(240));
        make.height.mas_equalTo(PAaptation_y(47));
    }];
    
//    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.changeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
//    self.changeButton.layer.backgroundColor = BWColor(255, 75, 0, 1).CGColor;
//    self.changeButton.layer.cornerRadius = 24;
//    self.changeButton.layer.borderWidth = 2;
//    self.changeButton.layer.borderColor = BWColor(76, 53, 41, 1).CGColor;
//    [self.changeButton addTarget:self action:@selector(destOrbackAction:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:self.changeButton];
//    
//    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(button.mas_bottom).offset(PAaptation_y(20));
//        make.left.equalTo(button);
//        make.width.mas_equalTo(PAdaptation_x(240));
//        make.height.mas_equalTo(PAaptation_y(47));
//    }];
    
    
}
- (void)openAlertAccurateVC:(id)sender
{
    AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    HSetAlertAccurateVC *accurateVC = [[HSetAlertAccurateVC alloc] init];
    accurateVC.source = 1;
    accurateVC.taskId = self.taskId;
    [dele.window.rootViewController presentViewController:accurateVC animated:YES completion:nil];
    
    DefineWeakSelf;
    accurateVC.saveFinishedBlock = ^{
        NSNumber *alertWalkLevel = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AlertWalkLevel];
        
        UILabel *label = (UILabel *)[weakSelf viewWithTag:1001];
        label.text = [weakSelf showAlertWalkName:alertWalkLevel];
    };
}
- (void)walkEndAction:(id)sender
{
    if (self.walkEndBlock) {
        self.walkEndBlock();
    }
}
- (void)destOrbackAction:(UIButton *)button
{
    if(self.changeWalkStateBlock){
        self.changeWalkStateBlock(button);
    }
}
- (NSString *)showAlertWalkName:(NSNumber *)index
{
    NSString *showAlertName = nil;
    if (index.integerValue == 0) {
        showAlertName = @"アラート感度設定：普通";
    }else{
        
        if (index.integerValue == 1) {
            showAlertName = @"アラート感度設定：高感度";
            
        }else if (index.integerValue == 2){
            showAlertName = @"アラート感度設定：やや高感度";
            
        }else if (index.integerValue == 3){
            showAlertName = @"アラート感度設定：普通";

        }else if (index.integerValue == 4){
            showAlertName = @"アラート感度設定：やや低感度";
            
        }else{
            showAlertName = @"アラート感度設定：低感度";
        }
    }
    return showAlertName;
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
    
    if (self.exceptList.count == 0) {
        
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
        
    }else{
        if (indexPath.section == 0) {
            if (!self.exceptExpand) {
                if (indexPath.row == 0) {
                    return PAaptation_y(129);
                }else{
                    return PAaptation_y(78);
                }
            }
            return PAaptation_y(129);
        }
        if (indexPath.section == 1) {
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
    }


    return 1;
}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.exceptList.count == 0) {
        if (section == 0) {
            if (self.safeExpand) {
                return self.safeList.count;
            }else{
                if (self.safeList.count == 0) {
                    return 0;
                }else{
                    return 1;
                }
            }
        }
        
    }else{
        if (section == 0) {
            
            if (!self.exceptExpand) {
                return self.exceptList.count;
            }else{
                if (self.exceptList.count == 0) {
                    return 0;
                }else{
                    return 1;
                }
            }

        }
        if (section == 1) {
            if (self.safeExpand) {
                return self.safeList.count;
            }else{
                if (self.safeList.count == 0) {
                    return 0;
                }else{
                    return 1;
                }
            }
            
        }
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
    
    if (self.exceptList.count == 0) {
        
        if (indexPath.section == 0) {
            
            if (self.safeExpand) {
                
                [self loadExpandWithCell:cell byType:CellType_Safe withIndexPath:indexPath];
                
            }else{
                [self loadNOExpandWithCell:cell byType:CellType_Safe];

            }

        }
        
    }else{
        if (indexPath.section == 0) {
            
            if (!self.exceptExpand) {
                
                [self loadExpandWithCell:cell byType:CellType_Danger withIndexPath:indexPath];
                
            }else{
                [self loadNOExpandWithCell:cell byType:CellType_Danger];

            }
            
        }
        if (indexPath.section == 1) {
            
            if (self.safeExpand) {
                
                [self loadExpandWithCell:cell byType:CellType_Safe withIndexPath:indexPath];
                
            }else{
                [self loadNOExpandWithCell:cell byType:CellType_Safe];

            }

        }
    }
    


    return cell;
}

- (void)loadNOExpandWithCell:(UITableViewCell *)cell byType:(CellType)type
{

    
    if (type == CellType_Safe) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 12;
        bgView.layer.borderWidth = 2;
        bgView.layer.borderColor = BWColor(45, 100, 29, 0.8).CGColor;
        [cell.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.exceptList.count == 0) {
                make.top.equalTo(cell.contentView);
            }else{
                make.top.equalTo(cell.contentView).offset(PAaptation_y(16));
            }
            make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
            make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
    
        HStudentStateTopView *safeTopView = [[HStudentStateTopView alloc] init];
        safeTopView.type = TYPE_WALK;
        safeTopView.studentList = self.safeList;
        [safeTopView loadSafeStyle];
        [safeTopView.expandBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [bgView addSubview:safeTopView];
        [safeTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.left.equalTo(bgView);
            make.width.equalTo(bgView);
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        
        //未展开的bottomView
        HStudentStateBottomView *safeBottomView = [[HStudentStateBottomView alloc] initWithArray:self.safeList withSafe:YES withBus:NO];
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
            [weakSelf.tableView reloadData];
        };
        
    }
    if (type == CellType_Danger) {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 12;
        bgView.layer.borderWidth = 2;
        bgView.layer.borderColor = BWColor(76, 40, 11, 0.8).CGColor;
        [cell.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
            make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
        HStudentStateTopView *dangerTopView = [[HStudentStateTopView alloc] init];
        dangerTopView.type = TYPE_WALK;
        dangerTopView.studentList = self.exceptList;
        [dangerTopView loadDangerStyle];
        [dangerTopView.expandBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [bgView addSubview:dangerTopView];
        [dangerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView);
            make.left.equalTo(bgView);
            make.width.equalTo(bgView);
            make.height.mas_equalTo(PAaptation_y(47));
        }];
        //未展开的bottomView
        HStudentStateBottomView *dangerBottomView = [[HStudentStateBottomView alloc] initWithArray:self.exceptList withSafe:NO withBus:NO];
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
            [weakSelf.tableView reloadData];
        };
    }
}
- (void)loadExpandWithCell:(UITableViewCell *)cell byType:(CellType)type withIndexPath:(NSIndexPath *)indexPath
{
    if (type == CellType_Safe) {
        
        if (indexPath.row == 0) {
            
            HStudentStateTopView *safeTopView = [[HStudentStateTopView alloc] init];
            safeTopView.type = TYPE_WALK;
            safeTopView.studentList = self.safeList;
            [safeTopView loadSafeStyle];
            [safeTopView.expandBtn setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:safeTopView];
            
            [safeTopView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.exceptList.count == 0) {
                    make.top.equalTo(cell.contentView);
                }else{
                    make.top.equalTo(cell.contentView).offset(PAaptation_y(16));
                }
                make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
                make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
                make.height.mas_equalTo(PAaptation_y(47));
            }];
            
            DefineWeakSelf;
            safeTopView.expandBlock = ^{
                weakSelf.safeExpand = !weakSelf.safeExpand;
                [weakSelf.tableView reloadData];
            };
            
            HStudent *student = [self.safeList safeObjectAtIndex:indexPath.row];
            HStudentFooterView *safeFooterView = [[HStudentFooterView alloc] init];
            safeFooterView.type = FootTYPE_WALK;
            [safeFooterView setupWithModel:student];
            [safeFooterView loadSafeStyle];
            self.safeList.count == 1 ? [safeFooterView setLastCellBorder] : [safeFooterView setNomalBorder];
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
            safeFooterView.type = FootTYPE_WALK;
            [safeFooterView setupWithModel:student];
            [safeFooterView loadSafeStyle];
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
            dangerTopView.type = TYPE_WALK;
            dangerTopView.studentList = self.exceptList;
            [dangerTopView loadDangerStyle];
            [dangerTopView.expandBtn setImage:[UIImage imageNamed:@"expand.png"] forState:UIControlStateNormal];
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
                [weakSelf.tableView reloadData];
            };
            
            HStudent *student = [self.exceptList safeObjectAtIndex:indexPath.row];
            HStudentFooterView *dangerFooterView = [[HStudentFooterView alloc] init];
            dangerFooterView.type = FootTYPE_WALK;
            [dangerFooterView setupWithModel:student];
            [dangerFooterView loadDangerStyle];
            self.exceptList.count == 1 ? [dangerFooterView setLastCellBorder] : [dangerFooterView setNomalBorder];
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
            dangerFooterView.type = FootTYPE_WALK;
            [dangerFooterView setupWithModel:student];
            [dangerFooterView loadDangerStyle];
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
#pragma mark - UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HStudent *student = nil;
    
    if(self.exceptList.count == 0){
        student = [self.safeList safeObjectAtIndex:indexPath.row];
    }else{
        if(indexPath.section == 0){
            student = [self.exceptList safeObjectAtIndex:indexPath.row];
        }
        if(indexPath.section == 1){
            student = [self.safeList safeObjectAtIndex:indexPath.row];
        }

    }

    
    if(self.showSelectMarkerBlock){
        self.showSelectMarkerBlock(student);
    }
}
@end
