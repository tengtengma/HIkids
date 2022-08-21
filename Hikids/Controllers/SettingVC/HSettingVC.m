//
//  HSettingVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HSettingVC.h"

@interface HSettingVC ()

@end

@implementation HSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavigationView.backgroundImageView.backgroundColor = [UIColor blueColor];
    self.customNavigationView.titleLabel.text = @"设置";
    self.customNavigationView.desLabel.text = @"2022.08.21";
    self.customNavigationView.markImageView.backgroundColor = [UIColor greenColor];
}

@end
