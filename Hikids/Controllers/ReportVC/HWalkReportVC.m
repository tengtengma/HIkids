//
//  HWalkReportVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/5.
//

#import "HWalkReportVC.h"
#import "HStudentStateTopView.h"
#import "HStudentStateBottomView.h"
#import "HStudentFooterView.h"
#import "HTask.h"

#import "BWGetWalkReportReq.h"
#import "BWGetWalkReportResp.h"
#import "HWalkReport.h"

@interface HWalkReportVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeDesLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *destDesLabel;
@property (nonatomic, strong) UILabel *destLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *destImageView;
@property (nonatomic, strong) UILabel *groupDesLabel;
@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) UILabel *teacherDesLabel;
@property (nonatomic, strong) UILabel *genderLabel;
@property (nonatomic, strong) UILabel *teacherNumLabel;
@property (nonatomic, strong) UILabel *studentDesLabel;
@property (nonatomic, strong) UILabel *studentNumLabel;
@property (nonatomic, strong) UILabel *dangerLabel;
@property (nonatomic, strong) NSArray *teacherList;
@property (nonatomic, strong) NSArray *studentList;
@property (nonatomic, strong) NSArray *dangerList;
@property (nonatomic, strong) UIButton *printBtn;
@property (nonatomic, strong) UIImageView *imageBgView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) HWalkReport *walkReport;

@end

