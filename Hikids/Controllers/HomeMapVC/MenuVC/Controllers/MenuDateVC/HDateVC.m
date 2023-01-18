//
//  HDateVC.m
//  Hikids
//
//  Created by 马腾 on 2023/1/9.
//

#import "HDateVC.h"
#import "HDateCard.h"
#import "HSleepReportVC.h"
#import "HWalkReportVC.h"
#import "ALCalendarPicker.h"
#import "ALCalendarHelper.h"

#import "BWGetTaskCalendarReq.h"
#import "BWGetTaskCalendarResp.h"
#import "HReport.h"


@interface HDateVC ()<UITableViewDelegate,UITableViewDataSource,ALCalendarPickerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSArray *allWeekReportArray;
@property (nonatomic, strong) NSArray *allMonthReportArray;
@property (nonatomic, strong) NSArray *currentReportArray;
@property (nonatomic, assign) NSInteger lastTag;

@property (nonatomic, strong) ALCalendarPicker *calP;
@property (nonatomic, strong) NSArray  *weeks;
@property (nonatomic, strong) NSArray  *dateWeeks;//用来点击选择日期时使用(用来解决服务器时间字符串对不上)
@property (nonatomic,   copy) NSString *firstDayDeteOfWeek;
@property (nonatomic,   copy) NSString *nowDayDeteOfWeek;
@property (nonatomic,   copy) NSString *lastDayDeteOfWeek;
@end

