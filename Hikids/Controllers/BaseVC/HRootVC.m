//
//  HRootVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HRootVC.h"
#import "BaseNavigationVC.h"
#import "HTodayVC.h"
#import "HSleepVC.h"
#import "HWalkVC.h"
#import "HReportVC.h"
#import "HSettingVC.h"

#define Nomal_FontSize 8.0
#define Select_FontSize 8.0
#define Nomal_Color [UIColor clearColor]
#define Select_Color [UIColor clearColor]


@interface HRootVC ()<UITabBarControllerDelegate>
@property (nonatomic, strong) NSMutableArray *viewList;

@end

@implementation HRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];
    
}
- (void)setupTabbar
{
    NSArray *list = @[@{@"name":@"HTodayVC",@"nomal":@"tab_today.png",@"select":@"tab_today_active.png",@"title":@"今日"},
        @{@"name":@"HSleepVC",@"nomal":@"course_tab.png",@"select":@"course_tab_active.png",@"title":@"午睡"},
        @{@"name":@"HWalkVC",@"nomal":@"course_tab.png",@"select":@"course_tab_active.png",@"title":@"散步"},
        @{@"name":@"HReportVC",@"nomal":@"course_tab.png",@"select":@"course_tab_active.png",@"title":@"报告"},
        @{@"name":@"HSettingVC",@"nomal":@"course_tab.png",@"select":@"course_tab_active.png",@"title":@"管理"}];
    
    for (NSDictionary *dic in list) {
        NSString *name = [dic safeObjectForKey:@"name"];
        NSString *nomal = [dic safeObjectForKey:@"nomal"];
        NSString *select = [dic safeObjectForKey:@"select"];
        NSString *title = [dic safeObjectForKey:@"title"];
        [self createTabbarItemWithNomalImage:nomal SelectImage:select withName:title byVCName:name];
    }

    self.viewControllers = self.viewList;
    self.tabBar.translucent = NO;
    self.delegate = self;
    
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance * bar2 = [UITabBarAppearance new];
        bar2.backgroundColor = [UIColor whiteColor];
        bar2.backgroundEffect = nil;
        self.tabBar.scrollEdgeAppearance = bar2;
        self.tabBar.standardAppearance = bar2;
        
    }else{
        self.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBar.barStyle = UIBarStyleDefault;
    }
}
- (void)createTabbarItemWithNomalImage:(NSString *)nomalImgName SelectImage:(NSString *)selectImgName withName:(NSString *)name byVCName:(NSString *)vcName
{
    // 默认
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:Nomal_FontSize];
    attrs[NSForegroundColorAttributeName] = Nomal_Color;
    
    // 选中
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:Select_FontSize];
    attrSelected[NSForegroundColorAttributeName] = Select_Color;
    
    UIImage *recImg = [[UIImage imageNamed:nomalImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selRecImg = [[UIImage imageNamed:selectImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.title = name;
    
    BaseNavigationVC *nav = [[BaseNavigationVC alloc] initWithRootViewController:vc];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:name image:recImg selectedImage:selRecImg];
    [nav.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [nav.tabBarItem setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    
    [self.viewList addObject:nav];
    
    
}
#pragma mark - UITabbarControllerDelegate -
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"点击了==== %@",item.title);
}

#pragma mark - LazyLoad -
- (NSMutableArray *)viewList
{
    if (!_viewList) {
        _viewList = [[NSMutableArray alloc] init];
    }
    return _viewList;
}
@end
