//
//  HInfomationVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HInfomationVC.h"
#import "HDestnationModel.h"
#import "HMddView.h"

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
@property (nonatomic, strong) NSArray *kidsArray;
@property (nonatomic, strong) NSArray *destArray;

@end

@implementation HInfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.sectionArray = @[@"クラス：",@"年齢：",@"担任先生：",@"先生：",@"子供：",@"散歩目的地："];
    
    self.mainTeacherArray = @[@"柴山 志帆",@"前田 慈子"];
    
    self.teacherArray = @[@"岩越 宏美",@"笹川 幸枝",@"上出 孝子",@"井本 美加子"];
    
    self.kidsArray = @[@"鈴木 和久",@"加藤 幸一",@"和田 浩",@"山本 義弘",@"三好 聡",@"鈴木 真平",@"藤村 健一",@"吉川 光",@"山本 隆",@"山村 武",@"鈴木 武明",@"竹中 靖",@"須藤 宏",@"大石 修二",@"山岸 慶太",@"石橋 伸治",@"小林 尊之",@"中川 貴哉",@"落合 武彦",@"江口 幸彦",@"星野 勝博",@"津田 博章",@"本橋 弘幸",@"大沢 真一郎",@"佐々木 裕希",@"福田 七重",@"早川 千紘",@"馬渕 真由美",@"上田 絢",@"益田 理恵",@"小堀 あゆみ",@"杉田 早苗",@"吉田 由真",@"森 有希",@"市村 香織"];
    
    self.destArray = @[@{@"name":@"東山動植物園",@"distance":@"0.9",@"image":[UIImage imageNamed:@"dest0.jpeg"]},@{@"name":@"植園公園",@"distance":@"1.2",@"image":[UIImage imageNamed:@"dest1.jpeg"]}];
    
    
    [self createUI];
}
- (void)createUI
{
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bgView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self createTableView];
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
        return self.teacherArray.count;
    }
    if (section == 4) {
        return self.kidsArray.count;
    }
    if (section == 5) {
        return 2;
    }
    return 0;
    
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    
    
    if (indexPath.section == 5) {
        
        NSDictionary *dic = [self.destArray safeObjectAtIndex:indexPath.row];
        
        HDestnationModel *destModel = [[HDestnationModel alloc]init];
        destModel.name = [dic safeObjectForKey:@"name"];
        destModel.distance = [dic safeObjectForKey:@"distance"];
        destModel.img = [dic safeObjectForKey:@"image"];
        
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


    }else{
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textColor = BWColor(0, 28, 41, 1);
        label.text = [self.kidsArray safeObjectAtIndex:indexPath.row];
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView);
        }];
    }
        
    

    return cell;
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

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
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