@implementation HDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取一周时间
    [self getDateWeeksDuraingToday];

}
- (void)startRequestWithDate:(NSString *)dateStr
{
    DefineWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BWGetTaskCalendarReq *calendarReq = [[BWGetTaskCalendarReq alloc] init];
    calendarReq.dateStr = dateStr;
    [NetManger getRequest:calendarReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetTaskCalendarResp *calendarResp = (BWGetTaskCalendarResp *)resp;
        weakSelf.allWeekReportArray = calendarResp.itemList;
                
        [weakSelf findTaskArrayWithDate:weakSelf.nowDayDeteOfWeek];
        
        [weakSelf createUI];
        
        [weakSelf.tableView reloadData];

        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
//获取一个月的报告
- (void)startRequestWithMonthDate:(NSString *)dateStr
{
    DefineWeakSelf;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BWGetTaskMonthCalendarReq *monthReq = [[BWGetTaskMonthCalendarReq alloc] init];
    monthReq.dateStr = dateStr;
    [NetManger getRequest:monthReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWGetTaskCalendarResp *monthResp = (BWGetTaskCalendarResp *)resp;
        weakSelf.allMonthReportArray = monthResp.itemList;
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (HReport *report in weakSelf.allMonthReportArray) {
            NSArray *timeArray = [report.createTime componentsSeparatedByString:@" "];
            NSString *yymm = [timeArray safeObjectAtIndex:0];
            [tempArray addObject:yymm];
        }
        
        weakSelf.calP.hightLightItems = tempArray;
        [weakSelf.calP reloadPicker];

        
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
    
    [self createDateSelectView];
    
    [self createTableView];
    
    [self createDateListView];
    
}
- (void)createTitleView
{
    [self.bgView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
        make.height.mas_equalTo(PAaptation_y(40));
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
- (void)createDateSelectView
{
    [self.view addSubview:self.dateButton];
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.view).offset(PAdaptation_x(8));
        make.width.mas_equalTo(PAdaptation_x(70));
        make.height.mas_equalTo(PAaptation_y(104));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"dateIcon.png"]];
    [self.dateButton addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateButton).offset(PAaptation_y(31));
        make.centerX.equalTo(self.dateButton);
        make.width.mas_equalTo(PAdaptation_x(25));
        make.height.mas_equalTo(PAaptation_y(25));
    }];
    
    UILabel *buttonDesLabel = [[UILabel alloc] init];
    buttonDesLabel.font = [UIFont systemFontOfSize:12];
    buttonDesLabel.textColor = BWColor(191, 76, 13, 1);
    buttonDesLabel.text = @"日付選択";
    [self.dateButton addSubview:buttonDesLabel];
    
    [buttonDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(PAaptation_y(5));
        make.centerX.equalTo(imageView);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BWColor(34, 34, 34, 1);
    [self.dateButton addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateButton);
        make.left.equalTo(self.dateButton.mas_right).offset(-0.5);
        make.width.mas_equalTo(0.5);
        make.height.equalTo(self.dateButton);
    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateButton);
        make.left.equalTo(self.dateButton.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.dateButton.mas_bottom);
    }];
    
    UIView *tempView;
    self.lastTag = -1;
    DefineWeakSelf;
    for (NSInteger i = 0; i<self.weeks.count; i++) {
        
        NSString *dataStr = [weakSelf.weeks safeObjectAtIndex:i];
        NSArray *array = [dataStr componentsSeparatedByString:@":"];
        NSArray *mArray = [[array safeObjectAtIndex:0] componentsSeparatedByString:@"-"];
        
        NSString *selDateStr = [weakSelf.dateWeeks safeObjectAtIndex:i];
        NSArray *selArray = [selDateStr componentsSeparatedByString:@":"];
        
        HDateCard *cardView = [[HDateCard alloc] init];
        cardView.tag = 2000+i;
        cardView.date = [selArray safeObjectAtIndex:0];
        cardView.desLabel.text = [array safeObjectAtIndex:1];
        cardView.dayLabel.text = [mArray safeObjectAtIndex:2];
        cardView.monthLabel.text = [NSString stringWithFormat:@"%@月",[mArray safeObjectAtIndex:1]];
        if ([cardView.date isEqualToString:self.nowDayDeteOfWeek]) {
            [cardView loadSelectStyle];
            self.lastTag = cardView.tag;
        }else{
            //判断是否有报告
            BOOL isHave = [self findReportWithDate:[selArray safeObjectAtIndex:0]];
            if (isHave) {
                [cardView loadNomalStyle];
            }else{
                [cardView loadNoDataStyle];
            }
            
        }
        [self.scrollView addSubview:cardView];
        
        [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(PAdaptation_x(5));
            if (i == 0) {
                make.left.equalTo(self.scrollView);
            }else{
                make.left.equalTo(tempView.mas_right).offset(PAdaptation_x(6));
            };
            make.width.mas_equalTo(PAdaptation_x(68));
            make.height.mas_equalTo(PAaptation_y(91));
        }];
        
        
        cardView.clickBlock = ^(HDateCard * _Nonnull cardView) {
            if (cardView.tag == self.lastTag) {
                //重复点击
                return;
            }
            HDateCard *lastCardView = (HDateCard *)[weakSelf.view viewWithTag:weakSelf.lastTag];
            [weakSelf setCardView:cardView withLastCardView:lastCardView];
            [weakSelf findTaskArrayWithDate:cardView.date];
            [weakSelf.tableView reloadData];
            
            weakSelf.lastTag = cardView.tag;


        };
        
        tempView = cardView;
        
    }
    
    self.scrollView.contentSize = CGSizeMake(PAdaptation_x(74)*self.weeks.count, PAaptation_y(104));

}
- (void)setCardView:(HDateCard *)cardView withLastCardView:(HDateCard *)lastCardView
{
    [cardView loadSelectStyle];
   
    //判断是否有报告
    BOOL isHave = [self findReportWithDate:lastCardView.date];
    
    if (isHave) {
        [lastCardView loadNomalStyle];
    }else{
        [lastCardView loadNoDataStyle];
    }
    

}
- (BOOL)findReportWithDate:(NSString *)dateStr
{
    for (HReport *report in self.allWeekReportArray) {
        NSArray *timeArray = [report.createTime componentsSeparatedByString:@" "];
        NSString *reportDateStr = [timeArray safeObjectAtIndex:0];

        if ([dateStr isEqualToString:reportDateStr]) {
            return YES;
        }
    }
    return NO;
}
- (void)createTableView
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_bottom).offset(PAaptation_y(32));
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)createDateListView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIView *calendarBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    calendarBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    calendarBgView.hidden = YES;
    calendarBgView.alpha = 0;
    calendarBgView.tag = 10000;
    [self.view addSubview:calendarBgView];
    
    // 宽度建议使用屏幕宽度 高度太低会有滚动条
    self.calP = [[ALCalendarPicker alloc] initWithFrame:CGRectMake(screenSize.width/2 - PAdaptation_x(357)/2, screenSize.height/2 - PAaptation_y(336)/2,PAdaptation_x(357), PAaptation_y(336))];
    self.calP.delegate = self;

    // 起始日期
