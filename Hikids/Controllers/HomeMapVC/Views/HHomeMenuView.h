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

@interface HHomeMenuView : HBaseMenuView
@property (nonatomic, strong) NSArray *safeList;
@property (nonatomic, strong) NSArray *exceptList;
@property (nonatomic, copy) showWalkMenuBlock showWalkMenu;
@property (nonatomic, copy) showSleepMenuBlock showSleepMenu;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
