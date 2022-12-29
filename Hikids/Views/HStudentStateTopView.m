//
//  HStudentStateTopView.m
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HStudentStateTopView.h"

@interface HStudentStateTopView()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *numberBg;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *numberLabel;


@end

@implementation HStudentStateTopView
- (instancetype)init
{
    if (self = [super init]) {
        
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headerView];
        
        [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = BWColor(255, 75, 0, 1);
        [headerView addSubview:self.topView];
        
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headerView);
        }];
        
        self.iconView = [[UIImageView alloc] init];
        [self.iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
        [headerView addSubview:self.iconView];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.left.equalTo(self.topView).offset(PAdaptation_x(16));
            make.width.mas_equalTo(PAdaptation_x(24));
            make.height.mas_equalTo(PAaptation_y(24));
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
        
        UIButton *expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [expandBtn addTarget:self action:@selector(clickExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        [expandBtn setImage:[UIImage imageNamed:@"triangle_small.png"] forState:UIControlStateNormal];
        [self.topView addSubview:expandBtn];
        
        [expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self.topView.mas_right).offset(-PAdaptation_x(11.5));
            make.width.mas_equalTo(PAdaptation_x(21));
            make.height.mas_equalTo(PAaptation_y(24));
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
    [self.iconView setImage:[UIImage imageNamed:@"safeIcon.png"]];
    self.stateLabel.text = @"安全";
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.studentList.count];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberBg.backgroundColor = BWColor(5, 70, 11, 1);
    self.topView.backgroundColor = BWColor(0, 176, 107, 1);
}
- (void)loadDangerStyle
{
    [self.iconView setImage:[UIImage imageNamed:@"dangerIcon.png"]];
    self.stateLabel.text = @"危険";
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",self.studentList.count];
    self.numberLabel.textColor = BWColor(255, 75, 0, 1);
    self.topView.backgroundColor = BWColor(255, 75, 0, 1);
    self.numberBg.backgroundColor = [UIColor whiteColor];
}

@end