//    self.calP.beginYearMonth = self.selectDateOfWeek;
    self.calP.hightlightPriority = NO;
    self.calP.layer.cornerRadius = 13;
    self.calP.layer.masksToBounds = YES;
    
    // 高亮日期样式
    [self.calP setupHightLightItemStyle:^(UIColor *__autoreleasing *backgroundColor, NSNumber *__autoreleasing *backgroundCornerRadius, UIColor *__autoreleasing *titleColor) {
        *backgroundColor = [UIColor colorWithRed:234.0/255.0 green:240.0/255.0 blue:243.0/255.0 alpha:1];
        *backgroundCornerRadius = @(5.0);
        *titleColor = [UIColor colorWithRed:44.0/255.0 green:49.0/255.0 blue:53.0/255.0 alpha:1];
    }];
    
    // 今天日期样式
    [self.calP setupTodayItemStyle:^(UIColor *__autoreleasing *backgroundColor, NSNumber *__autoreleasing *backgroundCornerRadius, UIColor *__autoreleasing *titleColor) {
        *backgroundColor = [UIColor redColor];
        *backgroundCornerRadius = @(PAdaptation_x(357) / 20); // 因为宽度是屏幕宽度,宽度 / 10 是cell 宽高 , cell宽高 / 2 为圆形
        *titleColor = [UIColor whiteColor];
    }];
    
    // 选择日期颜色
    [self.calP setupSelectedItemStyle:^(UIColor *__autoreleasing *backgroundColor, NSNumber *__autoreleasing *backgroundCornerRadius, UIColor *__autoreleasing *titleColor) {
        *backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        *backgroundCornerRadius = @(PAdaptation_x(357) / 20); // 因为宽度是屏幕宽度,宽度 / 10 是cell 宽高 , cell宽高 / 2 为圆形
        *titleColor = [UIColor whiteColor];
    }];
    
    [calendarBgView addSubview:self.calP];
    

}
- (void)findTaskArrayWithDate:(NSString *)selectDateStr
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (HReport *report in self.allWeekReportArray) {
        NSArray *timeArray = [report.createTime componentsSeparatedByString:@" "];
        NSString *dateStr = [timeArray safeObjectAtIndex:0];
        if ([dateStr isEqualToString:selectDateStr]) {
            [tempArray addObject:report];
        }
    }
    
    if (tempArray == 0) {
        for (HReport *report in self.allMonthReportArray) {
            NSArray *timeArray = [report.createTime componentsSeparatedByString:@" "];
            NSString *dateStr = [timeArray safeObjectAtIndex:0];
            if ([dateStr isEqualToString:selectDateStr]) {
                [tempArray addObject:report];
            }
        }
    }
    self.currentReportArray = tempArray;
    
}
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)showDateAction:(id)sender
{
    UIView *calendarBgView = (UIView *)[self.view viewWithTag:10000];
    calendarBgView.hidden = NO;
    
    [UIView animateWithDuration:0.1 animations:^{
            
        calendarBgView.alpha = 1.0;
        
    }];
    
    [self startRequestWithMonthDate:self.nowDayDeteOfWeek];
}
/**
 *  模式二
 *  获取当前时间所在一周的第一天和最后一天, 也即一周的日期
 *  注意：当天在这一周内，不是作为起点往后顺延
 */
