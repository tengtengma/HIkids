//
//  HBGRunManager.h
//  Hikids
//
//  Created by 马腾 on 2023/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HBGManager [HBGRunManager sharedManager]


@interface HBGRunManager : NSObject

+ (HBGRunManager *)sharedManager;

/**
 开启后台运行
 */
- (void)startBGRun;

/**
 关闭后台运行
 */
- (void)stopBGRun;

@end

NS_ASSUME_NONNULL_END
