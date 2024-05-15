//
//  HSetAlertAccurateVC.m
//  Hikids
//
//  Created by 马腾 on 2024/4/19.
//

#import "HSetAlertAccurateVC.h"
#import "BWSetWarnStrategyReq.h"
#import "BWSetWarnStrategyResp.h"

@interface HSetAlertAccurateVC ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIImageView *sliderBgView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UILabel *highLabel;
@property (nonatomic, strong) UILabel *normalLabel;
@property (nonatomic, strong) UILabel *lowLabel;
@property (nonatomic, strong) UIImageView *text_lineImageView;
@property (nonatomic, strong) UIImageView *instructionImageView;
@property (nonatomic, assign) NSInteger warnLevel;
@property (nonatomic, strong) NSString *warnName;

@end

@implementation HSetAlertAccurateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self createUI];
    
}

- (void)createUI
{
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-PAaptation_y(120));
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self createTitleView];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
   
    [self.bgView addSubview:self.sliderBgView];
    [self.sliderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(PAaptation_y(24));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(24));
        make.width.equalTo(self.bgView).offset(-PAdaptation_x(48));
        make.height.mas_equalTo(PAaptation_y(35));
    }];
    
    [self.bgView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.sliderBgView);
        make.width.equalTo(self.bgView).offset(-PAdaptation_x(48));
        make.height.mas_equalTo(PAaptation_y(32));
    }];
    
    [self.bgView addSubview:self.highLabel];
    [self.highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderBgView.mas_bottom).offset(PAaptation_y(5));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(18));
    }];
    
    [self.bgView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highLabel);
        make.centerX.equalTo(self.sliderBgView);
    }];
    
    [self.bgView addSubview:self.lowLabel];
    [self.lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highLabel);
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(18));
    }];
    
    [self.bgView addSubview:self.text_lineImageView];
    [self.text_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highLabel.mas_bottom).offset(PAaptation_y(10));
        make.left.equalTo(self.highLabel);
        make.right.equalTo(self.lowLabel.mas_right);
        make.height.mas_equalTo(PAaptation_y(14));
    }];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.warnLevel = [[user objectForKey:KEY_AlertLevel] integerValue];
    
    [self chooseImage:self.warnLevel];
    
    [self.bgView addSubview:self.instructionImageView];
    [self.instructionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.text_lineImageView.mas_bottom).offset(PAaptation_y(15));
        make.left.equalTo(self.text_lineImageView).offset(PAdaptation_x(10));
        make.right.equalTo(self.text_lineImageView.mas_right).offset(-PAdaptation_x(10));
        make.height.mas_equalTo(PAaptation_y(172));
    }];
    
    
    [self.bgView addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.instructionImageView.mas_bottom).offset(PAaptation_y(20));
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(PAdaptation_x(240));
        make.height.mas_equalTo(PAaptation_y(47));
    }];

}
- (void)createTitleView
{
    [self.view addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(PAaptation_y(38));
    }];
    
    [self.titleView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(_titleView).offset(PAdaptation_x(24));
    }];
    
    [self.titleView addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView);
        make.right.equalTo(self.titleView.mas_right).offset(-PAdaptation_x(24));
        make.width.mas_equalTo(PAdaptation_x(40));
        make.height.mas_equalTo(PAaptation_y(38));
    }];
}
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveAction:(id)sender
{
    NSLog(@"保存sound");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DefineWeakSelf;
    BWSetWarnStrategyReq *warnReq = [[BWSetWarnStrategyReq alloc] init];
    warnReq.strategyLevel = [NSNumber numberWithInteger:self.warnLevel];
    [NetManger putRequest:warnReq withSucessed:^(BWBaseReq *req, BWBaseResp *resp) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        BWSetWarnStrategyResp *warnResp = (BWSetWarnStrategyResp *)resp;
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:[NSNumber numberWithInteger:weakSelf.warnLevel] forKey:KEY_AlertLevel];
        [user synchronize];
        
        [MBProgressHUD showMessag:@"正常に保存" toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];

        NSLog(@"success");
            
    } failure:^(BWBaseReq *req, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessag:error.domain toView:weakSelf.view hudModel:MBProgressHUDModeText hide:YES];
    }];
}
#pragma mark - Slider Changed-
- (void)sliderValueChanged:(UISlider *)slider {
    // 滑块数值变化时的处理
    NSLog(@"Slider value changed: %f", slider.value);
    [slider setValue:roundf(slider.value) animated:NO];
    
    self.warnLevel = roundf(slider.value);
    
    [self chooseImage:self.warnLevel];

}
- (void)chooseImage:(NSInteger)index
{
    //处理换图片的事儿
    if (index == 1) {
        NSLog(@"1");
        [self.instructionImageView setImage:[UIImage imageNamed:@"5.png"]];
        self.warnName = @"高感度";

    }else if(index == 2){
        NSLog(@"2");
        [self.instructionImageView setImage:[UIImage imageNamed:@"4.png"]];
        self.warnName = @"やや高感度";

    }else if(index == 3){
        NSLog(@"3");
        [self.instructionImageView setImage:[UIImage imageNamed:@"3.png"]];
        self.warnName = @"普通";

    }else if(index == 4){
        NSLog(@"4");
        [self.instructionImageView setImage:[UIImage imageNamed:@"2.png"]];
        self.warnName = @"やや低感度";

    }else{
        NSLog(@"5");
        [self.instructionImageView setImage:[UIImage imageNamed:@"1.png"]];
        self.warnName = @"低感度";

    }
}
#pragma mark - Lazy Load -
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
        _titleLabel.text = @"アラート精度設定";
    }
    return _titleLabel;
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
- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        // 设置最小值和最大值
        _slider.minimumValue = 1; // 最小等级
        _slider.maximumValue = 5; // 最大等级
            
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSNumber *warnLevel = [user objectForKey:KEY_AlertLevel];
        if (warnLevel.integerValue == 0) {
            // 设置初始值
            _slider.value = 3; // 初始值
            self.warnLevel = 3;
        }else{
            self.warnLevel = warnLevel.integerValue;
            _slider.value = warnLevel.integerValue;
        }

        // 设置背景图片
        UIImage *clearImage = [UIImage new];
        [_slider setMinimumTrackImage:clearImage forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:clearImage forState:UIControlStateNormal];
        
        // 设置滑块图片
        [_slider setThumbImage:[UIImage imageNamed:@"thumbImage.png"] forState:UIControlStateNormal];
        // 添加事件监听
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        

    }
    return _slider;
}
- (UIImageView *)sliderBgView
{
    if (!_sliderBgView) {
        _sliderBgView = [[UIImageView alloc] init];
        [_sliderBgView setImage:[UIImage imageNamed:@"slide-back.png"]];
        _sliderBgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _sliderBgView;
}
- (UILabel *)highLabel
{
    if (!_highLabel) {
        _highLabel = [[UILabel alloc] init];
        _highLabel.font = [UIFont boldSystemFontOfSize:12];
        _highLabel.text = @"高感度";
    }
    return _highLabel;
}
- (UILabel *)normalLabel
{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc] init];
        _normalLabel.font = [UIFont boldSystemFontOfSize:12];
        _normalLabel.text = @"普通";
    }
    return _normalLabel;
}
- (UILabel *)lowLabel
{
    if (!_lowLabel) {
        _lowLabel = [[UILabel alloc] init];
        _lowLabel.font = [UIFont boldSystemFontOfSize:12];
        _lowLabel.text = @"低感度";
    }
    return _lowLabel;
}
- (UIImageView *)text_lineImageView
{
    if (!_text_lineImageView) {
        _text_lineImageView = [[UIImageView alloc] init];
        [_text_lineImageView setImage:[UIImage imageNamed:@"text-line.png"]];
    }
    return _text_lineImageView;
}
- (UIImageView *)instructionImageView
{
    if (!_instructionImageView) {
        _instructionImageView = [[UIImageView alloc] init];
    }
    return _instructionImageView;
}

@end
