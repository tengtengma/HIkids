//
//  HWalkStudentStateView.h
//  Hikids
//
//  Created by 马腾 on 2022/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WalkEndAction)(void); //结束散步模式block
typedef void(^clickSmallCardAction)(void);
typedef void(^clickGpsAction)(void);


@interface HWalkStudentStateView : UIView
@property (nonatomic,assign) float topH;//上滑后距离顶部的距离
@property (nonatomic, strong) NSArray *nomalArray;
@property (nonatomic, strong) NSArray *exceptArray;
@property (nonatomic, copy) WalkEndAction walkEndBlock;
@property (nonatomic, copy) clickSmallCardAction clickSmallCardViewBlock;
@property (nonatomic, copy) clickGpsAction clickGpsBlock;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)goCenter;
- (void)tableReload;
@end

NS_ASSUME_NONNULL_END
