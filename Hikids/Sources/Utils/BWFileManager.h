//
//  BWFileManager.h
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/26.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWFileManager : NSObject
+ (NSString *) getDocumentCachesPath;

+ (NSString *)createOrGetDirWithName:(NSString *)dirPathName;
@end
