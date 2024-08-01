//
//  HDtAlertVC.m
//  Hikids
//
//  Created by 马腾 on 2024/7/11.
//

#import "HDtAlertVC.h"

@interface HDtAlertVC ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, assign) NSInteger countdownValue;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@end

@implementation HDtAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.countdownValue = 30;
    
    NSString *str = [NSString stringWithFormat:@"戻る(%ld)s", (long)self.countdownValue];
    
    [self startCountdown];

    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(300));
        make.height.mas_equalTo(PAaptation_y(220));
    }];
    
    if ([self.source isEqualToString:@"walk_mode"]) {
        self.titleLabel.text = @"目的地から離れましたか?";
        self.desLabel.text = @"目的地から離れたことを検出しました。30秒後に自動的に散歩中モードに入りますが、よろしいですか？";
        
    }else{
        self.titleLabel.text = @"目的地に到着しましたか？";
        self.desLabel.text = @"目的地に到着したことを検出しました。30秒後に自動的に目的地モードに入りますが、よろしいですか？";
    }
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(PAaptation_y(25));
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.bgView);
    }];
    
    
    [self.bgView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(10));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(50));
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(50));
        
    }];
    
    [self.cancelBtn setTitle:str forState:UIControlStateNormal];
    [self.bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-PAaptation_y(25));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(130));
        make.height.mas_equalTo(PAaptation_y(45));
    }];
    
    [self.bgView addSubview:self.sureBtn];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn);
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(130));
        make.height.mas_equalTo(PAaptation_y(45));
    }];
    

}
- (void)startCountdown {
    
    DefineWeakSelf;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (weakSelf.countdownValue <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf safeAction:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *str = [NSString stringWithFormat:@"戻る(%ld)s", (long)self.countdownValue];
                [weakSelf.cancelBtn setTitle:str forState:UIControlStateNormal];

            });
            weakSelf.countdownValue--;
        }
    });

    dispatch_resume(timer);
}
- (void)cautionAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)safeAction:(id)sender
{
    NSLog(@"自动执行");
    if (self.entreBlock) {
        self.entreBlock();
    }
    [self dismissViewControllerAnimated:NO completion:nil];

}
#pragma mark - Lazy Load -
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 16;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 3;
        _desLabel.lineBreakMode = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _desLabel.textColor = BWColor(102.0, 102.0, 102.0, 1.0);
    }
    return _desLabel;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_cancelBtn setImage:[UIImage imageNamed:@"caution_btn.png"] forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        _cancelBtn.layer.cornerRadius = 24;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _cancelBtn.layer.borderWidth = 2.0;
        [_cancelBtn addTarget:self action:@selector(cautionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setImage:[UIImage imageNamed:@"dt_sure.png"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(safeAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _sureBtn;
}

@end
