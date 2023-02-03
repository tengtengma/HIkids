//
//  HBaseScrollView.m
//  Hikids
//
//  Created by 马腾 on 2023/2/3.
//

#import "HBaseScrollView.h"

@implementation HBaseScrollView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        
        return nil;
    }
    return hitView;
}

@end
