//
//  HStudentTopView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickExpandAction)(void);

@interface HStudentTopView : UIView
@property (nonatomic, copy) clickExpandAction expandBlock;
- (instancetype)init;
- (void)setDangerStyleWithStudentCount:(NSInteger)count;
- (void)setSafeStyleWithStudentCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
