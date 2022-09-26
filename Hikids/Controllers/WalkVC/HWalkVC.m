//
//  HWalkVC.m
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HWalkVC.h"

@interface HWalkVC ()

@end

@implementation HWalkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customNavigationView.titleLabel.text = @"散步";
    self.customNavigationView.desLabel.text = @"散步";
    self.customNavigationView.markImageView.backgroundColor = [UIColor redColor];
}



@end
