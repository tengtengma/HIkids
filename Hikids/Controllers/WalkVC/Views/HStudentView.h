//
//  HStudentView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickStudentViewAction)(NSString *mId);

@interface HStudentView : UIView
@property (nonatomic, copy) clickStudentViewAction clickStudentBlock;

- (void)setupWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
