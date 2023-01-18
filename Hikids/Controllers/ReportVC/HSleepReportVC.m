//
//  HSleepReportVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/4.
//

#import "HSleepReportVC.h"
#import "HStudentStateTopView.h"
#import "HStudentStateBottomView.h"
#import "HStudentFooterView.h"
#import "HReportInfo.h"
#import "BWGetSleepReportReq.h"
#import "BWGetSleepReportResp.h"
#import "BWGetPDFReq.h"
#import "BWGetPDFResp.h"

@interface HSleepReportVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeDesLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *timeLabel;
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
@property (nonatomic, strong) HReportInfo *reportInfo;


@end

@implementation HSleepReportVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.closeSleepReportBlock) {
        self.closeSleepReportBlock();
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
    BWGetSleepReportReq *req = [[BWGetSleepReportReq alloc] init];
    req.taskId = self.taskId;
    [NetManger getRequest:req withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        BWGetSleepReportResp *sleepResp = (BWGetSleepReportResp *)resp;
        weakSelf.reportInfo = [sleepResp.itemList safeObjectAtIndex:0];
        [weakSelf createUI];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)createUI
{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(-PAaptation_y(2));
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self contentView];
    

}
- (void)createTitleView
{
    [self.scrollView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
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
    [self.scrollView addSubview:self.timeDesLabel];
    [self.timeDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.titleView).offset(PAdaptation_x(25));
    }];
    
    [self.scrollView addSubview:self.yearLabel];
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeDesLabel.mas_bottom).offset(PAaptation_y(6));
        make.left.equalTo(self.timeDesLabel);
    }];
    
    [self.scrollView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yearLabel);
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(25));
        make.width.mas_equalTo(PAdaptation_x(50));
        make.height.mas_equalTo(PAaptation_y(50));
    }];
    
    [self.scrollView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yearLabel.mas_bottom);
        make.left.equalTo(self.yearLabel);
    }];
    
    [self.scrollView addSubview:self.groupDesLabel];
    [self.groupDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.timeLabel);
    }];
    
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
    
    [self.scrollView addSubview:self.teacherNumLabel];
    [self.teacherNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.genderLabel.mas_bottom);
        make.left.equalTo(self.genderLabel.mas_right).offset(PAdaptation_x(10));
    }];
    
    
    NSArray *teacherList = self.reportInfo.assistantList;
    NSArray *kidsList = self.reportInfo.kidsList;
    NSArray *unnormalList = self.reportInfo.unnormalList;
    
    
    CGFloat height = PAaptation_y(360);
    CGFloat width = SCREEN_WIDTH/2 - PAdaptation_x(48);
    CGFloat LeftPadding = PAdaptation_x(24);
    CGFloat Ypadding = PAdaptation_x(10);
    UIView *bgView;
    UIView *tempTeacherNameLabel = nil;
    for (NSInteger i = 0; i < teacherList.count; i++) {
        
        NSDictionary *teacherDic = [teacherList safeObjectAtIndex:i];

        NSInteger rowNum = i / 2; //每行2个
        NSInteger colNum = i % 2; //行数
        
        
        CGFloat imageX = colNum * width + LeftPadding;
        CGFloat imageY = rowNum * (PAaptation_y(30) + Ypadding);
        CGRect frame = CGRectMake(imageX,height+ imageY, width, PAaptation_y(30));
        
        
        bgView = [[UIView alloc] initWithFrame:frame];
        [self.scrollView addSubview:bgView];
        
        UILabel *teacherNameLabel = [[UILabel alloc] init];
        teacherNameLabel.font = [UIFont boldSystemFontOfSize:20];
        teacherNameLabel.textColor = BWColor(0, 28, 41, 1);
        teacherNameLabel.text = [teacherDic safeObjectForKey:@"name"];
        [bgView addSubview:teacherNameLabel];
        
        [teacherNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView);
        }];
        
        
        if (i == 0) {
            UILabel *mainNameLabel = [[UILabel alloc] init];
            mainNameLabel.text = @"責任者";
            mainNameLabel.textColor = [UIColor whiteColor];
            mainNameLabel.backgroundColor = BWColor(108, 159, 155, 1);
            mainNameLabel.font = [UIFont systemFontOfSize:10];
            mainNameLabel.textAlignment = NSTextAlignmentCenter;
            mainNameLabel.layer.cornerRadius = 4;
            mainNameLabel.layer.masksToBounds = YES;
            [teacherNameLabel addSubview:mainNameLabel];
            
            [mainNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(bgView);
                make.left.equalTo(teacherNameLabel.mas_right).offset(PAdaptation_x(5));
                make.width.mas_equalTo(PAdaptation_x(50));
                make.height.mas_equalTo(PAaptation_y(17));
            }];
        }
        tempTeacherNameLabel = teacherNameLabel;
    }
    
    [self.scrollView addSubview:self.studentDesLabel];
    [self.studentDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tempTeacherNameLabel.mas_bottom).offset(PAaptation_y(44));
        make.left.equalTo(self.teacherDesLabel);
    }];
    
    [self.scrollView addSubview:self.studentNumLabel];
    [self.studentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.studentDesLabel.mas_bottom);
        make.left.equalTo(self.studentDesLabel.mas_right).offset(PAdaptation_x(10));
    }];
    

    height = CGRectGetMaxY(bgView.frame)+PAaptation_y(74);
    width = SCREEN_WIDTH/2 - PAdaptation_x(48);
    LeftPadding = PAdaptation_x(24);
    Ypadding = PAdaptation_x(10);
    
    UIView *tempStudentNameLabel = nil;
