//
//  HWalkStudentStateView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WalkEndAction)(void);
typedef void(^ShowOrHideWalkStateView)(void);
typedef void(^CloseExpandAction)(void);

@interface HWalkStudentStateView : UIView
@property (nonatomic, strong) NSArray *nomalArray;
@property (nonatomic, strong) NSArray *exceptArray;
@property (nonatomic, copy) WalkEndAction walkEndBlock;
@property (nonatomic, copy) ShowOrHideWalkStateView ShowOrHideWalkStateViewBlock;
@property (nonatomic, copy) CloseExpandAction closeExpandBlock;

- (void)tableReload;
@end

NS_ASSUME_NONNULL_END
