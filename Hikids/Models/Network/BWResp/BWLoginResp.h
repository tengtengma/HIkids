//
//  BWLoginResp.h
//  NStudyCenterDemo
//
//  Created by 马腾 on 2020/5/7.
//  Copyright © 2020 beiwaionline. All rights reserved.
//

#import "BWBaseResp.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWLoginResp : BWBaseResp

- (id)initWithJSONDictionary:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END
