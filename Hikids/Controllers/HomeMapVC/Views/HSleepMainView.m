//
//  HSleepMainView.m
//  Hikids
//
//  Created by 马腾 on 2023/1/3.
//

#import "HSleepMainView.h"
#import "HTask.h"

@interface HSleepMainView()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *contentView;
@property (nonatomic, strong) UILabel *timeDesLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *sleepNumDesLabel;
@property (nonatomic, strong) UILabel *sleepNumLabel;
@property (nonatomic, strong) UILabel *getupNumDesLabel;
@property (nonatomic, strong) UILabel *getupNumLabel;
@property (nonatomic, strong) UILabel *huiNumDesLabel;
@property (nonatomic, strong) UILabel *huiNumLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) long planTime;//task的时间
@property (nonatomic, assign) long duration;//服务器返回的持续时间
@property (nonatomic, assign) long second;//当前秒++


@end

@implementation HSleepMainView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.bgView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(PAaptation_y(40));
            make.centerX.equalTo(self.bgView);
            make.width.mas_equalTo(PAdaptation_x(356));
            make.height.mas_equalTo(PAaptation_y(278));
        }];
        
        [self.contentView addSubview:self.timeDesLabel];
        [self.timeDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(PAaptation_y(50));
            make.left.equalTo(self.contentView).offset(PAdaptation_x(20));
        }];
        
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.timeDesLabel.mas_bottom).offset(PAaptation_y(3));
            make.left.equalTo(self.timeDesLabel.mas_right).offset(PAdaptation_x(30));
        }];
        
        [self.contentView addSubview:self.sleepNumDesLabel];
        [self.sleepNumDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.timeDesLabel.mas_bottom).offset(PAaptation_y(48));
            make.left.equalTo(self.timeDesLabel);
        }];
        
        [self.contentView addSubview:self.sleepNumLabel];
        [self.sleepNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sleepNumDesLabel.mas_bottom).offset(PAaptation_y(3));
            make.left.equalTo(self.sleepNumDesLabel.mas_right).offset(PAdaptation_x(30));
        }];
        
