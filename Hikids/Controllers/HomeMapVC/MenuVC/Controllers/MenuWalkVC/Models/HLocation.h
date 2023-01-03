//
//  HLocation.h
//  Hikids
//
//  Created by 马腾 on 2022/10/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class HLocationInfo;

@interface HLocation : NSObject
@property (nonatomic, strong) NSArray *fenceArray;//围栏信息
@property (nonatomic, strong) HLocationInfo *locationInfo;

@end

@interface HLocationInfo : NSObject
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@end

NS_ASSUME_NONNULL_END
