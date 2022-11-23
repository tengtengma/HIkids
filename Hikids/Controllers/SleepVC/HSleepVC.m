//
//  HSleepVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HSleepVC.h"
#import "HMenuSleepVC.h"

@interface HSleepVC ()
@property (nonatomic, strong) HMenuSleepVC *menuSleepVC;

@end

@implementation HSleepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.menuSleepVC.view.frame = CGRectMake(0, SCREEN_HEIGHT- PAaptation_y(150), SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.menuSleepVC.view];
        

    
}

#pragma mark - LazyLoad -
- (HMenuSleepVC *)menuSleepVC
{
    if (!_menuSleepVC) {
        _menuSleepVC = [[HMenuSleepVC alloc] init];
    }
    return _menuSleepVC;
}
@end
