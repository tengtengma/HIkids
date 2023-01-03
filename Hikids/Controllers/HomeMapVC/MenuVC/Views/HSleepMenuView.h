//
//  HSleepMenuView.h
//  Hikids
//
//  Created by 马腾 on 2023/1/3.
//

#import "HBaseMenuView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^sleepEndAction)(void);


@interface HSleepMenuView : HBaseMenuView
@property (nonatomic, strong) NSArray *safeList;
@property (nonatomic, strong) NSArray *exceptList;
@property (nonatomic, strong) sleepEndAction sleepEndBlock;

- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
