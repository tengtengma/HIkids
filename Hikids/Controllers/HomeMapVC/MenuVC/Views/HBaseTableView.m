//
//  HBaseTableView.m
//  Hikids
//
//  Created by 马腾 on 2023/2/3.
//

#import "HBaseTableView.h"

@interface HBaseTableView()<UIGestureRecognizerDelegate>

@end

@implementation HBaseTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