//    UILabel *studentNameLabel = nil;
    for (NSInteger i = 0; i < kidsList.count; i++) {
        
        NSInteger rowNum = i / 2; //每行2个
        NSInteger colNum = i % 2; //行数
                
        NSDictionary *studentDic = [kidsList safeObjectAtIndex:i];
        
        CGFloat imageX = colNum * width + LeftPadding;
        CGFloat imageY = rowNum * (PAaptation_y(30) + Ypadding);
        CGRect frame = CGRectMake(imageX,height+ imageY, width, PAaptation_y(30));
        
        UILabel *studentNameLabel = [[UILabel alloc] initWithFrame:frame];
        studentNameLabel.font = [UIFont boldSystemFontOfSize:20];
        studentNameLabel.textColor = BWColor(0, 28, 41, 1);
        studentNameLabel.text = [studentDic safeObjectForKey:@"name"];
        [self.scrollView addSubview:studentNameLabel];
            
        tempStudentNameLabel = studentNameLabel;
        
    }
    
    UIView *tempFootView = nil;

    if (unnormalList.count != 0) {

        [self.scrollView addSubview:self.dangerLabel];
        [self.dangerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tempStudentNameLabel.mas_bottom).offset(PAaptation_y(26));
            make.left.equalTo(self.teacherDesLabel);
        }];


        for (NSInteger i = 0; i < unnormalList.count; i++) {

            NSDictionary *unnormalDic = [unnormalList safeObjectAtIndex:i];

            HStudentStateTopView *dangerTopView = [[HStudentStateTopView alloc] init];
            dangerTopView.type = TYPE_SLEEP;
            dangerTopView.studentList = unnormalList;
            dangerTopView.expandBtn.hidden = YES;
            dangerTopView.numberBg.hidden = YES;
            dangerTopView.numberLabel.hidden = YES;
            dangerTopView.dangerTimeLabel.text = [unnormalDic safeObjectForKey:@"create_time"];
            [dangerTopView loadDangerStyle];
            [self.scrollView addSubview:dangerTopView];

            [dangerTopView mas_makeConstraints:^(MASConstraintMaker *make) {

                if (i == 0) {
                    make.top.equalTo(self.dangerLabel.mas_bottom).offset(PAaptation_y(10));
                }else{
                    make.top.equalTo(tempFootView.mas_bottom).offset(PAaptation_y(10));
                }
                make.left.equalTo(self.dangerLabel);
                make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(24));
                make.height.mas_equalTo(PAaptation_y(47));
            }];

            HStudent *student = [[HStudent alloc] init];
            student.name = [unnormalDic safeObjectForKey:@"name"];
