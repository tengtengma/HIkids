//
//  HBusMenuView.h
//  Hikids
//
//  Created by 马腾 on 2024/7/10.
//

#import "HBaseMenuView.h"

NS_ASSUME_NONNULL_BEGIN
@class HStudent;
typedef void(^showSelectMarkerBlock)(HStudent *student);

@interface HBusMenuView : HBaseMenuView
@property (nonatomic, copy) showSelectMarkerBlock showSelectMarkerBlock;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
