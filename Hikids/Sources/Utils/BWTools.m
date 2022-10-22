//
//  BWTools.m
//  bwclassgoverment
//
//  Created by MaZhiKui on 2018/1/12.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWTools.h"
#import <CommonCrypto/CommonDigest.h>
#define RecordCount 10      //最多存储10条，自定义
#define SEARCH_HISTORY [[NSUserDefaults standardUserDefaults] arrayForKey:@"SearchHistory"]
@implementation BWTools
//
//+ (BOOL)isLoginin
//{
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:KEY_UserID]) {
//        return YES;
//    }
//    return NO;
//}

+ (NSString *)DictionaryToJson:(NSDictionary *)dictionary
{
    NSError *parseError = nil;
    NSString *str = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
    if(!jsonData || parseError){
        return str;
    }
    //Data转换为JSON
    str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

+ (CGSize)SizeWithString:(NSString *)string withFont:(UIFont *)font withWidth:(CGFloat)width
{
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize;
}

+ (CGSize)SizeWithString:(NSString *)string withFont:(UIFont *)font
{
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return titleSize;
}

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

+ (NSDate*)DateFromTime:(long)time
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    return date;
}

+ (NSString*)StringfromTime:(long)time formatter:(NSString *)formatter
{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = formatter;
    NSString *time1 = [_formatter stringFromDate:date];
    return time1;
}

+ (NSString*)StringFromDate:(NSDate *)date formatter:(NSString *)formatter
{
    if (date == nil || [date isEqual:[NSNull null]]) {
        return @"";
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = formatter;
    NSString *time2 = [_formatter stringFromDate:date];
    return time2;
}

+ (NSDate*)DateFromString:(NSString *)date formatter:(NSString *)formatter
{
    if (date == nil || [date isEqualToString:@""] || [date isEqual:[NSNull null]]) {
        return nil;
    }
    
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = formatter;
    NSDate *_date = [_formatter dateFromString:date];
    return _date;
}
+ (NSString *)formatSecondsToString:(NSInteger)seconds
{
    NSString *hhmmss = nil;
    if (seconds < 0) {
        return @"00:00:00";
    }
    
    int h = (int)round((seconds%86400)/3600);
    int m = (int)round((seconds%3600)/60);
    int s = (int)round(seconds%60);
    
    if (h>0) {
        hhmmss = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];

    }else{
        hhmmss = [NSString stringWithFormat:@"%02d:%02d", m, s];

    }
    
    
    return hhmmss;
}
+ (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
+ (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}


// 后面的摄像头是否可用
+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


// 检查摄像头是否支持录像
//+ (BOOL) doesCameraSupportShootingVideos{
//    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypeCamera];
//}
//
//
//// 检查摄像头是否支持拍照
//+ (BOOL) doesCameraSupportTakingPhotos{
//    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
//}


+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0){
        //NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
        
    }];
    return result;
}

// 相册是否可用
+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}

// 是否可以在相册中选择视频
//+ (BOOL) canUserPickVideosFromPhotoLibrary{
//    return [self cameraSupportsMedia:( NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//}

// 是否可以在相册中选择照片
//+ (BOOL) canUserPickPhotosFromPhotoLibrary{
//    return [self cameraSupportsMedia:( NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//}

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}


+(BOOL)isValidateString:(NSString *)myString
{
    NSCharacterSet *nameCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"$_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    NSRange userNameRange = [myString rangeOfCharacterFromSet:nameCharacters];
    if (userNameRange.location != NSNotFound) {
        //NSLog(@"包含特殊字符");
        return FALSE;
    }else{
        return TRUE;
    }
    
}

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}
+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (NSString *)getIDFV
{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}
+ (NSString *)md5HexDigest:(NSString*)input
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
#pragma mark--
#pragma mark --判断手机号合法性

+ (BOOL)checkPhone:(NSString *)phoneNumber
{
    if(phoneNumber.length>11 || phoneNumber.length == 0){
        return NO;
    }else{
        return YES;
    }
//    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(19[0-9])|(18[0-9])|(17[0-9]))\\d{8}$";
//
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//
//    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
//
//    if (!isMatch)
//
//    {
//
//        return NO;
//
//    }
//
//    return YES;
    
    
}