//            student.avatar = [unnormalDic safeObjectForKey:@"avatar"];
            student.avatar = @"https://yunpengmall.oss-cn-beijing.aliyuncs.com/1560875015170428928/material/19181666430944_.pic.jpg";

            HStudentFooterView *footerView = [[HStudentFooterView alloc] init];
            footerView.type = FootTYPE_SLEEP;
            [footerView setupWithModel:student];
            [footerView loadDangerStyle];
            [footerView setLastCellBorder];
            [self.scrollView addSubview:footerView];

            [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(dangerTopView.mas_bottom);
                make.left.equalTo(dangerTopView);
                make.right.equalTo(dangerTopView.mas_right);
                make.height.mas_equalTo(PAaptation_y(78));
            }];

            tempFootView = footerView;
        }
    }

    [self.scrollView addSubview:self.printBtn];
    [self.printBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(unnormalList.count == 0 ? tempStudentNameLabel.mas_bottom :  tempFootView.mas_bottom).offset(PAaptation_y(26));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(146));
        make.height.mas_equalTo(PAaptation_y(48));
    }];
    
     
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  CGRectGetMaxY(bgView.frame)+CGRectGetMaxY(tempStudentNameLabel.frame)+ PAaptation_y(47+78+10)*unnormalList.count);

}
- (void)backAction:(id)sender
{
//    DefineWeakSelf;
    [self dismissViewControllerAnimated:YES completion:^{
//        if (weakSelf.closeSleepReportBlock) {
//            weakSelf.closeSleepReportBlock();
//        }
    }];

}
- (NSArray *)getDurationTimeStrWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSArray *startArray = [startTime componentsSeparatedByString:@" "];
    NSArray *endArray = [endTime componentsSeparatedByString:@" "];
    
    return @[startArray[0],[NSString stringWithFormat:@"%@~%@",startArray[1],endArray[1]]];
}
- (void)printAction
{
    DefineWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BWGetPDFReq *pdfReq = [[BWGetPDFReq alloc] init];
    pdfReq.taskId = self.taskId;
    [NetManger getRequest:pdfReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetPDFResp *pdfResp = (BWGetPDFResp *)resp;
        
        [weakSelf openPdfActionWithFileStr:[pdfResp.item safeObjectForKey:@"file"]];
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
- (void)openPdfActionWithFileStr:(NSString *)fileStr
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fileStr]];
}
#pragma mark - LazyLoad -
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = YES;
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
        _titleLabel.text = @"午睡报告";
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
        _timeDesLabel.text = @"午睡時間：";
        _timeDesLabel.textColor = BWColor(0, 28, 41, 1);
    }
    return _timeDesLabel;
}
- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] init];
        _yearLabel.font = [UIFont boldSystemFontOfSize:20.0];
        NSArray *dateArray = [self getDurationTimeStrWithStartTime:self.reportInfo.startTime endTime:self.reportInfo.endTime];
        NSString *year = [dateArray safeObjectAtIndex:0];
        NSArray *tempArray = [year componentsSeparatedByString:@"-"];
        NSString *y = [tempArray safeObjectAtIndex:0];
        NSString *m = [tempArray safeObjectAtIndex:1];
        NSString *d = [tempArray safeObjectAtIndex:2];
        _yearLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",y,m,d];
    }
    return _yearLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:32.0];
        NSArray *dateArray = [self getDurationTimeStrWithStartTime:self.reportInfo.startTime endTime:self.reportInfo.endTime];

        _timeLabel.text = [dateArray safeObjectAtIndex:1];;
    }
    return _timeLabel;
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
        _groupLabel.text = self.reportInfo.className;
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
        _teacherNumLabel.text = [NSString stringWithFormat:@"%ld人",self.reportInfo.assistantList.count];
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
        _studentNumLabel.text = [NSString stringWithFormat:@"%ld人",self.reportInfo.kidsList.count];
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
        [_printBtn addTarget:self action:@selector(printAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _printBtn;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setImage:[UIImage imageNamed:@"moon.png"]];
    }
    return _imageView;
}
@end
