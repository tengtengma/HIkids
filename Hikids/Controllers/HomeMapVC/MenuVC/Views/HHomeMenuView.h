//
//  HHomeMenuView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@class HStudent;

typedef void(^showSleepMenuBlock)(void);
typedef void(^showWalkMenuBlock)(void);
typedef void(^showSelectMarkerBlock)(HStudent *student);

@interface HHomeMenuView : HBaseMenuView
@property (nonatomic, copy) showWalkMenuBlock showWalkMenu;
@property (nonatomic, copy) showSleepMenuBlock showSleepMenu;
@property (nonatomic, copy) showSelectMarkerBlock showSelectMarkerBlock;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
