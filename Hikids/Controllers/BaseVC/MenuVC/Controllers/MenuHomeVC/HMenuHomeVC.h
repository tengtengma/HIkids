//
//  HMenuHomeVC.h
//  Hikids
//
//  Created by 马腾 on 2022/9/26.
//

#import "HBaseMenuVC.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^showSleepMenuBlock)(void);
typedef void(^showWalkMenuBlock)(void);

@interface HMenuHomeVC : HBaseMenuVC
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) NSArray *nomalArray;
@property (nonatomic, strong) NSArray *exceptArray;
@property (nonatomic, copy) showWalkMenuBlock showWalkMenu;
@property (nonatomic, copy) showSleepMenuBlock showSleepMenu;


- (void)tableReload;
@end

NS_ASSUME_NONNULL_END
