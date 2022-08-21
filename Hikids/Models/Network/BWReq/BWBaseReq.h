//
//  BWBaseReq.h
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BWBaseResp;
@class BWBaseReq;

@interface BWBaseReq : NSObject
@property (nonatomic, assign) NSTimeInterval timeOut;

- (NSURL *)url;

- (NSMutableDictionary *)getRequestParametersDictionary;

- (BOOL)isSecurityPolicy; //是否开启证书校验

- (BOOL)isCancel;//取消请求

@end
