//
//  HStudentStateInfoView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HStudent;

typedef void(^closeAction)(void);


@interface HStudentStateInfoView : UIView
@property (nonatomic, copy) closeAction closeBlock;

- (void)setInfomationWithModel:(HStudent *)student;
@end

NS_ASSUME_NONNULL_END
