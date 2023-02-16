//
//  HStudentStateTopView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HStudentStateTopView.h"

@interface HStudentStateTopView()
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *stateLabel;



@end

@implementation HStudentStateTopView
- (instancetype)init
{
    if (self = [super init]) {
        

        self.topView = [[UIImageView alloc] init];
        self.topView.userInteractionEnabled = YES;
        [self addSubview:self.topView];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(1);
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self);
        }];
        
        self.iconView = [[UIImageView alloc] init];
        [self.topView addSubview:self.iconView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.topView).offset(PAdaptation_x(16));
            make.width.mas_equalTo(PAdaptation_x(28));
            make.height.mas_equalTo(PAaptation_y(28));
        }];
        
        self.stateLabel = [[UILabel alloc] init];
        self.stateLabel.textColor = [UIColor whiteColor];
        self.stateLabel.font = [UIFont systemFontOfSize:20];
        [self.topView addSubview:self.stateLabel];
        
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.iconView.mas_right).offset(PAdaptation_x(10));
        }];
        
        self.numberBg = [[UILabel alloc] init];
        self.numberBg.backgroundColor = [UIColor whiteColor];
        self.numberBg.layer.cornerRadius = 4;
        self.numberBg.layer.masksToBounds = YES;
        [self.topView addSubview:self.numberBg];
        
        [self.numberBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView);
            make.left.equalTo(self.stateLabel.mas_right).offset(PAdaptation_x(10));
            make.width.mas_equalTo(PAdaptation_x(59));
            make.height.mas_equalTo(PAaptation_y(26));
        }];
        
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.font = [UIFont systemFontOfSize:16];
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:self.numberLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.numberBg);
        }];
        
        self.expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.expandBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [self.topView addSubview:self.expandBtn];
        
        [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self.topView.mas_right).offset(-PAdaptation_x(11.5));
            make.width.mas_equalTo(PAdaptation_x(21));
            make.height.mas_equalTo(PAaptation_y(24));
        }];
        
        self.dangerTimeLabel = [[UILabel alloc] init];
        self.dangerTimeLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.topView addSubview:self.dangerTimeLabel];
        
        [self.dangerTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self.topView.mas_right).offset(-PAdaptation_x(11.5));
        }];
        
        
        
    }
    return self;
}
- (void)clickExpandAction:(UIButton *)button
{
    if (self.expandBlock) {
        self.expandBlock();
    }
}

- (void)loadSafeStyle
{
    [self.iconView setImage:self.type == TYPE_WALK ? [UIImage imageNamed:@"safeIcon.png"] : [UIImage imageNamed:@"heart.png"]];
    [self.topView setImage:[UIImage imageNamed:@"safeStatus.png"]];
    self.stateLabel.text = self.type == TYPE_WALK ? @"安全エリア内" : @"心拍正常";
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.studentList.count];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberBg.backgroundColor = BWColor(5, 70, 11, 1);

}
- (void)loadDangerStyle
{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.studentList.count];
    
    if (self.type == TYPE_WALK) {
        [self.topView setImage:[UIImage imageNamed:@"dangerStatus.png"]];
        [self.iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
        self.stateLabel.text =  @"危険";
        self.numberLabel.textColor = BWColor(255, 75, 0, 1);
        self.numberBg.backgroundColor = [UIColor whiteColor];
    }else{
        [self.topView setImage:[UIImage imageNamed:@"sleep_danger_status.png"]];
        [self.iconView setImage:[UIImage imageNamed:@"sleep_wx.png"]];
        self.stateLabel.text =  @"要注意";
        self.stateLabel.textColor = BWColor(76, 53, 41, 1);
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberBg.backgroundColor = BWColor(76, 53, 41, 1);
    }

}

@end
