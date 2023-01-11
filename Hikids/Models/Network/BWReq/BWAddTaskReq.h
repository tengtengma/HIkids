//
//  BWAddTaskReq.h
//  Hikids
//
//  Created by 马腾 on 2022/10/13.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWAddTaskReq : BWBaseReq
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *planTime;
@property (nonatomic, strong) NSString *destinationId;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSArray *assistants;
@property (nonatomic, strong) NSArray *kids;


- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