@implementation HWalkReportVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.closeWalkReportBlock) {
        self.closeWalkReportBlock();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startRequest];
    
}
- (void)startRequest
{
    DefineWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BWGetWalkReportReq *req = [[BWGetWalkReportReq alloc] init];
    req.taskId = self.taskId;
    [NetManger getRequest:req withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BWGetWalkReportResp *walkResp = (BWGetWalkReportResp *)resp;
        weakSelf.walkReport = [walkResp.itemList safeObjectAtIndex:0];
        [weakSelf createUI];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)createUI
{
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self contentView];
    

}
- (void)createTitleView
{
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(68));
    }];
    
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(_titleView).offset(PAdaptation_x(24));
    }];
    
    [self.titleView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView);
        make.right.equalTo(self.titleView.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(38));
    }];
    
}
- (void)contentView
{
    [self.view addSubview:self.scrollView];

    if ([self.source isEqualToString:@"1"]) {
        
        [self createDateView];
        
        
        [self.scrollView addSubview:self.destDesLabel];
        [self.destDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageBgView.mas_bottom).offset(PAaptation_y(24));
            make.left.equalTo(self.view).offset(PAdaptation_x(25));
        }];
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + PAaptation_y(480) + PAaptation_y(78)*self.walkReport.unnormalList.count);

        
    }else{
        [self.scrollView addSubview:self.timeDesLabel];
        [self.timeDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView).offset(PAdaptation_x(25));
        }];
        NSArray *dateList = [self.walkReport.dateTime componentsSeparatedByString:@"-"];
        self.yearLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",dateList[0],dateList[1],dateList[2]];
        [self.scrollView addSubview:self.yearLabel];
        [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeDesLabel.mas_bottom).offset(PAaptation_y(6));
            make.left.equalTo(self.timeDesLabel);
        }];
        
        self.timeLabel.text = [NSString stringWithFormat:@"%@~%@",self.walkReport.startTime,self.walkReport.endTime];
        [self.scrollView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.yearLabel.mas_bottom);
            make.left.equalTo(self.yearLabel);
        }];
        
        [self.scrollView addSubview:self.destDesLabel];
        [self.destDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeLabel.mas_bottom).offset(PAaptation_y(16));
            make.left.equalTo(self.timeLabel);
        }];
        
        [self.scrollView addSubview:self.rightImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView);
            make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(15));
            make.width.mas_equalTo(PAdaptation_x(50));
            make.height.mas_equalTo(PAaptation_y(50));
        }];
        
        
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + PAaptation_y(180) + PAaptation_y(78)*self.walkReport.unnormalList.count);

    }

    self.destLabel.text = self.walkReport.address;
    [self.scrollView addSubview:self.destLabel];
    [self.destLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destDesLabel.mas_bottom).offset(PAaptation_y(6));
        make.left.equalTo(self.destDesLabel);
        make.width.mas_equalTo(PAdaptation_x(112));
    }];
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%@m",self.walkReport.distance];
    [self.scrollView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destLabel.mas_bottom).offset(PAaptation_y(2));
        make.left.equalTo(self.destDesLabel);
    }];
    
    [self.scrollView addSubview:self.destImageView];
    [self.destImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destDesLabel.mas_bottom).offset(PAaptation_y(5));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(25));
        make.width.mas_equalTo(PAdaptation_x(120));
        make.height.mas_equalTo(PAaptation_y(120));
    }];
    
    [self.scrollView addSubview:self.groupDesLabel];
    [self.groupDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.destDesLabel);
    }];
    
    self.groupLabel.text = self.walkReport.className;
    [self.scrollView addSubview:self.groupLabel];
    [self.groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupDesLabel.mas_bottom);
        make.left.equalTo(self.groupDesLabel);
    }];
    
    [self.scrollView addSubview:self.teacherDesLabel];
    [self.teacherDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.groupLabel.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.groupDesLabel);
    }];
    
    [self.scrollView addSubview:self.genderLabel];
    [self.genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherDesLabel.mas_bottom).offset(PAaptation_y(32));
        make.left.equalTo(self.teacherDesLabel);
    }];
    
    self.teacherNumLabel.text = [NSString stringWithFormat:@"%@人",self.walkReport.teacherCount];
    [self.scrollView addSubview:self.teacherNumLabel];
    [self.teacherNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.genderLabel.mas_bottom);
        make.left.equalTo(self.genderLabel.mas_right).offset(PAdaptation_x(10));
    }];
    
    NSArray *teacherList = self.walkReport.teachersList;
    
    UILabel *tempTeacherNameLabel;
    for (NSInteger i = 0; i < teacherList.count; i++) {
        
        NSDictionary *dic = [teacherList safeObjectAtIndex:i];
        
        UILabel *teacherNameLabel = [[UILabel alloc] init];
        teacherNameLabel.font = [UIFont boldSystemFontOfSize:20];
        teacherNameLabel.textColor = BWColor(0, 28, 41, 1);
        teacherNameLabel.text = [dic safeObjectForKey:@"name"];
        [self.scrollView addSubview:teacherNameLabel];
        
        [teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(self.teacherNumLabel.mas_bottom).offset(PAaptation_y(12));
            }else{
                make.top.equalTo(tempTeacherNameLabel.mas_bottom).offset(PAaptation_y(6));
            }
            make.left.equalTo(self.teacherDesLabel);
        }];
        
        tempTeacherNameLabel = teacherNameLabel;
        
        if (i == 0) {
            UILabel *mainNameLabel = [[UILabel alloc] init];
            mainNameLabel.text = @"責任者";
            mainNameLabel.textColor = [UIColor whiteColor];
            mainNameLabel.backgroundColor = BWColor(108, 159, 155, 1);
            mainNameLabel.font = [UIFont systemFontOfSize:10];
            mainNameLabel.textAlignment = NSTextAlignmentCenter;
            [self.scrollView addSubview:mainNameLabel];
            
            [mainNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(teacherNameLabel);
                make.left.equalTo(teacherNameLabel.mas_right).offset(PAdaptation_x(20));
            }];
        }
        
    }
    
    [self.scrollView addSubview:self.studentDesLabel];
    [self.studentDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherDesLabel.mas_bottom).offset(PAaptation_y(32));
        make.left.equalTo(self.view).offset(PAdaptation_x(195));
    }];
    
    self.studentNumLabel.text = [NSString stringWithFormat:@"%ld人",(long)self.walkReport.studentCount];
    [self.scrollView addSubview:self.studentNumLabel];
    [self.studentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.studentDesLabel.mas_bottom);
        make.left.equalTo(self.studentDesLabel.mas_right).offset(PAdaptation_x(10));
    }];
    
    NSArray *studentList = self.walkReport.studentList;
    
    UIView *tempStudentHeaderView;
    for (NSInteger i = 0; i < studentList.count; i++) {
        
        NSDictionary *studentDic = [studentList safeObjectAtIndex:i];
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView = [[UIImageView alloc] init];
        headerImageView.layer.borderWidth = 2;
        headerImageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
        headerImageView.layer.cornerRadius = PAaptation_y(40)/2;
        headerImageView.layer.masksToBounds = YES;
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:[studentDic safeObjectForKey:@"avatar"]]];
        [self.scrollView addSubview:headerImageView];
        
        [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(self.studentNumLabel.mas_bottom).offset(PAaptation_y(12));
            }else{
                make.top.equalTo(tempStudentHeaderView.mas_bottom).offset(PAaptation_y(6));
            }
            make.left.equalTo(self.studentDesLabel);
            make.width.mas_equalTo(PAdaptation_x(40));
            make.height.mas_equalTo(PAaptation_y(40));
        }];
        
        UILabel *studentNameLabel = [[UILabel alloc] init];
        studentNameLabel.font = [UIFont systemFontOfSize:20];
        studentNameLabel.textColor = BWColor(0, 28, 41, 1);
        studentNameLabel.text = [studentDic safeObjectForKey:@"name"];
        [self.scrollView addSubview:studentNameLabel];
        
        [studentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView);
            make.left.equalTo(headerImageView.mas_right).offset(PAdaptation_x(8));
        }];
        
        tempStudentHeaderView = headerImageView;
        
    }
    
    if (self.walkReport.unnormalList.count != 0) {
        
        [self.scrollView addSubview:self.dangerLabel];
        [self.dangerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tempStudentHeaderView.mas_bottom).offset(PAaptation_y(26));
            make.left.equalTo(self.teacherDesLabel);
        }];
        
        
        HStudentStateTopView *dangerTopView = [[HStudentStateTopView alloc] init];
        dangerTopView.type = TYPE_WALK;
        dangerTopView.studentList = @[];
        dangerTopView.expandBtn.hidden = YES;
        dangerTopView.dangerTimeLabel.hidden = NO;
        [dangerTopView loadDangerStyle];
        [self.scrollView addSubview:dangerTopView];
        
        [dangerTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dangerLabel.mas_bottom);
            make.left.equalTo(self.dangerLabel);
            make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(47));
        }];

        UIView *tempFootView = nil;
        for (NSInteger i = 0; i < 3; i++) {
            HStudent *student = [[HStudent alloc] init];
            student.name = @"adfasdf";
            student.exceptionTime = @"123";
            student.avatar = @"https://yunpengmall.oss-cn-beijing.aliyuncs.com/1560875015170428928/material/19181666430944_.pic.jpg";
            
            HStudentFooterView *footerView = [[HStudentFooterView alloc] init];
            footerView.type = FootTYPE_WALK;
            [footerView setupWithModel:student];
            [footerView loadDangerStyle];
            if (i == 2) {
                [footerView setLastCellBorder];
            }else{
                [footerView setNomalBorder];
            }
            [self.scrollView addSubview:footerView];
            
            [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.equalTo(dangerTopView.mas_bottom);
                    make.left.equalTo(dangerTopView);
                    make.right.equalTo(dangerTopView.mas_right);
                    make.height.mas_equalTo(PAaptation_y(78));
                }else{
                    make.top.equalTo(tempFootView.mas_bottom);
                    make.left.equalTo(dangerTopView);
                    make.right.equalTo(dangerTopView.mas_right);
                    make.height.mas_equalTo(PAaptation_y(78));
                }

            }];
            
            tempFootView = footerView;
        }
    }
   
}
- (void)createDateView
{
    if (self.walkReport.unnormalList.count == 0) {
        [self.imageBgView setImage:[UIImage imageNamed:@"greenBg.png"]];
    }else{
        [self.imageBgView setImage:[UIImage imageNamed:@"yellowBg.png"]];
    }
    [self.scrollView addSubview:self.imageBgView];
    [self.imageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.view).offset(PAdaptation_x(15));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(15));
        make.height.mas_equalTo(PAaptation_y(350));
    }];
    
    NSArray *dateList = [self.walkReport.dateTime componentsSeparatedByString:@"-"];
    
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",dateList[0],dateList[1],dateList[2]];
    yearLabel.textColor = [UIColor whiteColor];
    yearLabel.font = [UIFont systemFontOfSize:20];
    [self.imageBgView addSubview:yearLabel];
    
    [yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageBgView).offset(PAaptation_y(14));
        make.left.equalTo(self.imageBgView).offset(PAdaptation_x(14));
    }];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = [NSString stringWithFormat:@"%@~%@",self.walkReport.startTime,self.walkReport.endTime];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont boldSystemFontOfSize:32];
    [self.imageBgView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yearLabel.mas_bottom);
        make.left.equalTo(yearLabel);
    }];
    
    [self.imageBgView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageBgView).offset(PAaptation_y(35));
        make.right.equalTo(self.imageBgView.mas_right).offset(-PAdaptation_x(25));
        make.width.mas_equalTo(PAdaptation_x(50));
        make.height.mas_equalTo(PAaptation_y(50));
    }];
    
    UIImageView *duigouView = [[UIImageView alloc] init];
    [duigouView setImage:[UIImage imageNamed:@"ol_96_color.png"]];
    [self.imageBgView addSubview:duigouView];
    
    [duigouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLabel.mas_bottom).offset(PAaptation_y(30));
        make.centerX.equalTo(self.imageBgView);
        make.width.mas_equalTo(PAdaptation_x(78));
        make.height.mas_equalTo(PAaptation_y(78));
    }];
    
    UILabel *locationDesLabel = [[UILabel alloc] init];
    locationDesLabel.text = self.walkReport.address;
    locationDesLabel.textColor = [UIColor whiteColor];
    locationDesLabel.font = [UIFont boldSystemFontOfSize:20];
    locationDesLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageBgView addSubview:locationDesLabel];
    
    [locationDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(duigouView.mas_bottom);
        make.left.equalTo(self.imageBgView).offset(PAdaptation_x(25));
        make.right.equalTo(self.imageBgView.mas_right).offset(-PAdaptation_x(25));
    }];
    
    UIImageView *locationView = [[UIImageView alloc] init];
    [locationView setImage:[UIImage imageNamed:@"location_report.png"]];
    [self.imageBgView addSubview:locationView];
    
    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationDesLabel.mas_bottom);
        make.left.equalTo(self.imageBgView).offset(PAdaptation_x(124));
        make.width.mas_equalTo(PAdaptation_x(20));
        make.height.mas_equalTo(PAaptation_y(20));
    }];
    
    UILabel *mddDesLabel = [[UILabel alloc] init];
    mddDesLabel.text = self.walkReport.address;
    mddDesLabel.textColor = [UIColor whiteColor];
    mddDesLabel.font = [UIFont systemFontOfSize:16];
    mddDesLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageBgView addSubview:mddDesLabel];
    
    [mddDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(locationView);
        make.left.equalTo(locationView.mas_right).offset(PAdaptation_x(12));
    }];
    
    UILabel *teacherDesLabel = [[UILabel alloc] init];
    teacherDesLabel.text = @"先生";
    teacherDesLabel.textColor = [UIColor whiteColor];
    teacherDesLabel.font = [UIFont systemFontOfSize:14];
    [self.imageBgView addSubview:teacherDesLabel];
    
    [teacherDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mddDesLabel.mas_bottom).offset(PAaptation_y(34));
        make.left.equalTo(self.imageBgView).offset(PAdaptation_x(45));
    }];
    
    UILabel *teacherLabel = [[UILabel alloc] init];
    teacherLabel.text = [NSString stringWithFormat:@"%@人",self.walkReport.teacherCount];
    teacherLabel.textColor = [UIColor whiteColor];
    teacherLabel.font = [UIFont systemFontOfSize:32];
    [self.imageBgView addSubview:teacherLabel];
    
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teacherDesLabel.mas_bottom);
        make.centerX.equalTo(teacherDesLabel);
    }];
    
    UILabel *studentDesLabel = [[UILabel alloc] init];
    studentDesLabel.text = @"子供";
    studentDesLabel.textColor = [UIColor whiteColor];
    studentDesLabel.font = [UIFont systemFontOfSize:14];
    [self.imageBgView addSubview:studentDesLabel];
    
    [studentDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mddDesLabel.mas_bottom).offset(PAaptation_y(34));
        make.centerX.equalTo(self.imageBgView);
    }];
    
    UILabel *studentLabel = [[UILabel alloc] init];
    studentLabel.text = [NSString stringWithFormat:@"%ld人",(long)self.walkReport.studentCount];
    studentLabel.textColor = [UIColor whiteColor];
    studentLabel.font = [UIFont systemFontOfSize:32];
    [self.imageBgView addSubview:studentLabel];
    
    [studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(studentDesLabel.mas_bottom);
        make.centerX.equalTo(studentDesLabel);
    }];
    
    UILabel *alertDesLabel = [[UILabel alloc] init];
    alertDesLabel.text = @"アラート";
    alertDesLabel.textColor = [UIColor whiteColor];
    alertDesLabel.font = [UIFont systemFontOfSize:14];
    [self.imageBgView addSubview:alertDesLabel];
    
    [alertDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mddDesLabel.mas_bottom).offset(PAaptation_y(34));
        make.right.equalTo(self.imageBgView.mas_right).offset(-PAdaptation_x(45));
    }];
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.text = [NSString stringWithFormat:@"%@回",self.walkReport.travelCount];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.font = [UIFont systemFontOfSize:32];
    [self.imageBgView addSubview:alertLabel];
    
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertDesLabel.mas_bottom);
        make.centerX.equalTo(alertDesLabel);
    }];
    
    
}
- (void)backAction:(id)sender
{
//    DefineWeakSelf;
    [self dismissViewControllerAnimated:YES completion:^{
//        if (weakSelf.closeWalkReportBlock) {
//            weakSelf.closeWalkReportBlock();
//        }
    }];

}
#pragma mark - LazyLoad -
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, PAaptation_y(100), SCREEN_WIDTH, SCREEN_HEIGHT-PAaptation_y(100))];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
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
        _titleLabel.text = @"散歩レポート";
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
- (UILabel *)timeDesLabel
{
    if (!_timeDesLabel) {
        _timeDesLabel = [[UILabel alloc] init];
        _timeDesLabel.font = [UIFont systemFontOfSize:14.0];
        _timeDesLabel.text = @"散歩時間：";
        _timeDesLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _timeDesLabel;
}
- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont boldSystemFontOfSize:20.0];
        
