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
#import "TPKeyboardAvoidingScrollView.h"

@interface HLoginVC ()<UITextFieldDelegate>
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *myScrollView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *privacyLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) HInputView *userView;
@property (nonatomic, strong) HInputView *pwView;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isAgree;



@end

@implementation HLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
- (void)createUI
{
    [self.view addSubview:self.myScrollView];
    [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.myScrollView addSubview:self.helpBtn];
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(PAaptation_y(59));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    [self.myScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.helpBtn.mas_bottom).offset(PAaptation_y(157));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(290));
        make.height.mas_equalTo(PAaptation_y(58));
    }];
    
    self.userView.textField.placeholder = @"メールアドレス";
    [self.myScrollView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(PAaptation_y(37.5));
        make.left.equalTo(self.view).offset(PAdaptation_x(50));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(50));
        make.height.mas_equalTo(PAaptation_y(56));
    }];
    
    self.pwView.textField.placeholder = @"パスワード";
    [self.myScrollView addSubview:self.pwView];
    [self.pwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userView.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.view).offset(PAdaptation_x(50));
        make.right.equalTo(self.view.mas_right).offset(-PAdaptation_x(50));
        make.height.mas_equalTo(PAaptation_y(56));
    }];
    
    UIImage *selectImg = [UIImage imageNamed:@"icon_check.png"];
    
    [self.myScrollView addSubview:self.selectImageView];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwView.mas_bottom).offset(PAaptation_y(18));
        make.left.equalTo(self.view).offset(PAdaptation_x(122));
        make.width.mas_equalTo(selectImg.size.width);
        make.height.mas_equalTo(selectImg.size.height);
    }];
    
    [self.myScrollView addSubview:self.privacyLabel];
    [self.privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.selectImageView);
        make.left.equalTo(self.selectImageView.mas_right).offset(PAdaptation_x(4));
    }];
    
    [self.myScrollView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.privacyLabel.mas_bottom).offset(PAaptation_y(16));
        make.left.equalTo(self.pwView);
        make.width.equalTo(self.pwView);
        make.height.equalTo(self.pwView);
    }];
    
    [self.myScrollView addSubview:self.companyLabel];
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-PAaptation_y(37));
        make.centerX.equalTo(self.view);
    }];
    
    self.userView.textField.text = @"admin";
    self.pwView.textField.text = @"admin123";
    

}

- (void)loginAction:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    DefineWeakSelf;
    BWLoginReq *loginReq = [[BWLoginReq alloc] init];
    loginReq.username = self.userView.textField.text;
    loginReq.password = self.pwView.textField.text;
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
- (void)autoLoginAction
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:KEY_UserName];
    NSString *passWord = [user objectForKey:KEY_Password];
    
    DefineWeakSelf;
    BWLoginReq *loginReq = [[BWLoginReq alloc] init];
    loginReq.username = userName;
    loginReq.password = passWord;
    [NetManger postRequest:loginReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
        BWLoginResp *loginResp = (BWLoginResp *)resp;
        
        [weakSelf saveUserInfomationWithDic:loginResp.item];
            
    } failure:^(BWBaseReq *req, NSError *error) {
       
    }];
}
- (void)saveUserInfomationWithDic:(NSDictionary *)userInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.userView.textField.text forKey:KEY_UserName];
    [user setObject:self.pwView.textField.text forKey:KEY_Password];
    [user synchronize];
}
- (void)selectAction:(UITapGestureRecognizer *)tap
{
    self.isSelected = !self.isSelected;

//    [self checkLoginState];

    if (self.isSelected) {
        [self.selectImageView setImage:[UIImage imageNamed:@"icon_checked.png"]];
        self.loginBtn.enabled = YES;
        [self.loginBtn setImage:[UIImage imageNamed:@"btn_login_available.png"] forState:UIControlStateNormal];
    }else{
        [self.selectImageView setImage:[UIImage imageNamed:@"icon_check.png"]];
        self.loginBtn.enabled = NO;
        [self.loginBtn setImage:[UIImage imageNamed:@"btn_login_unavailable.png"] forState:UIControlStateNormal];
    }
}
//- (void)checkLoginState
//{
//    if (self.isSelected && self.userView.textField.text.length != 0 && self.pwView.textField.text.length != 0) {
//        self.loginBtn.enabled = YES;
//        [self.loginBtn setImage:[UIImage imageNamed:@"btn_login_available.png"] forState:UIControlStateNormal];
//    }else{
//        self.loginBtn.enabled = NO;
//        [self.loginBtn setImage:[UIImage imageNamed:@"btn_login_unavailable.png"] forState:UIControlStateNormal];
//
//    }
//}
- (void)checkAction:(id)sender
{
    BWCheckTokenReq *loginReq = [[BWCheckTokenReq alloc] init];
    [NetManger getRequest:loginReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD showMessag:error.domain toView:self.view hudModel:MBProgressHUDModeText hide:YES];

    }];
}
- (void)helpAction:(id)sender
{
    NSLog(@"点击了help按钮");
}

#pragma mark - LazyLoad -
- (TPKeyboardAvoidingScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[TPKeyboardAvoidingScrollView alloc]init];
        _myScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _myScrollView;
}
- (UIButton *)helpBtn
{
    if (!_helpBtn) {
        
        //多语言example
        NSString * tempStr = NSLocalizedString(@"test_label", nil);
        //多语言example
        
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _helpBtn;
}
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        [_headerView setImage:[UIImage imageNamed:@"logo.png"]];
        _headerView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _headerView;
}
- (HInputView *)userView
{
    if (!_userView) {
        _userView = [[HInputView alloc] initWithBGImage:[UIImage imageNamed:@"TextArea_Login.png"] IconImg:[UIImage imageNamed:@"icon_mail.png"]];
        _userView.textField.delegate = self;
        
    }
    return _userView;
}
- (HInputView *)pwView
{
    if (!_pwView) {
        _pwView = [[HInputView alloc] initWithBGImage:[UIImage imageNamed:@"TextArea_Login.png"] IconImg:[UIImage imageNamed:@"icon_password.png"]];
        _pwView.textField.delegate = self;
        _pwView.textField.secureTextEntry = YES;
    }
    return _pwView;
}
- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        _selectImageView.userInteractionEnabled = YES;
        [_selectImageView setImage:[UIImage imageNamed:@"icon_check.png"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAction:)];
        [_selectImageView addGestureRecognizer:tap];
    }
    return _selectImageView;
}
- (UILabel *)privacyLabel
{
    if (!_privacyLabel) {
        _privacyLabel = [[UILabel alloc] init];
//        _privacyLabel.text = NSLocalizedString(@"privacyContent", nil);
        _privacyLabel.text = @"利用規約に同意する";
        _privacyLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _privacyLabel;
}
- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.enabled = NO;
        [_loginBtn setImage:[UIImage imageNamed:@"btn_login_unavailable.png"] forState:UIControlStateNormal];
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
