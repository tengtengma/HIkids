//
//  HTitleView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTitleView : UIView
- (void)setupWithModel:(id)model;
- (void)cellSelected;
- (void)cellNomal;
@end

NS_ASSUME_NONNULL_END
