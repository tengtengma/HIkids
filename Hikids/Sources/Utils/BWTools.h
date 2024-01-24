//
//  BWTools.h
//  bwclassgoverment
//
//  Created by MaZhiKui on 2018/1/12.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BWTools : NSObject

+(BOOL)isLoginin;

+ (BOOL)checkPhone:(NSString *)phoneNumber;

+ (BOOL)checkEmail:(NSString *)email;

//字典转换成json
+ (NSString *)DictionaryToJson:(NSDictionary *) dictionary;
//json转字符串
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//根据字体，限定的宽度，计算一个字符串的高度
+ (CGSize) SizeWithString:(NSString*) string withFont:(UIFont*) font withWidth:(CGFloat) width;
+ (CGSize)SizeWithString:(NSString *)string withFont:(UIFont *)font;

//根据字体，计算字符串的宽，高度限定为0.0
+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width;

//根据毫秒数返回 NSDate对象
//time 毫秒数 long 类型
+ (NSDate*)DateFromTime:(long) time;

//返回日期字符串
//formatter 格式化形式＝“yyyy-mm-dd hh-mm-ss”
+ (NSString*)StringFromDate:(NSDate*)date formatter:(NSString*) formatter;

//返回日期字符串
//time 毫秒数
+ (NSString*)StringfromTime:(long) time formatter:(NSString*) formatter;

//字符串转日期
+ (NSDate*)DateFromString:(NSString*) date formatter:(NSString*) formatter;

+ (NSString *)formatSecondsToString:(NSInteger)seconds;

////支持照相
//+ (BOOL) isCameraAvailable;
//
////支持前置摄像头
//+ (BOOL) isFrontCameraAvailable;
//
////后置摄像头
//+ (BOOL) isRearCameraAvailable;
//
//// 检查摄像头是否支持录像
//+ (BOOL) doesCameraSupportShootingVideos;
//
//// 检查摄像头是否支持拍照
//+ (BOOL) doesCameraSupportTakingPhotos;
//
//// 是否可以在相册中选择照片
//+ (BOOL) canUserPickPhotosFromPhotoLibrary;
//
//// 是否可以在相册中选择视频
//+ (BOOL) canUserPickVideosFromPhotoLibrary;
//
//// 相册是否可用
//+ (BOOL) isPhotoLibraryAvailable;

// 缩图
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

//邮箱是否合法
+(BOOL) isValidateEmail:(NSString*)email;

//邮箱是否有效
+(BOOL) validateEmail:(NSString*)email;

//密码是否合法
+(BOOL) isValidateString:(NSString *)myString;

//判断只含有数字
+ (BOOL)isPureInt:(NSString*)string;

+ (BOOL)getIsIpad;

//随机字符串
+ (NSString *)generateTradeNO;

+ (NSString *)getIDFV;

+ (NSString *)md5HexDigest:(NSString*)input;

+(NSString *)getMessageDateStringFromTimeInterval:(NSTimeInterval)TimeInterval andNeedTime:(BOOL)needTime;

+ (NSString *)formateDate:(NSDate *)originDate;

//保存历史记录
+ (void)addSearchRecord:(NSString *)searchStr;

//获取所有历史记录
+ (NSArray *)getAllSearchHistory;

//清除历史记录
+ (void)clearAllSearchHistory;

//判断全汉字
+ (BOOL)inputShouldChinese:(NSString *)inputString;

//判断全为数字
+ (BOOL)inputShouldNumber:(NSString *)inputString;

//判断全为字母
+ (BOOL)inputShouldLetter:(NSString *)inputString;

/*s*
 *  获取path路径下文件夹的大小
 */
+ (NSInteger)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  清除path路径下文件夹的缓存
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;

/**
 *  设置cookie
 */
+ (void)setCookieWithItem:(NSDictionary *)item;

+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;

+ (NSString *)getNowTimeStringWithFormate:(NSString *)formate;

// 时间戳转换
+ (NSString *)getMomentTime:(long long)timestamp;

//时间戳转换 新01/24/2024
+ (NSString *)timeIntervalStringForLastUpdate:(NSTimeInterval)timestamp;

@end
