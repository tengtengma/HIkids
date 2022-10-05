//
//  HMenuSleepVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HMenuSleepVC.h"

@implementation HMenuSleepVC

- (instancetype)init
{
    if (self = [super init]) {
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor redColor];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(PAdaptation_x(200));
            make.height.mas_equalTo(PAaptation_y(44));
        }];
       
    }
    return self;
}

- (void)closeAction
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeVCNotification" object:@{@"changeName":@"mapVC"}];

}
@end
