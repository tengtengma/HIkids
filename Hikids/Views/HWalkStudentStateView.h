//
//  HWalkStudentStateView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WalkEndAction)(void);

@interface HWalkStudentStateView : UIView
@property (nonatomic, strong) NSArray *nomalArray;
@property (nonatomic, strong) NSArray *exceptArray;
@property (nonatomic, copy) WalkEndAction walkEndBlock;
- (void)tableReload;
@end

NS_ASSUME_NONNULL_END
