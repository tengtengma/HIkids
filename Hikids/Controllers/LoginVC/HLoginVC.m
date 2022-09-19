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
#import "HInputView.h"
#import "HRootVC.h"

@interface HLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *privacyLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) HInputView *userView;
@property (nonatomic, strong) HInputView *pwView;


@end

@implementation HLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
- (void)createUI
{
    [self.view addSubview:self.helpBtn];
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PAaptation_y(59));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PAaptation_y(257));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(290));
        make.height.mas_equalTo(PAaptation_y(58));
    }];
    
    
    self.userView.textField.placeholder = @"请输入用户名";
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(PAaptation_y(37.5));
        make.left.equalTo(self.view).offset(PAdaptation_x(50));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(50));
        make.height.mas_equalTo(PAaptation_y(56));
    }];
    
    self.pwView.textField.placeholder = @"请输入密码";
    [self.view addSubview:self.pwView];
    [self.pwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userView.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.view).offset(PAdaptation_x(50));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(50));
        make.height.mas_equalTo(PAaptation_y(56));
    }];
    
    [self.view addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwView.mas_bottom).offset(PAaptation_y(18));
        make.left.equalTo(self.view).offset(PAdaptation_x(122));
        make.width.mas_equalTo(PAdaptation_x(16));
        make.height.mas_equalTo(PAaptation_y(16));
    }];
    
    [self.view addSubview:self.privacyLabel];
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectImageView);
        make.left.equalTo(self.selectImageView.mas_right).offset(PAdaptation_x(4));
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyLabel.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.pwView);
        make.width.equalTo(self.pwView);
        make.height.equalTo(self.pwView);
    }];
    
    [self.view addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-PAaptation_y(37));
        make.centerX.equalTo(self.view);
    }];
}

- (void)loginAction:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DefineWeakSelf;
    BWLoginReq *loginReq = [[BWLoginReq alloc] init];
    loginReq.username = @"admin";
    loginReq.password = @"admin123";
    [NetManger postRequest:loginReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWLoginResp *loginResp = (BWLoginResp *)resp;
        
        [weakSelf saveUserInfomationWithDic:loginResp.item];
        
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        dele.window.rootViewController = [[HRootVC alloc] init];
            
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:self.view hudModel:MBProgressHUDModeText hide:YES];
       
    }];
}
- (void)saveUserInfomationWithDic:(NSDictionary *)userInfo
{
    
}
- (void)checkAction:(id)sender
{
    BWCheckTokenReq *loginReq = [[BWCheckTokenReq alloc] init];
    [NetManger getRequest:loginReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD showMessag:error.domain toView:self.view hudModel:MBProgressHUDModeText hide:YES];

    }];
}


#pragma mark - LazyLoad -
- (UIButton *)helpBtn
{
    if (!_helpBtn) {
        
        //多语言example
        NSString * tempStr = NSLocalizedString(@"test_label", nil);
        //多语言example
        
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn addTarget:self action:@selector(helpAction) forControlEvents:UIControlEventTouchUpInside];
        _helpBtn.backgroundColor = [UIColor redColor];
    }
    return _helpBtn;
}
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        [_headerView setImage:[UIImage imageNamed:@""]];
        _headerView.contentMode = UIViewContentModeScaleAspectFit;
        _headerView.backgroundColor = [UIColor blueColor];
    }
    return _headerView;
}
- (HInputView *)userView
{
    if (!_userView) {
        _userView = [[HInputView alloc] init];
    }
    return _userView;
}
- (HInputView *)pwView
{
    if (!_pwView) {
        _pwView = [[HInputView alloc] init];
    }
    return _pwView;
}
- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.backgroundColor = [UIColor greenColor];
    }
    return _selectImageView;
}
- (UILabel *)privacyLabel
{
    if (!_privacyLabel) {
        _privacyLabel = [[UILabel alloc] init];
        _privacyLabel.text = NSLocalizedString(@"privacyContent", nil);
        _privacyLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _privacyLabel;
}
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setBackgroundColor:[UIColor yellowColor]];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.text = @"Power by YOHAKUBUNKA, Inc.";
        _companyLabel.font = [UIFont systemFontOfSize:10];
    }
    return _companyLabel;
}
@end
