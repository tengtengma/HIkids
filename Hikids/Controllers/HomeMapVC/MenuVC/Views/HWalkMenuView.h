//
//  HWalkMenuView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/30.
//

#import "HBaseMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@class HStudent;


typedef void(^walkEndAction)(void);
typedef void(^changeWalkStateAction)(UIButton *button);
typedef void(^showSelectMarkerBlock)(HStudent *student);


@interface HWalkMenuView : HBaseMenuView
@property (nonatomic, strong) walkEndAction walkEndBlock;
@property (nonatomic, strong) changeWalkStateAction changeWalkStateBlock;
@property (nonatomic, copy) showSelectMarkerBlock showSelectMarkerBlock;
@property (nonatomic, strong) UIButton *changeButton;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
