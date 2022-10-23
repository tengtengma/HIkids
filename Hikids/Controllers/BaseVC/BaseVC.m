//
//  BaseVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    [self createNavigationView];
}
- (void)createUI
{

}
//- (void)createNavigationView
//{
//    [self.view addSubview:self.customNavigationView];
//    [self.customNavigationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
//        make.left.equalTo(self.view);
//        make.width.equalTo(self.view);
//        make.height.mas_equalTo(PAaptation_y(156));
//    }];
//
//}




@end
