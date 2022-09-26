//
//  HMenuVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HBaseMenuVC.h"

@interface HBaseMenuVC ()
@property (nonatomic, assign) BOOL isShow;
@end

@implementation HBaseMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createHeaderView];
}

- (void)createHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMenuAction:)];
    [headerView addGestureRecognizer:tap];
    
    UIImageView *topView = [[UIImageView alloc] init];
    [topView setImage:[UIImage imageNamed:@"menu_header.png"]];
    [headerView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    [lineView setImage:[UIImage imageNamed:@"line.png"]];
    [headerView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.width.mas_equalTo(PAdaptation_x(64));
        make.height.mas_equalTo(PAaptation_y(6));
    }];
}
- (void)clickMenuAction:(UITapGestureRecognizer *)tap
{
    self.isShow = !self.isShow;
    
    if (self.isShow) {
        [self showMenuVC];
    }else{
        [self closeMenuVC];
    }
    
}

- (void)showMenuVC
{
    DefineWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.view.frame = CGRectMake(0, BW_StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT);

    }];
}
- (void)closeMenuVC
{
    DefineWeakSelf;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.view.frame = CGRectMake(0, SCREEN_HEIGHT- PAaptation_y(150), SCREEN_WIDTH, SCREEN_HEIGHT);

    }];
}
- (void)forceShow
{
    self.isShow = YES;
    [self showMenuVC];
}
- (void)forceClose
{
    self.isShow = NO;
    [self closeMenuVC];
}

@end
