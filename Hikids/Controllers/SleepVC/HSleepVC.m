//
//  HSleepVC.m
//  Hikids
//
//  Created by 马腾 on 2022/8/21.
//

#import "HSleepVC.h"

@interface HSleepVC ()

@end

@implementation HSleepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavigationView.backgroundImageView.backgroundColor = [UIColor blueColor];
    self.customNavigationView.titleLabel.text = @"午睡";
    self.customNavigationView.desLabel.text = @"2022.08.21";
    self.customNavigationView.markImageView.backgroundColor = [UIColor greenColor];
}


@end
