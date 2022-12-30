//
//  HStudentFooterView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import <UIKit/UIKit.h>
#import "HStudent.h"

NS_ASSUME_NONNULL_BEGIN
//展开
@interface HStudentFooterView : UIView

- (instancetype)init;
- (void)setupWithModel:(HStudent *)model;
- (void)setNomalBorder;
- (void)setLastCellBorder;
@end

NS_ASSUME_NONNULL_END
