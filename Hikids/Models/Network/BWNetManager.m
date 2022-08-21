//
//  BWNetManager.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWNetManager.h"
#import "BWBaseReq.h"
#import "BWBaseResp.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>

#define DefineWeakSelf __weak __typeof(self) weakSelf = self

@interface BWNetManager()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, assign) NSInteger netState;

-(NSString *)replaceClassName:(id)reqClass;
- (void)sucessedWithRequest:(BWBaseReq *)request responseObject:(id)responseObj withBlock:(void (^)(BWBaseReq *, BWBaseResp *))success failure:(void (^)(BWBaseReq *, NSError *))failure;
- (void)failedWithRequest:(BWBaseReq *)request error:(NSError *)error withBlock:(void (^)(BWBaseReq *, NSError *))failure;

@end

@implementation BWNetManager

+ (BWNetManager *)sharedInstances
{
    static BWNetManager *netManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[BWNetManager alloc] init];
    });
    return netManager;
}
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 45;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    return _manager;
}

- (void)getRequest:(BWBaseReq *)request withSucessed:(void (^)(BWBaseReq *, BWBaseResp *))success failure:(void (^)(BWBaseReq *, NSError *))failure
{
    DefineWeakSelf;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",request.url];
    
    //网络请求安全策略
    if (request.isSecurityPolicy) {
        AFSecurityPolicy *securityPolicy;
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.allowInvalidCertificates = false;
        securityPolicy.validatesDomainName = YES;
        self.manager.securityPolicy = securityPolicy;
    } else {
        self.manager.securityPolicy.allowInvalidCertificates = true;
        self.manager.securityPolicy.validatesDomainName = false;
    }
    //监听网络状态
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
        
        weakSelf.netState = status;
    }];
    
   
    NSString *jwToken = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_Jwtoken];
    
    if (jwToken.length > 0) {
    
        NSString *jwtToken = [NSString stringWithFormat:@"Bearer %@",jwToken];
        
        [self.manager.requestSerializer setValue:jwtToken forHTTPHeaderField:@"BwolAuth"];
    }
    NSMutableDictionary *parameters = [request getRequestParametersDictionary];
    NSString *sign = [self getSignStr:parameters];
    if (sign) {
        [parameters setObject:sign forKey:@"sign"];
    }
    
    NSLog(@"\nRequest url : %@\nRequest body : %@",[request.url absoluteString],parameters);

    [self.manager GET:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSLog(@"GET请求完整地址：%@",task.response.URL.absoluteString);
        
        [weakSelf sucessedWithRequest:request responseObject:responseObject withBlock:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf failedWithRequest:request error:error withBlock:failure];
    }];
    
}
- (void)postRequest:(BWBaseReq *)request withSucessed:(void (^)(BWBaseReq *, BWBaseResp *))success failure:(void (^)(BWBaseReq *, NSError *))failure
{
    DefineWeakSelf;
    
    NSString *urlString = [NSString stringWithFormat:@"%@",request.url];
    
    //网络请求安全策略
    if (request.isSecurityPolicy) {
        AFSecurityPolicy *securityPolicy;
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.allowInvalidCertificates = false;
        securityPolicy.validatesDomainName = YES;
        self.manager.securityPolicy = securityPolicy;
    } else {
        self.manager.securityPolicy.allowInvalidCertificates = true;
        self.manager.securityPolicy.validatesDomainName = false;
    }

    //监听网络状态
    [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
        
        weakSelf.netState = status;
    }];
    
    NSString *jwToken = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_Jwtoken];
    
    if (jwToken.length > 0) {
    
        NSString *jwtToken = [NSString stringWithFormat:@"Bearer %@",jwToken];
        
        [self.manager.requestSerializer setValue:jwtToken forHTTPHeaderField:@"BwolAuth"];
    }
    
    NSMutableDictionary *parameters = [request getRequestParametersDictionary];
    NSString *sign = [self getSignStr:parameters];
    if (sign) {
        [parameters setObject:sign forKey:@"sign"];
    }
    
    NSLog(@"\nRequest url : %@\nRequest body : %@",[request.url absoluteString],parameters);
    
    [self.manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        [weakSelf sucessedWithRequest:request responseObject:responseObject withBlock:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [weakSelf failedWithRequest:request error:error withBlock:failure];
        
    }];
}

