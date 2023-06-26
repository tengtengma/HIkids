//
//  HWalkDownTimeView.m
//  Hikids
//
//  Created by 马腾 on 2023/6/2.
//

#import "HWalkDownTimeView.h"

@interface HWalkDownTimeView()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation HWalkDownTimeView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 8.0;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"提示";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(PAaptation_y(10));
            make.centerX.equalTo(self);
        }];
        
        self.desLabel = [[UILabel alloc] init];
        self.desLabel.textAlignment = NSTextAlignmentCenter;
        self.desLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.desLabel];
        
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(PAaptation_y(10));
            make.left.equalTo(self).offset(PAdaptation_x(10));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = BWColor(238, 224, 215, 1);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-PAaptation_y(45));
            make.left.equalTo(self);
            make.width.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"いいえ" forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-PAaptation_y(45));
            make.left.equalTo(self);
            make.right.equalTo(self.mas_centerX);
            make.height.mas_equalTo(PAaptation_y(45));
        }];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.sureBtn setTitle:@"はい(10)" forState:UIControlStateNormal];
        [self.sureBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sureBtn];
        
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cancelBtn);
            make.left.equalTo(cancelBtn.mas_right);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(PAaptation_y(45));
        }];
        
        
    }
    return self;
}
- (void)setupContent:(NSString *)content
{
    self.desLabel.text = content;
    [self startCutDownTimeActionWithButton:self.sureBtn];

}
- (void)cancelAction
{
    dispatch_cancel(self.timer);
    [self removeFromSuperview];

}
- (void)sureAction
{
    if (self.sureBlock) {
        //(6)
//        dispatch_cancel(self.timer);
        self.timer = nil;
        self.sureBlock();
        [self removeFromSuperview];
    }
}
- (void)startCutDownTimeActionWithButton:(UIButton *)button
{
    DefineWeakSelf;
    __block NSInteger second = 15;
       //(1)
       dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       //(2)
       self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
       //(3)
       dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
       //(4)
       dispatch_source_set_event_handler(self.timer, ^{
           dispatch_async(dispatch_get_main_queue(), ^{
               if (second == 0) {
                   [weakSelf sureAction];
               } else {
                   [button setTitle:[NSString stringWithFormat:@"はい(%ld)",second] forState:UIControlStateNormal];
                   second--;
               }
           });
       });
       //(5)
       dispatch_resume(self.timer);
}
@end
