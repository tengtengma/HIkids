//
//  HWalkVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HWalkVC.h"
#import "HWalkMenuVC.h"
#import "HMddView.h"
#import "HStudentView.h"
#import "BWGetDestnationReq.h"
#import "BWGetDestnationResp.h"
#import "HDestnationModel.h"
#import "BWGetStudentReq.h"
#import "BWGetStudentResp.h"
#import "HStudent.h"
#import "HTitleView.h"
#import "HTeacher.h"
#import "HTime.h"

@interface HWalkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) HWalkMenuVC *menuVC;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *startWalkBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *destnationArray; //目的地集合
@property (nonatomic, strong) NSArray *timeArray;       //选择时间集合
@property (nonatomic, strong) NSArray *teacherArray;     //老师集合
@property (nonatomic, strong) NSArray *studentArray;     //学生集合



@end

@implementation HWalkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startDestnationRequest];
    

}
- (void)startDestnationRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DefineWeakSelf;
    BWGetDestnationReq *destReq = [[BWGetDestnationReq alloc] init];
    [NetManger getRequest:destReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
            
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BWGetDestnationResp *destResp = (BWGetDestnationResp *)resp;
        
        weakSelf.destnationArray = destResp.itemList;
        
        [weakSelf startStudentRequest];
                
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)startStudentRequest
{
    DefineWeakSelf;
    BWGetStudentReq *studentReq = [[BWGetStudentReq alloc] init];
    [NetManger getRequest:studentReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetStudentResp *studentResp = (BWGetStudentResp *)resp;
        
        weakSelf.studentArray = studentResp.itemList;
        
        [weakSelf createUI];
        [weakSelf.collectionView reloadData];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)createUI
{
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bgView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(PAaptation_y(47));
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self createTableView];
    
    [self createFooterView];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *timeArray = @[@"自由",@"45分",@"60分",@"90分"];
    for (NSInteger i = 0; i < timeArray.count; i++) {
        HTime *time = [[HTime alloc] init];
        time.tId = i;
        time.name = [timeArray safeObjectAtIndex:i];
        [array addObject:time];
    }
    self.timeArray = array;
    
    NSMutableArray *array1 = [[NSMutableArray alloc] init];

    NSArray *teacherArray = @[@"小林健一",@"山本彩",@"福山湊",@"+新規追加"];
    for (NSInteger i = 0; i < teacherArray.count; i++) {
        HTeacher *teacher = [[HTeacher alloc] init];
        teacher.tId = i;
        teacher.name = [teacherArray safeObjectAtIndex:i];
        [array1 addObject:teacher];
    }
    self.teacherArray = array1;
    
    self.titleLabel.text = @"散歩モニタリング";
    self.dateLabel.text = @"2022.10.05";
}
- (void)createTitleView
{
    [self.bgView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.mas_equalTo(PAaptation_y(68+24));
    }];
    
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(_titleView).offset(PAdaptation_x(24));
    }];
    
    [self.titleView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(8));
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.titleView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleView.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(38));
    }];
}
- (void)createTableView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-PAaptation_y(80));
    }];
    
}
- (void)createFooterView
{
    [self.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(80));
    }];
    
    [self.footerView addSubview:self.startWalkBtn];
    [self.startWalkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.footerView);
        make.width.mas_equalTo(PAdaptation_x(240));
        make.height.mas_equalTo(PAaptation_y(47));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BWColor(169, 167, 166, 1);
    [self.footerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView);
        make.left.equalTo(self.footerView);
        make.width.equalTo(self.footerView);
        make.height.mas_equalTo(PAaptation_y(1));
    }];
}
- (void)backAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCNotification" object:@{@"changeName":@"mapVC"}];
}
#pragma mark - UICollectionViewDataSource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.destnationArray.count;
    }
    if (section == 1) {
        return self.timeArray.count;
    }
    if (section == 2) {
        return self.teacherArray.count;
    }
    return self.studentArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    if (indexPath.section == 0) {
        
        HDestnationModel *destModel = [self.destnationArray safeObjectAtIndex:indexPath.row];
        
        HMddView *mddView = [[HMddView alloc] init];
        [mddView setupWithModel:destModel];
        [cell.contentView addSubview:mddView];
        
        [mddView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        if (destModel.isSelected) {
            [mddView cellSelected];
        }else{
            [mddView cellNomal];
        }

        
    }
        
    if (indexPath.section == 1) {
        
        HTime *timeModel = [self.timeArray safeObjectAtIndex:indexPath.row];
        
        HTitleView *timeView = [[HTitleView alloc] init];
        [timeView setupWithModel:timeModel];
        [cell.contentView addSubview:timeView];
        
        [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        if (timeModel.isSelected) {
            [timeView cellSelected];
        }else{
            [timeView cellNomal];
        }
    }
    if (indexPath.section == 2) {
        
        HTeacher *teacherModel = [self.teacherArray safeObjectAtIndex:indexPath.row];
        
        HTitleView *titView = [[HTitleView alloc] init];
        [titView setupWithModel:teacherModel];
        [cell.contentView addSubview:titView];
        
        [titView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        if (teacherModel.isSelected) {
            [titView cellSelected];
        }else{
            [titView cellNomal];
        }
    }
   
    if (indexPath.section == 3) {
        
        HStudent *student = [self.studentArray safeObjectAtIndex:indexPath.row];
        
        HStudentView *studentView = [[HStudentView alloc] init];
        [studentView setupWithModel:student];
        [cell.contentView addSubview:studentView];

        [studentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        
        if (student.isSelected) {
            [studentView cellSelected];
        }else{
            [studentView cellNomal];
        }

    }
    

    return cell;
}

#pragma mark- UICollectionViewDataDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        HDestnationModel *selectModel = [self.destnationArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
            
        }else{
            [self.destnationArray enumerateObjectsUsingBlock:^(HDestnationModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.dId.integerValue == obj.dId.integerValue) {
                    obj.isSelected = YES;
                    return;
                }else{
                    obj.isSelected = NO;
                }
            }];
        }

    }
    if (indexPath.section == 1) {
        
        HTime *selectModel = [self.timeArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
            
        }else{
            [self.timeArray enumerateObjectsUsingBlock:^(HTime * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.tId == obj.tId) {
                    obj.isSelected = YES;
                    return;
                }else{
                    obj.isSelected = NO;
                }
            }];
        }
        
    }
    if (indexPath.section == 2) {
        
        HTeacher *selectModel = [self.teacherArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
        }else{
            [self.teacherArray enumerateObjectsUsingBlock:^(HTeacher * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.tId == obj.tId) {
                    obj.isSelected = YES;
                    return;
                }
            }];
        }
    }
    if (indexPath.section == 3) {
       
        HStudent *selectModel = [self.studentArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
        }else{
            [self.studentArray enumerateObjectsUsingBlock:^(HStudent * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.sId.integerValue == obj.sId.integerValue) {
                    obj.isSelected = YES;
                    return;
                }
            }];
        }
    }
    [self.collectionView reloadData];

}
#pragma mark - UICollectionViewLayoutDelegate -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(PAdaptation_x(170), PAaptation_y(76));

    }
    if (indexPath.section == 1) {
        return CGSizeMake(PAdaptation_x(68), PAaptation_y(36));

    }
    if (indexPath.section == 2) {
        return CGSizeMake(PAdaptation_x(75), PAaptation_y(36));
    }
    return CGSizeMake(PAdaptation_x(170), PAaptation_y(54));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
                    minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return PAdaptation_x(10);

    }
    if (section == 1) {
        return 0;

    }
    if (section == 2) {
        return 0;
    }
    return PAdaptation_x(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return PAaptation_y(10);

    }
    if (section == 1) {
        return 0;

    }
    if (section == 2) {
        return 0;
    }
    return PAaptation_y(10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, PAaptation_y(30));
    }
    return CGSizeMake(SCREEN_WIDTH, PAaptation_y(73));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(18), PAaptation_y(10), PAdaptation_x(18));
    }
    if (section == 1) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(18), PAaptation_y(10), PAdaptation_x(10));
    }
    if (section == 2) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(18), PAaptation_y(10), PAdaptation_x(10));
    }

    return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(18), PAaptation_y(10), PAdaptation_x(18));

}
//显示header和footer的回调方法

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
   if (kind == UICollectionElementKindSectionHeader)
   {
       //如果想要自定义header，只需要定义UICollectionReusableView的子类A，然后在该处使用，注意AIdentifier要设为注册的字符串，此处为“header”

       UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
       
       for (id v in headerView.subviews)
           [v removeFromSuperview];
       
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(23), headerView.frame.size.height - PAaptation_y(30), SCREEN_WIDTH, PAaptation_y(30))];
       label.font = [UIFont systemFontOfSize:14];
       label.textColor = BWColor(34, 34, 34, 1.0);
       [headerView addSubview:label];
       
       if (indexPath.section == 0) {
           label.text = @"目的地選択:";
       }else if(indexPath.section == 1){
           label.text = @"散歩予定時間:";
       }else if(indexPath.section == 2){
           label.text = @"確認者(複数選択可):";
       }else{
           label.text = @"参加児童:";
       }
       
       NSLog(@"11111111");

       return headerView;
   }

   return nil;

}
#pragma mark - LazyLoad -
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动条方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;   //是否显示滚动条
        _collectionView.scrollEnabled = YES;  //滚动使能
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //注册Cell，必须要有
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];//注册header的view

    }
    return _collectionView;
}
- (HWalkMenuVC *)menuVC
{
    if (!_menuVC) {
        _menuVC = [[HWalkMenuVC alloc] init];
    }
    return _menuVC;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    return _bgView;
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
    }
    return _titleLabel;
}
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dateLabel;
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
- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = BWColor(244, 244, 244, 1);

    }
    return _footerView;
}
- (UIButton *)startWalkBtn
{
    if (!_startWalkBtn) {
        _startWalkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startWalkBtn.enabled = NO;
        [_startWalkBtn setImage:[UIImage imageNamed:@"walkStart_no.png"] forState:UIControlStateNormal];
    }
    return _startWalkBtn;
}

@end
