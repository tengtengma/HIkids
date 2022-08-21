//
//  BWFileManager.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/26.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWFileManager.h"

@implementation BWFileManager

+ (NSString *)getDocumentCachesPath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES) lastObject];
}
+ (NSString *)createOrGetDirWithName:(NSString *)dirPathName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    
    if (![fileManager fileExistsAtPath:dirPathName]) {
        if(![fileManager createDirectoryAtPath:dirPathName withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"ERROR: Failed to create dir path %@ with comming message %@ .", dirPathName,[error localizedDescription]);
        }
    }
    return dirPathName;
}
@end
