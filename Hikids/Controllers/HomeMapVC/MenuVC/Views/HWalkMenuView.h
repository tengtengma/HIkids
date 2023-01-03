//
//  HWalkMenuView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/30.
//

#import "HBaseMenuView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^walkEndAction)(void);

@interface HWalkMenuView : HBaseMenuView
@property (nonatomic, strong) NSArray *safeList;
@property (nonatomic, strong) NSArray *exceptList;
@property (nonatomic, strong) walkEndAction walkEndBlock;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
