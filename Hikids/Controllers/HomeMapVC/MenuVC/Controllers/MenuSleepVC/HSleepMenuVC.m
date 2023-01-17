//
//  HMenuSleepVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HSleepMenuVC.h"
#import "BWGetStudentReq.h"
#import "BWGetStudentResp.h"
#import "BWGetAssistantReq.h"
#import "BWGetAssistantResp.h"
#import "BWAddTaskReq.h"
#import "BWAddTaskResp.h"
#import "HTask.h"

#import "HStudent.h"
#import "HTitleView.h"
#import "HTeacher.h"
#import "HTime.h"
#import "HStudentView.h"

@interface HSleepMenuVC()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *startSleepBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *timeArray;       //选择时间集合
@property (nonatomic, strong) NSArray *teacherArray;     //老师集合
@property (nonatomic, strong) NSArray *studentArray;     //学生集合
@property (nonatomic, strong) UIView *selectView;       //选中展示view
@property (nonatomic, strong) NSMutableArray *selectTimeArray;
@property (nonatomic, strong) NSMutableArray *selectTeacherArray;
@property (nonatomic, strong) NSMutableArray *selectStudentArray;

@end

@implementation HSleepMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startStudentRequest];
    
}

- (void)startStudentRequest
{
    DefineWeakSelf;
    BWGetStudentReq *studentReq = [[BWGetStudentReq alloc] init];
    [NetManger getRequest:studentReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
        BWGetStudentResp *studentResp = (BWGetStudentResp *)resp;
        
        weakSelf.studentArray = studentResp.itemList;
            
        [weakSelf startTeacherRequest];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)startTeacherRequest
{
    DefineWeakSelf;
    BWGetAssistantReq *teacherReq = [[BWGetAssistantReq alloc] init];
    [NetManger getRequest:teacherReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetAssistantResp *teacherResp = (BWGetAssistantResp *)resp;
        
        weakSelf.teacherArray = teacherResp.itemList;
        
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
        make.top.equalTo(self.bgView).offset(-PAaptation_y(2));
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
    
    self.titleLabel.text = @"午睡モニタリング";
    
    self.dateLabel.text = [BWTools getNowTimeStringWithFormate:@"YYYY年M月d日"];
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(6));
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.titleView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.titleView.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(38));
    }];
    
    [self.titleView addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.titleView.mas_right);
        make.height.mas_equalTo(PAaptation_y(25));
        make.bottom.equalTo(self.titleView.mas_bottom);
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
    
    [self.footerView addSubview:self.startSleepBtn];
    [self.startSleepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UICollectionViewDataSource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.timeArray.count;
    }
    if (section == 1) {
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
    if (indexPath.section == 1) {
        
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
   
    if (indexPath.section == 2) {
        
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
        
        HTime *selectModel = [self.timeArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
            
            if ([self.selectTimeArray containsObject:selectModel]) {
                [self.selectTimeArray removeObject:selectModel];
            }
            
        }else{
            [self.timeArray enumerateObjectsUsingBlock:^(HTime * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.tId == obj.tId) {
                    obj.isSelected = YES;
                    [self.selectTimeArray addObject:selectModel];

                    return;
                }else{
                    obj.isSelected = NO;
                    [self.selectTimeArray removeObject:obj];

                }
            }];
        }
        
    }
    if (indexPath.section == 1) {
        
        HTeacher *selectModel = [self.teacherArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
            
            if ([self.selectTeacherArray containsObject:selectModel]) {
                [self.selectTeacherArray removeObject:selectModel];
            }
        }else{
            [self.teacherArray enumerateObjectsUsingBlock:^(HTeacher * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.tId.integerValue == obj.tId.integerValue) {
                    obj.isSelected = YES;
                    [self.selectTeacherArray addObject:selectModel];

                    return;
                }
            }];
        }
    }
    if (indexPath.section == 2) {
       
        HStudent *selectModel = [self.studentArray safeObjectAtIndex:indexPath.row];
        if (selectModel.isSelected) {
            selectModel.isSelected = NO;
            if ([self.selectStudentArray containsObject:selectModel]) {
                [self.selectStudentArray removeObject:selectModel];
            }
        }else{
            [self.studentArray enumerateObjectsUsingBlock:^(HStudent * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (selectModel.sId.integerValue == obj.sId.integerValue) {
                    obj.isSelected = YES;
                    [self.selectStudentArray addObject:selectModel];
                    return;
                }
            }];
        }
    }
    [self.collectionView reloadData];
    
    [self updateWalkBtnState];

}
#pragma mark - UICollectionViewLayoutDelegate -
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(PAdaptation_x(68), PAaptation_y(36));

    }
    if (indexPath.section == 1) {
        return CGSizeMake(PAdaptation_x(110), PAaptation_y(36));
    }
    return CGSizeMake(PAdaptation_x(170), PAaptation_y(54));
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
                    minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    if (section == 0) {
        return 0;

    }
    if (section == 1) {
        return 0;
    }
    return PAdaptation_x(10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
 
    if (section == 0) {
        return 0;

    }
    if (section == 1) {
        return 0;
    }
    return PAaptation_y(10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, PAaptation_y(30));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(18), PAaptation_y(10), PAdaptation_x(10));
    }
    if (section == 1) {
        return UIEdgeInsetsMake(PAaptation_y(10), PAdaptation_x(18), PAaptation_y(10), PAdaptation_x(30));
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
       
       UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PAdaptation_x(23), headerView.frame.size.height - PAaptation_y(30), SCREEN_WIDTH - PAdaptation_x(46), PAaptation_y(30))];
       label.font = [UIFont systemFontOfSize:14];
       label.textColor = BWColor(34, 34, 34, 1.0);
       [headerView addSubview:label];
       
       if(indexPath.section == 0){
           label.text = @"午睡予定時間:";
       }else if(indexPath.section == 1){
           label.text = @"確認者(複数選択可):";
       }else{
           label.text = @"参加児童:";
       }
       
       return headerView;
   }

   return nil;

}
- (void)updateWalkBtnState
{
    
    UILabel *timeLabel = (UILabel *)[self.view viewWithTag:10001];
    if (self.selectTimeArray.count != 0) {
        HTime *timeModel = [self.selectTimeArray safeObjectAtIndex:0];
        if (timeLabel == nil) {
            timeLabel = [[UILabel alloc] init];
            timeLabel.tag = 10001;
            timeLabel.font = [UIFont boldSystemFontOfSize:14];
            timeLabel.backgroundColor = BWColor(252, 229, 216, 1.0);
            timeLabel.layer.cornerRadius = 8;
            timeLabel.layer.masksToBounds = YES;
            [self.selectView addSubview:timeLabel];
        }
        timeLabel.text = [NSString stringWithFormat:@"   %@   ",timeModel.name];
        
        [timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectView);
            make.left.equalTo(self.selectView);
            make.height.mas_equalTo(PAaptation_y(24));

        }];
    }else{
        timeLabel.text = @"";

    }
    
    UILabel *teacherLabel = (UILabel *)[self.view viewWithTag:10002];
    if (self.selectTeacherArray.count != 0) {
        if (teacherLabel == nil) {
            teacherLabel = [[UILabel alloc] init];
            teacherLabel.tag = 10002;
            teacherLabel.font = [UIFont boldSystemFontOfSize:14];
            teacherLabel.backgroundColor = BWColor(252, 229, 216, 1.0);
            teacherLabel.layer.cornerRadius = 8;
            teacherLabel.layer.masksToBounds = YES;
            [self.selectView addSubview:teacherLabel];
        }
        teacherLabel.text = [NSString stringWithFormat:@"   先生%ld人   ",self.selectTeacherArray.count];
        
        [teacherLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectView);
            make.left.equalTo(timeLabel == nil ? self.selectView : timeLabel.mas_right).offset(PAdaptation_x(2));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
    }else{
        teacherLabel.text = @"";

    }
    
    UILabel *studentLabel = (UILabel *)[self.view viewWithTag:10003];
    if (self.selectStudentArray.count != 0) {
        if (studentLabel == nil) {
            studentLabel = [[UILabel alloc] init];
            studentLabel.tag = 10003;
            studentLabel.font = [UIFont boldSystemFontOfSize:14];
            studentLabel.backgroundColor = BWColor(252, 229, 216, 1.0);
            studentLabel.layer.cornerRadius = 8;
            studentLabel.layer.masksToBounds = YES;
            [self.selectView addSubview:studentLabel];
        }
        studentLabel.text = [NSString stringWithFormat:@"   児童%ld人   ",self.selectStudentArray.count];
        
        [studentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectView);
            make.left.equalTo(teacherLabel == nil ? self.selectView : teacherLabel.mas_right).offset(PAdaptation_x(2));
            make.height.mas_equalTo(PAaptation_y(24));

        }];
    }else{
        studentLabel.text = @"";

    }
    
    
    if ( self.selectTimeArray.count != 0 && self.selectTeacherArray.count != 0 && self.selectStudentArray.count != 0) {
        self.startSleepBtn.enabled = YES;
        [self.startSleepBtn setImage:[UIImage imageNamed:@"btn_napStart.png"] forState:UIControlStateNormal];
    }else{
        self.startSleepBtn.enabled = NO;
        [self.startSleepBtn setImage:[UIImage imageNamed:@"start_btn.png"] forState:UIControlStateNormal];
    }
}

