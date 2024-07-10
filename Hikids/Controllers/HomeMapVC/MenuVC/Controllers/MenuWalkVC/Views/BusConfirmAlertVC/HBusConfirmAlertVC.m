//
//  HBusConfirmAlertView.m
//  Hikids
//
//  Created by 马腾 on 2024/7/9.
//

#import "HBusConfirmAlertVC.h"

@interface HBusConfirmAlertVC()
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *startBtn;


@end

@implementation HBusConfirmAlertVC

- (instancetype)initWithType:(NSString *)type
{
    if (self = [super init]) {
        
        self.type = type;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(PAdaptation_x(300));
        make.height.mas_equalTo(PAaptation_y(275));
    }];
    
    [self.bgView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(PAaptation_y(25));
        make.centerX.equalTo(self.bgView);
        make.width.mas_equalTo(PAdaptation_x(60));
        make.height.mas_equalTo(PAaptation_y(62));
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(PAaptation_y(15));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(70));
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(70));
    }];
    
    [self.bgView addSubview:self.desLabel];
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(PAaptation_y(15));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(20));
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(20));
    }];
    
    [self.bgView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-PAaptation_y(30));
        make.left.equalTo(self.bgView).offset(PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(130));
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    [self.bgView addSubview:self.startBtn];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cancelBtn);
        make.right.equalTo(self.bgView.mas_right).offset(-PAdaptation_x(15));
        make.width.mas_equalTo(PAdaptation_x(130));
        make.height.mas_equalTo(PAaptation_y(40));
    }];
    
    if ([self.type isEqualToString:@"bus"]) {
        
        [self.headerView setImage:[UIImage imageNamed:@"alert_bus.png"]];
        self.titleLabel.text = @"乗車モードを\n有効にしますか？";
        self.desLabel.text = @"バッテリー節約のため、乗車モード中はアラート機能が一時停止します。";
        [self.cancelBtn setImage:[UIImage imageNamed:@"bus_cancel.png"] forState:UIControlStateNormal];
        [self.startBtn setImage:[UIImage imageNamed:@"bus_start.png"] forState:UIControlStateNormal];


    }else{
        [self.headerView setImage:[UIImage imageNamed:@"footprint.png"]];
        self.titleLabel.text = @"乗車モードを解除して、\n散歩モードに戻しますか？";
        self.desLabel.text = @"散歩モードに戻ると、アラート機能が再開されます。";
        [self.cancelBtn setImage:[UIImage imageNamed:@"bus_cancel.png"] forState:UIControlStateNormal];
        [self.startBtn setImage:[UIImage imageNamed:@"walk_end.png"] forState:UIControlStateNormal];
    }
    

}
- (void)cancelAction:(id)sender
{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}
- (void)startAction:(id)sender
{
    if (self.confirmBlock) {
        self.confirmBlock(self.type);
    }
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
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
    }
    return _headerView;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.numberOfLines = 2;
        _desLabel.lineBreakMode = 0;
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.font = [UIFont boldSystemFontOfSize:12.0];
        _desLabel.textColor = BWColor(102.0, 102.0, 102.0, 1.0);
    }
    return _desLabel;
}
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _startBtn;
}
@end
