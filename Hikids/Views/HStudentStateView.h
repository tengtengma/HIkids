//
//  HStudentStateView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^closeStateViewAction)(void);

@interface HStudentStateView : UIView
@property (nonatomic, copy) closeStateViewAction closeBlock;
@property (nonatomic, assign) BOOL isSafe;
@property (nonatomic, strong) NSArray *array;

- (instancetype)init;
- (void)tableReload;

@end

NS_ASSUME_NONNULL_END
