//
//  BaseNavigationVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "BaseNavigationVC.h"

@interface BaseNavigationVC ()

@end

@implementation BaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (@available(iOS 15.0, *)) {
            
        UINavigationBarAppearance * bar = [UINavigationBarAppearance new];
        bar.backgroundColor = myBlueColor;
        bar.backgroundEffect = nil;
        self.navigationBar.scrollEdgeAppearance = bar;
        self.navigationBar.standardAppearance = bar;
        
    }else{
        // Fallback on earlier versions
        self.interactivePopGestureRecognizer.delegate = (id)self;
        self.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:20.0],NSFontAttributeName,nil]];
        [self.navigationBar setBackgroundImage:[self imageWithColor:myBlueColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

    }

}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



@end
