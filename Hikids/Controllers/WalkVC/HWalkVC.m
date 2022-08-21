//
//  HWalkVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HWalkVC.h"
#import "HMapVC.h"


@interface HWalkVC ()

@end

@implementation HWalkVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    [self createUI];
    

}
- (void)createUI
{
    
    self.customNavigationView.backgroundImageView.backgroundColor = [UIColor yellowColor];
    self.customNavigationView.titleLabel.text = @"散步";
    self.customNavigationView.desLabel.text = @"2022.08.21";
    self.customNavigationView.markImageView.backgroundColor = [UIColor greenColor];

    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"打开" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
}
- (void)clickAction:(id)sender
{
    HMapVC *mapVC = [[HMapVC alloc] init];
    mapVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mapVC animated:YES];
}
@end