/*
- (void)downloadRequest:(BWDownloadRequest *)request progress:(void (^)(float progress, NSString *taskId))progressBlock completionHandler:(void (^)(BWBaseResp *, NSURL *, NSError *))completionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //设置网络请求序列化对象
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"test" forHTTPHeaderField:@"requestHeader"];
    requestSerializer.timeoutInterval = 60;
    requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //设置返回数据序列化对象
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    //网络请求安全策略
//    if (true) {
//        AFSecurityPolicy *securityPolicy;
//        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//        securityPolicy.allowInvalidCertificates = false;
//        securityPolicy.validatesDomainName = YES;
//        manager.securityPolicy = securityPolicy;
//    } else {
//        manager.securityPolicy.allowInvalidCertificates = true;
//        manager.securityPolicy.validatesDomainName = false;
//    }
    //是否允许请求重定向
//    if (true) {
//        [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
//            if (response) {
//                return nil;
//            }
//            return request;
//        }];
//    }
    //监听网络状态
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
    }];
    [manager.reachabilityManager startMonitoring];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
        NSLog(@"下载进度:%lld",downloadProgress.completedUnitCount);
        
        progressBlock(downloadProgress.completedUnitCount,[NSString stringWithFormat:@"%ld",downloadTask.taskIdentifier]);
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        NSLog(@"fileURL:%@",[fileURL absoluteString]);
        return fileURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
        
        completionBlock(response,filePath,error);
    }];
    [downloadTask resume];
    
}
*/

#pragma mark - PrivacyMethod -

- (void)sucessedWithRequest:(BWBaseReq *)request responseObject:(id)responseObj withBlock:(void (^)(BWBaseReq *, BWBaseResp *))success failure:(void (^)(BWBaseReq *, NSError *))failure
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObj options:NSJSONReadingMutableLeaves error:nil];
    
    BWBaseResp *response = [[NSClassFromString([self replaceClassName:request]) alloc] initWithJSONDictionary:json];
    
    if (ResponseCode_Success == response.errorCode) {
        
        NSLog(@"\nRequestURL : %@\nResponseCode : %d\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,response.errorCode,response.errorMessage,json);

        success(request,response);
        
        
    }else{
        
        NSLog(@"ERROR!!\n  \nRequestURL : %@\nResponseCode : %d\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,response.errorCode,response.errorMessage,json);

        if (response.errorMessage != nil) {
            NSError * error = [NSError errorWithDomain:response.errorMessage code:response.errorCode userInfo:nil];
            
            
            failure(request,error);
        }
        
    }
}
- (void)failedWithRequest:(BWBaseReq *)request error:(NSError *)error withBlock:(void (^)(BWBaseReq *, NSError *))failure
{

    NSDictionary *errorDic = error.userInfo;
    NSString *errorStr = [errorDic safeObjectForKey:@"NSLocalizedDescription"];
    if([errorStr isEqualToString:@"Request failed: unauthorized (401)"]){
        
        NSError * error  = [NSError errorWithDomain:@"您的登录信息已过期，请重新登录" code:-1 userInfo:nil];

        //token失效
        [[NSNotificationCenter defaultCenter] postNotificationName:@"invalidToken" object:nil];
               
        failure(request,error);

        return;
    }
    
    if (_netState == -1 || _netState == 0) {
        NSError * netError = [NSError errorWithDomain:@"当前网络不可用，请检查后再试" code:-1 userInfo:nil];
        failure(request,netError);
        
    }else{
        NSError * netError = [NSError errorWithDomain:@"服务器连接失败，请检查后再试" code:-1 userInfo:nil];
        
        failure(request,netError);
        
    }
   

}
-(NSString *)replaceClassName:(id)reqClass
{
    NSString * reqStr = NSStringFromClass([reqClass class]);
    NSString * string1 = reqStr;
    NSString * string2 = @"Req";
    NSRange range = [string1 rangeOfString:string2];
    NSString *respStr = nil;
    if (range.location != NSNotFound) {
        NSString *str = [string1 substringToIndex:range.location];
        respStr = [NSString stringWithFormat:@"%@Resp",str];
    }
    return respStr;
    
}
- (NSString *)getSignStr:(NSDictionary *)paramtersDic
{
    NSArray *keys = [paramtersDic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj2 compare:obj1 options:NSNumericSearch];
    }];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (NSString *categoryId in sortedArray) {
        [values addObject:[paramtersDic objectForKey:categoryId]];
    }
    NSMutableString *startStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i< sortedArray.count;i++) {
        NSString *key = [sortedArray objectAtIndex:i];
        NSString *value = [values objectAtIndex:i];
        
        NSString *tempStr = [NSString stringWithFormat:@"\"%@\":\"%@\",",key,value];
        [startStr appendString:tempStr];
    }
    
    NSString *str0 = [NSString stringWithFormat:@"{%@",startStr];
    NSRange range0 = [str0 rangeOfString:@"," options:NSBackwardsSearch];
    NSString *endStr = nil;
    if (range0.location != NSNotFound) {
        NSString *str1 = [str0 substringToIndex:range0.location];
        endStr = [NSString stringWithFormat:@"%@}",str1];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@",endStr == nil ? @"{}":endStr];
    
    NSLog(@"sign = %@",str);
    
    return [self md5HexDigest:str];
    
}
- (NSString *)md5HexDigest:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[16]= "0123456789abcdef";
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