- (void)startSleepAction:(UIButton *)button
{
    NSString *type = @"2";
    NSString *planTime;
    NSString *remark = @"";

    HTime *timeModel = [self.selectTimeArray safeObjectAtIndex:0];
    if ([timeModel.name isEqualToString:@"自由"]) {
        planTime = @"999";
    }else{
        planTime = timeModel.name;
    }

    NSMutableArray *assistantsArray = [[NSMutableArray alloc] init];
    for (HTeacher *teacher in self.selectTeacherArray) {
        NSDictionary *dic = @{@"id":teacher.tId,@"name":teacher.name};
        [assistantsArray addObject:dic];
    }

    NSMutableArray *kidsArray = [[NSMutableArray alloc] init];
    for (HStudent *student in self.selectStudentArray) {
        NSDictionary *dic = @{@"id":student.sId,@"name":student.name};
        [kidsArray addObject:dic];
    }


    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DefineWeakSelf;
    BWAddTaskReq *taskReq = [[BWAddTaskReq alloc] init];
    taskReq.type = type;
    taskReq.planTime = planTime;
    taskReq.assistants = assistantsArray;
    taskReq.kids = kidsArray;
    taskReq.remark = remark;
    [NetManger postRequest:taskReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BWAddTaskResp *addResp = (BWAddTaskResp *)resp;
        HTask *taskModel = [addResp.itemList safeObjectAtIndex:0];

        [weakSelf backAction:nil];

        if (weakSelf.startSleepBlock) {
            weakSelf.startSleepBlock(taskModel);
        }


    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];

    }];


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

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
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
- (UIView *)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc] init];
        _selectView.backgroundColor = [UIColor whiteColor];

    }
    return _selectView;
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
        _dateLabel.font = [UIFont boldSystemFontOfSize:14];
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
- (UIButton *)startSleepBtn
{
    if (!_startSleepBtn) {
        _startSleepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startSleepBtn.enabled = NO;
        [_startSleepBtn setImage:[UIImage imageNamed:@"start_btn.png"] forState:UIControlStateNormal];
        [_startSleepBtn addTarget:self action:@selector(startSleepAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startSleepBtn;
}

- (NSMutableArray *)selectTimeArray
{
    if (!_selectTimeArray) {
        _selectTimeArray = [[NSMutableArray alloc] init];
    }
    return _selectTimeArray;
}
- (NSMutableArray *)selectTeacherArray
{
    if (!_selectTeacherArray) {
        _selectTeacherArray = [[NSMutableArray alloc] init];
    }
    return _selectTeacherArray;
}
- (NSMutableArray *)selectStudentArray
{
    if (!_selectStudentArray) {
        _selectStudentArray = [[NSMutableArray alloc] init];
    }
    return _selectStudentArray;
}



@end
