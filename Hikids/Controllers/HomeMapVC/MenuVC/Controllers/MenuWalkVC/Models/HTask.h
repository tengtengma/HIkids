//
//  HWalkTask.h
//  Hikids
//
//  Created by 马腾 on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTask : NSObject
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *tId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *modeCode;
@property (nonatomic, strong) NSString *planTime;
@property (nonatomic, strong) NSString *assistants;
@property (nonatomic, strong) NSString *kids;
@property (nonatomic, strong) NSString *destinationId;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *endType;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSNumber *warnExceptionTimes;
@property (nonatomic, strong) NSNumber *warnStopInterval;
@property (nonatomic, strong) NSNumber *warnStrategyLevel;
@property (nonatomic, strong) NSString *destinationFence;




@end

NS_ASSUME_NONNULL_END
