//
//  HStudentFooterView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import <UIKit/UIKit.h>
#import "HStudent.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum _FootTYPE
{
    FootTYPE_WALK = 0,
    FootTYPE_SLEEP = 1,
    FootTYPE_BUS = 2

}FootTYPE;
//展开
@interface HStudentFooterView : UIView
@property (nonatomic, assign) FootTYPE type;

- (instancetype)init;
- (void)setupWithModel:(HStudent *)model;
- (void)loadSafeStyle;
- (void)loadDangerStyle;
- (void)setNomalBorder;//设置普通边框
- (void)setLastCellBorder;//最后一个cell的边框
@end

NS_ASSUME_NONNULL_END
