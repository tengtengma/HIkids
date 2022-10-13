//
//  HRootVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HRootVC.h"
#import "BaseNavigationVC.h"
#import "HMapVC.h"
#import "HSleepVC.h"
#import "HWalkVC.h"


@interface HRootVC ()
@property (nonatomic, strong) HMapVC *mapVC;
@property (nonatomic, strong) HSleepVC *sleepVC;
@property (nonatomic, strong) HWalkVC *walkVC;
@property (nonatomic, strong) UIViewController *currentVC;
@end

@implementation HRootVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeVCAction:) name:@"changeVCNotification" object:nil];
    
    [self createUI];
    
}
- (void)createUI
{
    [self addChildViewController:self.mapVC];
    
    [self.view addSubview:self.mapVC.view];
    [self.mapVC didMoveToParentViewController:self];
    
    self.currentVC = self.mapVC;
    
    

}
- (void)changeVCAction:(NSNotification *)noti
{
    NSString *name = [noti.object safeObjectForKey:@"changeName"];
    if ([name isEqualToString:@"sleepVC"]) {
        [self replaceController:self.currentVC newController:self.sleepVC];
    }
    if ([name isEqualToString:@"walkVC"]) {
//        [self replaceController:self.currentVC newController:self.walkVC];
    }
    if ([name isEqualToString:@"mapVC"]) {
        [self replaceController:self.currentVC newController:self.mapVC];
    }
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:1.5f options:UIViewAnimationOptionTransitionNone animations:^{
            
    } completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }
        else{
            self.currentVC = oldController;
        }
    }];
}
#pragma mark - LazyLoad -
- (HMapVC *)mapVC
{
    if (!_mapVC) {
        _mapVC = [[HMapVC alloc] init];
    }
    return _mapVC;
}
- (HSleepVC *)sleepVC
{
    if (!_sleepVC) {
        _sleepVC = [[HSleepVC alloc] init];
    }
    return _sleepVC;
}
- (HWalkVC *)walkVC
{
    if (!_walkVC) {
        _walkVC = [[HWalkVC alloc] init];
    }
    return _walkVC;
}
@end
