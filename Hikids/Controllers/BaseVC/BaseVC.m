//
//  BaseVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
