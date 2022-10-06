//
//  HStudentView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface HStudentView : UIView
- (void)setupWithModel:(id)model;
- (void)cellSelected;
- (void)cellNomal;
@end

NS_ASSUME_NONNULL_END