#pragma mark--
#pragma mark 判断邮箱

+ (BOOL)checkEmail:(NSString *)email{
    
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:email];
    
}

#pragma mark--
#pragma mark--判断日期显示格式
+ (NSString *)formateDate:(NSDate *)originDate
{
    
    //    @try {
    
    NSString *dateStr = nil;
    // ------实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
    NSDate * nowDate = [NSDate date];
    
    // ------将需要转换的时间转换成 NSDate 对象
    
    NSString *originDateStr = [dateFormatter stringFromDate:originDate];
    NSString *nowDateStr = [dateFormatter stringFromDate:nowDate];
    // 年
    NSString * yearStr = [originDateStr substringToIndex:4];
    NSString * nowYear = [nowDateStr substringToIndex:4];
    BOOL isSameYear = [yearStr isEqualToString:nowYear];
    // 月
    NSRange monthRange = NSMakeRange(5, 2);
    NSString *monthStr = [originDateStr substringWithRange:monthRange];
    NSString *nowMonth = [nowDateStr substringWithRange:monthRange];
    BOOL isSameMonth = [monthStr isEqualToString:nowMonth];
    // 日
    NSRange dayRange = NSMakeRange(8, 2);
    NSString *dayStr = [originDateStr substringWithRange:dayRange];
    NSString *nowDay = [nowDateStr substringWithRange:dayRange];
    BOOL isSameDay = [dayStr isEqualToString:nowDay];
    int dayValue = nowDay.intValue - dayStr.intValue;// 天数间隔
    // 时
    NSRange hourRange = NSMakeRange(11, 2);
    NSString *hourStr = [originDateStr substringWithRange:hourRange];
    NSString *nowhour = [nowDateStr substringWithRange:hourRange];
    BOOL isSameHour = [hourStr isEqualToString:nowhour];
    int hourValue = nowhour.intValue - hourStr.intValue;// 小时间隔
    
    // 分
    NSRange minuteRange = NSMakeRange(14, 2);
    NSString *minuteStr = [originDateStr substringWithRange:minuteRange];
    NSString *nowminute = [nowDateStr substringWithRange:minuteRange];
    int minuteValue = nowminute.intValue - minuteStr.intValue;// 分钟间隔
    
    // 秒
    NSRange secondRange = NSMakeRange(17, 2);
    NSString *secondStr = [originDateStr substringWithRange:secondRange];
    NSString *nowSecond = [nowDateStr substringWithRange:secondRange];
    int secondValue = nowSecond.intValue - secondStr.intValue;// 秒间隔
    
    /***********************需要的时间字符串**********************/
    //    if (isSameYear) {
    //        if (isSameMonth) {
    //            if (isSameDay) {
    //                dateStr = [NSString stringWithFormat:@"上午%@:%@",hourStr,minuteStr];
    //            }else if (dayValue == 1){
    //                dateStr = @"昨天";// 相差一天显示昨天
    //            }else if (dayValue<=7){// 相差7天显示星期几
    //                dateStr = [self weekdayStringFromDate:originDate];
    //            }else{
    //                // 是一年，显示月份
    //                [dateFormatter setDateFormat:@"MM/dd"];
    //                dateStr = [dateFormatter stringFromDate:originDate];
    //            }
    //            return dateStr;
    //            /***********************需要的时间字符串**********************/
    //        }
    //
    //    }else{
    //        // 不是一年 显示年份
    //        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    //        dateStr = [dateFormatter stringFromDate:originDate];
    //    }
    //    return dateStr;
    
    if (isSameYear) {
        //同一年
        if (isSameMonth) {
            //同一个月
            
            if (isSameDay) {
                //同一天
                dateStr = [NSString stringWithFormat:@"今天:%@:%@",hourStr,minuteStr];
                return dateStr;
                
            }else{
                //不同天
                if (dayValue == 1) {
                    dateStr = [NSString stringWithFormat:@"昨天:%@:%@",hourStr,minuteStr];
                    return dateStr;
                    
                }else{
                    //大于1天
                    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
                    dateStr = [dateFormatter stringFromDate:originDate];
                    //                    dateStr = [NSString stringWithFormat:@"%@年%@月%@日 %@时%@分%@秒",yearStr,monthStr,dayStr,hourStr,minuteStr,secondStr];
                    
                    return dateStr;
                }
                
            }
        }else{
            //不同月
            [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
            dateStr = [dateFormatter stringFromDate:originDate];
            return dateStr;
            
        }
        
    }else{
        //不同年
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateStr = [dateFormatter stringFromDate:originDate];
        return dateStr;
        
    }
    
    return dateStr;
    
}


+ (void)addSearchRecord:(NSString *)searchStr
{
    NSMutableArray *searchArray = [[NSMutableArray alloc]initWithArray:SEARCH_HISTORY];
    if (searchArray == nil) {
        searchArray = [[NSMutableArray alloc]init];
    } else if ([searchArray containsObject:searchStr]) {
        [searchArray removeObject:searchStr];
    } else if ([searchArray count] >= RecordCount) {
        [searchArray removeObjectsInRange:NSMakeRange(RecordCount - 1, [searchArray count] - RecordCount + 1)];
    }
    [searchArray insertObject:searchStr atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:searchArray forKey:@"SearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getAllSearchHistory
{
    return SEARCH_HISTORY;
}

+ (void)clearAllSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"SearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//判断全汉字
+ (BOOL)inputShouldChinese:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
//判断全数字
+ (BOOL)inputShouldNumber:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}
//判断仅输入字母或数字
+ (BOOL)inputShouldLetter:(NSString *)inputString {
    if (inputString.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

#pragma mark - 获取path路径下文件夹大小
+ (NSInteger)getCacheSizeWithFilePath:(NSString *)path{
    
    // 获取“path”文件夹下的所有文件
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        // 1. 拼接每一个文件的全路径
        filePath =[path stringByAppendingPathComponent:subPath];
        // 2. 是否是文件夹，默认不是
        BOOL isDirectory = NO;
        // 3. 判断文件是否存在
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        // 4. 以上判断目的是忽略不需要计算的文件
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            // 过滤: 1. 文件夹不存在  2. 过滤文件夹  3. 隐藏文件
            continue;
        }
        // 5. 指定路径，获取这个路径的属性
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        /**
         attributesOfItemAtPath: 文件夹路径
         该方法只能获取文件的属性, 无法获取文件夹属性, 所以也是需要遍历文件夹的每一个文件的原因
         */
        // 6. 获取每一个文件的大小
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        // 7. 计算总大小
        totleSize += size;
    }
    //8. 将文件夹大小转换为 M/KB/B
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleSize;
}
#pragma mark - 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}
+ (void)setCookieWithItem:(NSDictionary *)item {
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    
    [cookieProperties setObject:[item objectForKey:@"cookieName"] forKey:NSHTTPCookieName];
    
    [cookieProperties setObject:[item objectForKey:@"cookieValue"] forKey:NSHTTPCookieValue];
    
    [cookieProperties setObject:[item objectForKey:@"cookieDomain"] forKey:NSHTTPCookieDomain];
    
    [cookieProperties setObject:[item objectForKey:@"cookiePath"] forKey:NSHTTPCookiePath];
    
//    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:7*24*60*60] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    
}
+ (BOOL)getIsIpad
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}
+ (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];

        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);

        layer.backgroundColor = color.CGColor;

        [view.layer addSublayer:layer];

    }

    if (left) {
        CALayer *layer = [CALayer layer];

        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);

        layer.backgroundColor = color.CGColor;

        [view.layer addSublayer:layer];

    }

    if (bottom) {
        
        CALayer *layer = [CALayer layer];

        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);

        layer.backgroundColor = color.CGColor;

        [view.layer addSublayer:layer];

    }

    if (right) {
        CALayer *layer = [CALayer layer];

        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);

        layer.backgroundColor = color.CGColor;

        [view.layer addSublayer:layer];

    }

}

@end
