//
//  HHomeMenuView.h
//  Hikids
//
//  Created by 马腾 on 2022/12/29.
//

#import "HBaseMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHomeMenuView : HBaseMenuView
@property (nonatomic, strong) NSArray *safeList;
@property (nonatomic, strong) NSArray *exceptList;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
