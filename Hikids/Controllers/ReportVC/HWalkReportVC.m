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

@end

@implementation HWalkReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}
- (void)createUI
{
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
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
    
    [self.scrollView addSubview:self.destLabel];
    [self.destLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destDesLabel.mas_bottom).offset(PAaptation_y(6));
        make.left.equalTo(self.destDesLabel);
        make.width.mas_equalTo(PAdaptation_x(112));
    }];
    
    [self.scrollView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.destLabel.mas_bottom).offset(PAaptation_y(2));
        make.left.equalTo(self.timeLabel);
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
    
    UILabel *tempTeacherNameLabel;
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *teacherNameLabel = [[UILabel alloc] init];
        teacherNameLabel.font = [UIFont boldSystemFontOfSize:20];
        teacherNameLabel.textColor = BWColor(0, 28, 41, 1);
        teacherNameLabel.text = @"小林健一";
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
    
    [self.scrollView addSubview:self.studentNumLabel];
    [self.studentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.studentDesLabel.mas_bottom);
        make.left.equalTo(self.studentDesLabel.mas_right).offset(PAdaptation_x(10));
    }];
    
    UIView *tempStudentHeaderView;
    for (NSInteger i = 0; i < 6; i++) {
        
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView = [[UIImageView alloc] init];
        headerImageView.layer.borderWidth = 2;
        headerImageView.layer.borderColor = BWColor(108, 159, 155, 1).CGColor;
        headerImageView.layer.cornerRadius = PAaptation_y(40)/2;
        headerImageView.layer.masksToBounds = YES;
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:@"https://yunpengmall.oss-cn-beijing.aliyuncs.com/1560875015170428928/material/19181666430944_.pic.jpg"]];
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
        studentNameLabel.text = @"山上ハルコ";
        [self.scrollView addSubview:studentNameLabel];
        
        [studentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerImageView);
            make.left.equalTo(headerImageView.mas_right).offset(PAdaptation_x(8));
        }];
        
        tempStudentHeaderView = headerImageView;
        
    }
    
    [self.scrollView addSubview:self.dangerLabel];
    [self.dangerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tempStudentHeaderView.mas_bottom).offset(PAaptation_y(26));
        make.left.equalTo(self.teacherDesLabel);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 12;
    bgView.layer.borderWidth = 2;
    bgView.layer.borderColor = BWColor(0.133, 0.133, 0.133, 1.0).CGColor;
    [self.scrollView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dangerLabel.mas_bottom).offset(PAaptation_y(10));
        make.left.equalTo(self.view).offset(PAdaptation_x(24));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(24));
        make.height.mas_equalTo(PAaptation_y(129));
    }];

    HStudentStateTopView *safeTopView = [[HStudentStateTopView alloc] init];
    safeTopView.studentList = @[];
    [safeTopView.expandBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [safeTopView loadDangerStyle];
    [bgView addSubview:safeTopView];
    [safeTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.left.equalTo(bgView);
        make.width.equalTo(bgView);
        make.height.mas_equalTo(PAaptation_y(47));
    }];

    //未展开的bottomView
    HStudentStateBottomView *safeBottomView = [[HStudentStateBottomView alloc] initWithArray:@[]];
    [bgView addSubview:safeBottomView];
    [safeBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(safeTopView.mas_bottom);
        make.left.equalTo(safeTopView);
        make.right.equalTo(safeTopView.mas_right);
        make.bottom.equalTo(bgView.mas_bottom);
    }];

    DefineWeakSelf;
    safeTopView.expandBlock = ^{

    };
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + PAaptation_y(180));

}
- (void)backAction:(id)sender
{
    DefineWeakSelf;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.closeWalkReportBlock) {
            weakSelf.closeWalkReportBlock();
        }
    }];

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
        _yearLabel.text = @"2022年7月21日";
    }
    return _yearLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:32.0];
        _timeLabel.text = @"11:09~12:26";
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
        _destLabel.text = @"堅磐信誠幼稚園玉の井町６丁目玉のい公園";
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
        _distanceLabel.text = @"300m";
    }
    return _distanceLabel;
}
- (UIImageView *)destImageView
{
    if (!_destImageView) {
        _destImageView = [[UIImageView alloc] init];
        _destImageView.layer.cornerRadius = 8;
        _destImageView.layer.borderWidth = 2;
        _destImageView.backgroundColor = [UIColor redColor];
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
        _groupLabel.text = @"ひまわり組";
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
        _teacherNumLabel.text = @"2人";
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
        _studentNumLabel.text = @"6人";
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
@end
