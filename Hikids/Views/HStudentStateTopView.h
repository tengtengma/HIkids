//
//  HStudentStateTopView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^expandBlockAction)(void);


@interface HStudentStateTopView : UIView
@property (nonatomic, copy) expandBlockAction expandBlock;
@property (nonatomic, strong) NSArray *studentList;

- (void)loadSafeStyle;
- (void)loadDangerStyle;


@end

NS_ASSUME_NONNULL_END