- (void)getDateWeeksDuraingToday
{
    //日历格式
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                         fromDate:now];
    // 得到：今天是星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到：今天是几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld  day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 0;
        lastDiff = 6;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 一周日期
    NSArray *dateWeeks = [self getCurrentWeeksWithFirstDiff:firstDiff lastDiff:lastDiff withFormatter:@"yyyy-M-d"];
    NSArray *tempDateWeeks = [self getCurrentWeeksWithFirstDiff:firstDiff lastDiff:lastDiff withFormatter:@"yyyy-MM-dd"];
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"一周开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"一周结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    NSLog(@"%@",dateWeeks);
    
    self.firstDayDeteOfWeek = [formater stringFromDate:firstDayOfWeek];
    self.nowDayDeteOfWeek = [formater stringFromDate:now];
    self.lastDayDeteOfWeek = [formater stringFromDate:lastDayOfWeek];
    self.weeks = dateWeeks;
    self.dateWeeks = tempDateWeeks;
    
    [self startRequestWithDate:self.nowDayDeteOfWeek];
    
    
}

//获取一周时间 数组
- (NSMutableArray *)getCurrentWeeksWithFirstDiff:(NSInteger)first lastDiff:(NSInteger)last withFormatter:(NSString *)formatter{
    
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (NSInteger i = first; i < last + 1; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatter];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        //NSString *dateStr = @"5月31日";
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //转换文案
        weekStr = [self transWeekName:weekStr];
        
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@:%@",dateStr,weekStr];
        [eightArr addObject:strTime];
        
    }
    return eightArr;
}
-(NSString *)transWeekName:(NSString *)orrignWeekName
{
    NSString *targetWeekName = @"";
    
    //转换文案
    if ([orrignWeekName isEqualToString:@"星期日"] || [orrignWeekName isEqualToString:@"にちようび"]) {
        targetWeekName = @"日";
    }
    else if ([orrignWeekName isEqualToString:@"星期一"] || [orrignWeekName isEqualToString:@"げつようび"]) {
        targetWeekName = @"月";
    }
    else if ([orrignWeekName isEqualToString:@"星期二"] || [orrignWeekName isEqualToString:@"かようび"]) {
        targetWeekName = @"火";
    }
    else if ([orrignWeekName isEqualToString:@"星期三"] || [orrignWeekName isEqualToString:@"すいようび"]) {
        targetWeekName = @"水";
    }
    else if ([orrignWeekName isEqualToString:@"星期四"] || [orrignWeekName isEqualToString:@"もくようび"]) {
        targetWeekName = @"木";
    }
    else if ([orrignWeekName isEqualToString:@"星期五"] || [orrignWeekName isEqualToString:@"きんようび"]) {
        targetWeekName = @"金";
    }else{
        targetWeekName = @"土";
    }
    
    return targetWeekName;
}

#pragma mark - 选择一个日期 -
- (void)calendarPicker:(ALCalendarPicker *)picker didSelectItem:(ALCalendarDate *)date date:(NSDate *)dateObj dateString:(NSString *)dateStr
{
//    if (![self findReportWithDate:dateStr]) {
//        return;
//    }
    picker.selectedItems = @[dateStr];
    [picker reloadPicker];
    
    UIView *calendarBgView = (UIView *)[self.view viewWithTag:10000];
    [UIView animateWithDuration:0.1 animations:^{

        calendarBgView.alpha = 0.0;

    } completion:^(BOOL finished) {

        if (finished) {
            calendarBgView.hidden = YES;

        }
    }];
        
    if ([self compareOneDay:dateStr withAnotherDay:self.firstDayDeteOfWeek] || ![self compareOneDay:dateStr withAnotherDay:self.lastDayDeteOfWeek]) {
        NSLog(@"不再本周范围内，将周的日历选中状态改为空白");
        
        HDateCard *cardView = (HDateCard *)[self.view viewWithTag:self.lastTag];
        [cardView loadNomalStyle];
        self.lastTag = -1;
        
    
    }else{
        for (UIView *view in self.scrollView.subviews) {
            if ([view isKindOfClass:[HDateCard class]]) {
                HDateCard *cardView = (HDateCard *)view;
                if ([cardView.date isEqualToString:dateStr]) {
                    [cardView loadSelectStyle];
                    self.lastTag = cardView.tag;
                }else{
                    if ([self findReportWithDate:cardView.date]) {
                        [cardView loadNomalStyle];
                    }else{
                        [cardView loadNoDataStyle];
                    }
                }
            }
        }
    }
    
    [self findTaskArrayWithDate:dateStr];
    [self.tableView reloadData];
    
    
}
- (BOOL)compareOneDay:(NSString *)day1 withAnotherDay:(NSString *)day2
{
    NSDate *dateA = [ALCalendarHelper dateStringToDate:day1 format:@"yyyy-M-d"];
    NSDate *dateB = [ALCalendarHelper dateStringToDate:day2 format:@"yyyy-M-d"];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return NO; // Day1 在 Day2 之后
    }
    else if (result == NSOrderedAscending) {
        return YES; // Day1 在 Day2 之前
    }
    return YES;
}
#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.currentReportArray.count == 0 ? PAaptation_y(44) : PAaptation_y(105);

}

