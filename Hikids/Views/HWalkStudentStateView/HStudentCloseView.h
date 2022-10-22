//
//  HStudentCloseView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/22.
//

#import <UIKit/UIKit.h>
#import "HStudentTopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickExpandAction)(void);

@interface HStudentCloseView : UIView
@property (nonatomic, copy) clickExpandAction expandBlock;
@property (nonatomic, strong) HStudentTopView *topView;

- (instancetype)initWithArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