//        [self.contentView addSubview:self.getupNumDesLabel];
//        [self.getupNumDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.timeDesLabel.mas_bottom).offset(PAaptation_y(48));
//            make.left.equalTo(self.sleepNumLabel.mas_right).offset(PAdaptation_x(16));
//        }];
//
//        [self.contentView addSubview:self.getupNumLabel];
//        [self.getupNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.getupNumDesLabel.mas_bottom);
//            make.left.equalTo(self.getupNumDesLabel.mas_right).offset(PAdaptation_x(30));
//        }];
        
        [self.contentView addSubview:self.huiNumDesLabel];
        [self.huiNumDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sleepNumDesLabel.mas_bottom).offset(PAaptation_y(54));
            make.left.equalTo(self.timeDesLabel);
        }];
        
        [self.contentView addSubview:self.huiNumLabel];
        [self.huiNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.huiNumDesLabel.mas_bottom).offset(PAaptation_y(3));
            make.left.equalTo(self.huiNumDesLabel.mas_right).offset(PAdaptation_x(30));
        }];
        
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
        
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(startTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterActive) name:@"enterActive" object:nil];

        
    }
    return self;
}
//app进入前台 同步服务器时间
- (void)enterActive
{
    if (self.duration > self.second) {
        self.second = self.duration;
    }
}
- (void)closeTimer
{
    
    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)startTime
{
    self.second ++;
    
    NSString *timeStr = [self timeFormatted:self.second];
    
    self.timeLabel.text = timeStr;
    
    if (self.planTime == 0) {
        return;
    }
    
    if (self.second >=  self.planTime*60) {
        
        if (self.sleepTimeOverBlock) {
            self.sleepTimeOverBlock();
        }
        

    
    }
}
- (NSString *)timeFormatted:(long)totalSeconds
{

    long seconds = totalSeconds % 60;
    long minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
}
- (void)setupContent:(id)model
{
    NSDictionary *dic = (NSDictionary *)model;
    NSArray *normalList = [dic safeObjectForKey:@"normalList"];
    NSArray *unnormalList = [dic safeObjectForKey:@"unnormalList"];
    self.planTime = [[dic safeObjectForKey:@"planTime"] longLongValue];
//    NSString *startTime = [dic safeObjectForKey:@"startTime"];
//    NSString *endTime = [dic safeObjectForKey:@"endTime"];
        

    self.duration = [[dic safeObjectForKey:@"duration"] longLongValue];
    if (self.duration > self.second) {
        self.second = self.duration;
    }
    self.sleepNumLabel.text = [NSString stringWithFormat:@"%ld人",normalList.count + unnormalList.count];
//    self.getupNumLabel.text = @"0人";
    self.huiNumLabel.text = [NSString stringWithFormat:@"%ld人",unnormalList.count];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - LazyLoad -
- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        [_bgView setImage:[UIImage imageNamed:@"nap_back.png"]];
    }
    return _bgView;
}
- (UIImageView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIImageView alloc] init];
        [_contentView setImage:[UIImage imageNamed:@"back-data.png"]];
    }
    return _contentView;
}
- (UILabel *)timeDesLabel
{
    if (!_timeDesLabel) {
        _timeDesLabel = [[UILabel alloc] init];
        _timeDesLabel.font = [UIFont systemFontOfSize:14.0];
        _timeDesLabel.text = @"午睡中";
    }
    return _timeDesLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:36.0];
        _timeLabel.text = [NSString stringWithFormat:@"--人"];
    }
    return _timeLabel;
}
- (UILabel *)sleepNumDesLabel
{
    if (!_sleepNumDesLabel) {
        _sleepNumDesLabel = [[UILabel alloc] init];
        _sleepNumDesLabel.font = [UIFont systemFontOfSize:14.0];
        _sleepNumDesLabel.text = @"午睡中";

    }
    return _sleepNumDesLabel;
}
- (UILabel *)sleepNumLabel
{
    if (!_sleepNumLabel) {
        _sleepNumLabel = [[UILabel alloc] init];
        _sleepNumLabel.font = [UIFont boldSystemFontOfSize:36.0];
        _sleepNumLabel.textColor = BWColor(108, 159, 155, 1);
        _sleepNumLabel.text = [NSString stringWithFormat:@"--人"];
    }
    return _sleepNumLabel;
}
- (UILabel *)getupNumDesLabel
{
    if (!_getupNumDesLabel) {
        _getupNumDesLabel = [[UILabel alloc] init];
        _getupNumDesLabel.font = [UIFont systemFontOfSize:14.0];
        _getupNumDesLabel.text = @"起床済";

    }
    return _getupNumDesLabel;
}
- (UILabel *)getupNumLabel
{
    if (!_getupNumLabel) {
        _getupNumLabel = [[UILabel alloc] init];
        _getupNumLabel.font = [UIFont boldSystemFontOfSize:36.0];
        _getupNumLabel.textColor = BWColor(196, 196, 196, 1);
    }
    return _getupNumLabel;
}
- (UILabel *)huiNumDesLabel
{
    if (!_huiNumDesLabel) {
        _huiNumDesLabel = [[UILabel alloc] init];
        _huiNumDesLabel.font = [UIFont systemFontOfSize:14.0];
        _huiNumDesLabel.text = @"要注意";
    }
    return _huiNumDesLabel;
}
- (UILabel *)huiNumLabel
{
    if (!_huiNumLabel) {
        _huiNumLabel = [[UILabel alloc] init];
        _huiNumLabel.font = [UIFont boldSystemFontOfSize:36.0];
        _huiNumLabel.textColor = BWColor(246, 170, 0, 1);
        _huiNumLabel.text = [NSString stringWithFormat:@"--人"];

    }
    return _huiNumLabel;
}
@end
