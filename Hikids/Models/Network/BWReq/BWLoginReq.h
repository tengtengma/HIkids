//
//  BWLoginReq.h
//  NStudyCenterDemo
//
//  Created by 马腾 on 2020/5/7.
//  Copyright © 2020 beiwaionline. All rights reserved.
//

#import "BWBaseReq.h"

NS_ASSUME_NONNULL_BEGIN

@interface BWLoginReq : BWBaseReq
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;
@end

NS_ASSUME_NONNULL_END