#pragma mark - cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentReportArray.count == 0 ? 1 : self.currentReportArray.count;
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
    
    
    [self setupCell:cell indexPath:indexPath];
    

    return cell;
}
- (void)setupCell:(UITableViewCell *)cell  indexPath:(NSIndexPath *)indexPath
{
    if (self.currentReportArray.count == 0) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"この日はデータがありません。"];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = BWColor(0, 0, 0, 0.3);
        [cell.contentView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
        }];
        
    }else{
        HReport *report = [self.currentReportArray safeObjectAtIndex:indexPath.row];
        NSArray *timeArray = [report.createTime componentsSeparatedByString:@" "];
        NSString *timeStr = [timeArray safeObjectAtIndex:1];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.cornerRadius = 8;
        bgView.layer.borderWidth = 2;
        bgView.layer.borderColor = BWColor(34, 34, 34, 1).CGColor;
        [cell.contentView addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(PAaptation_y(5));
            make.left.equalTo(cell.contentView).offset(PAdaptation_x(24));
            make.right.equalTo(cell.contentView.mas_right).offset(-PAdaptation_x(24));
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PAaptation_y(5));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        label.font = [UIFont boldSystemFontOfSize:48];
        [bgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(PAdaptation_x(24));
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.left.equalTo(bgView).offset(PAdaptation_x(95));
            make.width.mas_equalTo(PAdaptation_x(50));
            make.height.mas_equalTo(PAaptation_y(50));
        }];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = timeStr;
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = BWColor(76, 53, 41, 0.6);
        [bgView addSubview:timeLabel];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView);
            make.left.equalTo(imageView.mas_right).offset(PAdaptation_x(18));
        }];
        
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont boldSystemFontOfSize:20];
        contentLabel.textColor = BWColor(76, 53, 41, 1);
        [bgView addSubview:contentLabel];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).offset(PAaptation_y(2));
            make.left.equalTo(timeLabel);
        }];
        
        if (report.type.integerValue == 1) {
            [imageView setImage:[UIImage imageNamed:@"walk.png"]];
            contentLabel.text = @"散歩レポート";
        }else{
            [imageView setImage:[UIImage imageNamed:@"nap.png"]];
            contentLabel.text = @"午睡レポート";
        }
    }
    

}
#pragma mark - UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HReport *report = [self.currentReportArray safeObjectAtIndex:indexPath.row];
    
    if (report.type.integerValue == 1) {
        HWalkReportVC *walkReport = [[HWalkReportVC alloc] init];
        walkReport.taskId = report.rId;
        [self presentViewController:walkReport animated:YES completion:nil];
    }
    if (report.type.integerValue == 2) {
        HSleepReportVC *sleepReport = [[HSleepReportVC alloc] init];
        sleepReport.taskId = report.rId;
        [self presentViewController:sleepReport animated:YES completion:nil];
    }
}
#pragma mark - LazyLoad -
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:32];
        _titleLabel.text = @"レポート";
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
- (UIButton *)dateButton
{
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton addTarget:self action:@selector(showDateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateButton;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
