//
//  HInfomationVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HInfomationVC.h"
#import "HDestnationModel.h"
#import "HMddView.h"
#import "BWGetInformationReq.h"
#import "BWGetInformationResp.h"

@interface HInfomationVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *mainTeacherArray;
@property (nonatomic, strong) NSArray *teacherArray;
@property (nonatomic, strong) NSArray *classKids;
@property (nonatomic, copy) NSString *classAge;
@property (nonatomic, copy) NSString *className;

//@property (nonatomic, strong) NSArray *destArray;

@end

@implementation HInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

//    self.sectionArray = @[@"クラス：",@"年齢：",@"担任先生：",@"先生：",@"園児：",@"散歩目的地："];
    self.sectionArray = @[@"クラス：",@"学年：",@"管理者：",@"園児："];
    [self createUI];

    [self startRequest];
}
- (void)startRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DefineWeakSelf;
    BWGetInformationReq *req = [[BWGetInformationReq alloc] init];
    [NetManger getRequest:req withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetInformationResp *infoResp = (BWGetInformationResp *)resp;
        
        weakSelf.mainTeacherArray = [infoResp.item safeObjectForKey:@"classTeacher"];
        weakSelf.classKids = [infoResp.item safeObjectForKey:@"classKids"];
        weakSelf.className = [infoResp.item safeObjectForKey:@"className"];
        weakSelf.classAge = [infoResp.item safeObjectForKey:@"classAge"];
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    
    }];
}
- (void)createUI
{
    
//    self.destArray = @[@{@"name":@"東山動植物園",@"distance":@"0.9",@"image":[UIImage imageNamed:@"dest0.jpeg"]},@{@"name":@"植園公園",@"distance":@"1.2",@"image":[UIImage imageNamed:@"dest1.jpeg"]}];
    
//    [self.view addSubview:self.bgView];
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self createTableView];
}
- (void)createTitleView
{
   [self.view addSubview:self.titleView];
   [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.topView.mas_bottom);
       make.left.equalTo(self.view);
       make.width.equalTo(self.view);
       make.height.mas_equalTo(PAaptation_y(68+24));
   }];
   
   [self.titleView addSubview:self.titleLabel];
   [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.topView.mas_bottom);
       make.left.equalTo(_titleView).offset(PAdaptation_x(24));
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
       make.bottom.equalTo(self.view.mas_bottom);
   }];
   
}
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionViewDataSource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return self.mainTeacherArray.count;
    }
    if (section == 3) {
        return self.classKids.count;
    }
//    if (section == 4) {
//    }
//    if (section == 5) {
//        return 2;
//    }
    return 0;
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    if (indexPath.section == 0) {
        
        [self setupContentWithName:self.className cell:cell];
        
    }
    if (indexPath.section == 1) {
        [self setupContentWithName:self.classAge cell:cell];

    }
    if (indexPath.section == 2) {
        [self setupContentWithName:self.mainTeacherArray[indexPath.row] cell:cell];

    }
    if (indexPath.section == 3) {
        NSDictionary *kidDic = [self.classKids safeObjectAtIndex:indexPath.row];
        
        [self setupContentWithName:[kidDic safeObjectForKey:@"name"] cell:cell];
    }

//    if (indexPath.section == 5) {
        
//        NSDictionary *dic = [self.destArray safeObjectAtIndex:indexPath.row];
//        
//        HDestnationModel *destModel = [[HDestnationModel alloc]init];
//        destModel.name = [dic safeObjectForKey:@"name"];
//        destModel.distance = [dic safeObjectForKey:@"distance"];
//        destModel.img = [dic safeObjectForKey:@"image"];
//        
//        HMddView *mddView = [[HMddView alloc] init];
//        [mddView setupWithModel:destModel];
//        [cell.contentView addSubview:mddView];
//
//        [mddView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(cell.contentView);
//        }];
//
//        if (destModel.isSelected) {
//            [mddView cellSelected];
//        }else{
//            [mddView cellNomal];
//        }


//    }
    

    return cell;
}
- (void)setupContentWithName:(NSString *)name cell:(UICollectionViewCell *)cell
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = BWColor(0, 28, 41, 1);
    label.text = name;
    [cell.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView);
    }];
}

#pragma mark - UICollectionViewLayoutDelegate -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH/2 - PAdaptation_x(80), PAaptation_y(60));

    }
    if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH/2 - PAdaptation_x(80), PAaptation_y(36));

    }
    if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WIDTH/2 - PAdaptation_x(80), PAaptation_y(36));
    }
    if (indexPath.section == 3) {
        return CGSizeMake(SCREEN_WIDTH/2 - PAdaptation_x(80), PAaptation_y(36));
    }
    if (indexPath.section == 4) {
        return CGSizeMake(SCREEN_WIDTH/2 - PAdaptation_x(80), PAaptation_y(36));
    }
    return CGSizeMake(PAdaptation_x(170), PAaptation_y(76));
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
    if (section == 5) {
        return PAaptation_y(10);
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
    return CGSizeMake(SCREEN_WIDTH, PAaptation_y(40));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(23), PAaptation_y(10), PAdaptation_x(18));
    }
    if (section == 1) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(23), PAaptation_y(10), PAdaptation_x(10));
    }
    if (section == 2) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(23), PAaptation_y(10), PAdaptation_x(60));
    }
    if (section == 3) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(23), PAaptation_y(10), PAdaptation_x(60));
    }
    if (section == 4) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(23), PAaptation_y(10), PAdaptation_x(60));
    }

    return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(23), PAaptation_y(10), PAdaptation_x(10));

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
       
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(23), headerView.frame.size.height - PAaptation_y(30), SCREEN_WIDTH - PAdaptation_x(46), PAaptation_y(30))];
       label.font = [UIFont systemFontOfSize:14];
       label.textColor = BWColor(34, 34, 34, 1.0);
       label.text = [self.sectionArray safeObjectAtIndex:indexPath.section];
       [headerView addSubview:label];
       
       
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
        _collectionView.bounces = NO;
//        _collectionView.userInteractionEnabled = NO;
        //注册Cell，必须要有
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];//注册header的view

    }
    return _collectionView;
}



- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];

    }
    return _titleView;
}
- (UIImageView *)topView
{
    if (!_topView) {
        _topView = [[UIImageView alloc] init];
        [_topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    }
    return _topView;
    
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:32];
        _titleLabel.text = @"クラス情報";
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
@end
