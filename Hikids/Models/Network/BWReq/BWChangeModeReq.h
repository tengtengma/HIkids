//
//  BWChangeModeReq.h
//  Hikids
//
//  Created by 马腾 on 2024/7/9.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWChangeModeReq : BWBaseReq
@property (nonatomic, strong) NSString *tId;
@property (nonatomic, assign) long modeCode; //模式code，0散步，1目的地，2乘车，进入目的地传1，退出目的地和切换步行模式传0，进入乘车模式传2

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
