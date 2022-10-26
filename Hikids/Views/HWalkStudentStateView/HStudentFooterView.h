//
//  HStudentFooterView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import <UIKit/UIKit.h>
#import "HStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface HStudentFooterView : UIView
@property (nonatomic, strong) UIView *lineView;

- (instancetype)init;
- (void)setupWithModel:(HStudent *)model;
@end

NS_ASSUME_NONNULL_END
