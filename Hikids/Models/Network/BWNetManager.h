//
//  BWNetManager.h
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWBaseReq.h"
#import "BWBaseResp.h"

#define NetManger [BWNetManager sharedInstances]

@interface BWNetManager : NSObject

+ (BWNetManager *) sharedInstances;

- (void)postRequest:(BWBaseReq*)request
       withSucessed:(void (^)(BWBaseReq *req, BWBaseResp *resp))success
            failure:(void (^)(BWBaseReq *req, NSError *error))failure;

- (void)getRequest:(BWBaseReq*)request
       withSucessed:(void (^)(BWBaseReq *req, BWBaseResp *resp))success
            failure:(void (^)(BWBaseReq *req, NSError *error))failure;

- (void)putRequest:(BWBaseReq*)request
       withSucessed:(void (^)(BWBaseReq *req, BWBaseResp *resp))success
            failure:(void (^)(BWBaseReq *req, NSError *error))failure;
//- (void)downloadRequest:(BWBaseReq *)request
//               progress:(void (^)(float progress , NSString *taskId))progressBlock
//      completionHandler:(void (^)(BWBaseResp *response, NSURL *filePath, NSError *error))completionBlock;

@end