//        NSString *year = [dateArray safeObjectAtIndex:0];
//        NSArray *tempArray = [year componentsSeparatedByString:@"-"];
//        NSString *y = [tempArray safeObjectAtIndex:0];
//        NSString *m = [tempArray safeObjectAtIndex:1];
//        NSString *d = [tempArray safeObjectAtIndex:2];
//        _yearLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",y,m,d];
    }
    return _yearLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:32.0];
    }
    return _timeLabel;
}
- (UILabel *)destDesLabel
{
    if (!_destDesLabel) {
        _destDesLabel = [[UILabel alloc] init];
        _destDesLabel.font = [UIFont systemFontOfSize:14.0];
        _destDesLabel.text = @"目的地・経路：";
        _destDesLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _destDesLabel;
}
- (UILabel *)destLabel
{
    if (!_destLabel) {
        _destLabel = [[UILabel alloc] init];
        _destLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _destLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _destLabel.numberOfLines = 0;
    }
    return _destLabel;
}
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.textColor = BWColor(0, 176, 107, 1);
        _distanceLabel.font = [UIFont boldSystemFontOfSize:32.0];
    }
    return _distanceLabel;
}
- (UIImageView *)destImageView
{
    if (!_destImageView) {
        _destImageView = [[UIImageView alloc] init];
        _destImageView.layer.cornerRadius = 8;
        _destImageView.layer.borderWidth = 2;
        _destImageView.layer.masksToBounds = YES;
        [_destImageView setImage:[UIImage imageNamed:@"dest0.jpeg"]];
    }
    return _destImageView;
}
- (UILabel *)groupDesLabel
{
    if (!_groupDesLabel) {
        _groupDesLabel = [[UILabel alloc] init];
        _groupDesLabel.font = [UIFont systemFontOfSize:14.0];
        _groupDesLabel.text = @"クラス：";
        _groupDesLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _groupDesLabel;
}
- (UILabel *)groupLabel
{
    if (!_groupLabel) {
        _groupLabel = [[UILabel alloc] init];
        _groupLabel.font = [UIFont boldSystemFontOfSize:32.0];
    }
    return _groupLabel;
}
- (UILabel *)teacherDesLabel
{
    if (!_teacherDesLabel) {
        _teacherDesLabel = [[UILabel alloc] init];
        _teacherDesLabel.font = [UIFont systemFontOfSize:14.0];
        _teacherDesLabel.text = @"人員：";
        _teacherDesLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _teacherDesLabel;
}
- (UILabel *)genderLabel
{
    if (!_genderLabel) {
        _genderLabel = [[UILabel alloc] init];
        _genderLabel.font = [UIFont systemFontOfSize:14.0];
        _genderLabel.text = @"先生：";
        _genderLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _genderLabel;
}
- (UILabel *)teacherNumLabel
{
    if (!_teacherNumLabel) {
        _teacherNumLabel = [[UILabel alloc] init];
        _teacherNumLabel.font = [UIFont boldSystemFontOfSize:32.0];
        _teacherNumLabel.textColor = BWColor(108, 159, 155, 1);

    }
    return _teacherNumLabel;
}
- (UILabel *)studentDesLabel
{
    if (!_studentDesLabel) {
        _studentDesLabel = [[UILabel alloc] init];
        _studentDesLabel.font = [UIFont systemFontOfSize:14.0];
        _studentDesLabel.text = @"子供：";
        _studentDesLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _studentDesLabel;
}
- (UILabel *)studentNumLabel
{
    if (!_studentNumLabel) {
        _studentNumLabel = [[UILabel alloc] init];
        _studentNumLabel.font = [UIFont boldSystemFontOfSize:32.0];
        _studentNumLabel.textColor = BWColor(108, 159, 155, 1);

    }
    return _studentNumLabel;
}
- (UILabel *)dangerLabel
{
    if (!_dangerLabel) {
        _dangerLabel = [[UILabel alloc] init];
        _dangerLabel.font = [UIFont systemFontOfSize:14.0];
        _dangerLabel.text = @"アラート履歴：";
        _dangerLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _dangerLabel;
}
- (UIButton *)printBtn
{
    if (!_printBtn) {
        _printBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_printBtn setImage:[UIImage imageNamed:@"print.png"] forState:UIControlStateNormal];
    }
    return _printBtn;
}
- (UIImageView *)imageBgView
{
    if (!_imageBgView) {
        _imageBgView = [[UIImageView alloc] init];
    }
    return _imageBgView;
}
- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        [_rightImageView setImage:[UIImage imageNamed:@"walk.png"]];
    }
    return _rightImageView;
}
@end
