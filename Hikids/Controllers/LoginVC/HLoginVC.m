//
//  HLoginVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/4.
//

#import "HLoginVC.h"
#import "BWLoginReq.h"
#import "BWLoginResp.h"
#import "BWCheckTokenReq.h"
#import "BWCheckTokenResp.h"

@interface HLoginVC ()

@end

@implementation HLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"登陆" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    [button addTarget:self action:@selector(LoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(200));
        make.height.mas_equalTo(PAaptation_y(44));
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setTitle:@"检测token" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor blueColor]];
    [button1 addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom);
        make.width.mas_equalTo(PAdaptation_x(200));
        make.height.mas_equalTo(PAaptation_y(44));
    }];
}

- (void)LoginAction:(id)sender
{
    BWLoginReq *loginReq = [[BWLoginReq alloc] init];
    loginReq.username = @"admin";
    loginReq.password = @"admin123";
    [NetManger postRequest:loginReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
        
            
    } failure:^(BWBaseReq *req, NSError *error) {
            
    }];
}
- (void)checkAction:(id)sender
{
    BWCheckTokenReq *loginReq = [[BWCheckTokenReq alloc] init];
    [NetManger getRequest:loginReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
    } failure:^(BWBaseReq *req, NSError *error) {
        
    }];
}


@end
