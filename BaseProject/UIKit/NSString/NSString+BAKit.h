
/*!
 *  @header BAKit.h
 *          BaseProject
 *
 *  @brief  BAKit
 *
 *  @author tyl
 *  @copyright    Copyright © 2017年 tyl. All rights reserved.
 *  @version    V1.0
 */
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
NS_ASSUME_NONNULL_BEGIN


@interface NSString (BAKit)
/*!
 
 封装说明：
 所有 NSString 类型的字符处理类，包含：。。。【待整理】等
 
 */


/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
+ (NSString *)searchInString:(NSString *)string
                   charStart:(char)start
                     charEnd:(char)end;

/**
 *  搜索两个字符之间的字符串。
 *  例如: "This is a test" 的开始字符'h'和结束字符't'将返回"his is a "
 */
- (NSString *)searchCharStart:(char)start
                      charEnd:(char)end;

/**
 *  创建一个MD5字符串
 */
- (NSString *)MD5;

/**
 *  创建一个SHA1字符串
 */
- (NSString *)SHA1;

/**
 *  创建一个SHA256字符串
 */
- (NSString *)SHA256;

/**
 *  创建一个SHA512字符串
 */
- (NSString *)SHA512;

/**
 *  检查自身是否追加字符串
 */
- (BOOL)hasString:(NSString *)substring;

/**
 *  检查自身是否是一个email
 */
- (BOOL)isEmail;

/**
 *  检查给定的字符串是否是一个email
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *  字符串转换为UTF8
 */
+ (NSString *)convertToUTF8Entities:(NSString *)string;

/**
 *  编码给定的字符串成Base64
 */
+ (NSString *)encodeToBase64:(NSString *)string;

/**
 *  编码自身成Base64
 */
- (NSString *)encodeToBase64;

/**
 *  解码给定的字符串成Base64
 */
+ (NSString *)decodeBase64:(NSString *)string;

/**
 *  解码自身成Base64
 */
- (NSString *)decodeBase64;

/**
 *  转换自身为开头大写字符串.
 *  例如: "This is a Test" 将返回 "This is a test" 
         "this is a test"  将返回 "This is a test"
 */
- (NSString *)sentenceCapitalizedString;

/**
 *  返回一个从时间戳人类易读的字符串
 */
- (NSString *)dateFromTimestamp;

/**
 *  自编码成编码的URL字符串
 */
- (NSString *)urlEncode;

#pragma mark - *****  日期时间处理 类

/**
 *  获得系统当前日期和时间
 *
 *  @return 获得系统当前日期和时间
 */
+ (nullable NSString *)ba_time_getCurrentDateAndTime;

/**
 *  时间戳转换【YYYY-MM-dd HH:mm:ss】
 *
 *  @param string 时间戳
 *
 *  @return 时间戳转换【YYYY-MM-dd HH:mm:ss】
 */
+ (nullable NSString *)ba_time_getCurrentDateAndTimeWithTimeString:(nullable NSString *)string;

/**
 *  时间戳转换【YYYY-MM-dd】
 *
 *  @param string 时间戳
 *
 *  @return 时间戳转换【YYYY-MM-dd】
 */
+ (nullable NSString *)ba_time_getDateWithTimeString:(nullable NSString *)string;

/**
 *  时间戳转换【HH:mm】
 *
 *  @param string 时间戳
 *
 *  @return 时间戳转换【HH:mm】
 */
+ (nullable NSString *)ba_time_getTimeWithTimeString:(nullable NSString *)string;

/**
 *  时间转换时间戳
 *
 *  @param string 时间
 *
 *  @return 时间转换时间戳
 */
+ (nullable NSString *)ba_time_getTimeStamp;

/*!
 *  判断两个时间差
 *
 *  @param theDate 目标时间
 *
 *  @return 判断两个时间差
 */
+ (NSString *)ba_intervalSinceNow:(NSDate *)theDate;

/*!
 *  日期转换星期
 *
 *  @param inputDate 日期
 *
 *  @return 返回星期几
 */
+ (nullable NSString *)weekdayStringFromDate:(nullable NSDate *)inputDate;

/*! 一般应用程序设置这一组的存在，比如夜间模式，如果你。从8：00-23：00。在这个当前的时间是如何推断出期间。主要的困难在于如何使用NSDate生成8：00时间和23：00时间。然后用当前时间，也许有足够的时间，以使控制。 */
/**
 * @brief 推断当前时间是否在fromHour和toHour之间。如。fromHour=8，toHour=23时。即为推断当前时间是否在8:00-23:00之间
 */
- (BOOL)ba_time_isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

/*!
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比較）
 * @param hour 如hour为“8”。就是上午8:00（本地时间）
 */
- (nullable NSDate *)ba_time_getCustomDateWithHour:(NSInteger)hour;

/*! 判断日期是今天，昨天还是明天 */
- (nullable NSString *)ba_time_compareDate:(nullable NSDate *)date;

/*!
 *  计算上报时间差: 几分钟前，几天前
 *
 *  @return 计算上报时间差: 几分钟前，几天前
 */
- (NSString *)ba_time_compareTime;

/*! 解析新浪微博中的日期, 判断日期是今天，昨天还是明天 */
+ (nullable NSString *)ba_time_resolveSinaWeiboDate:(nullable NSString*)dateStr;


#pragma mark - *****  数字处理 类
/*! 判断数字为2.1千，3.4万（点赞数处理） */
+ (nullable NSString *)ba_stringHandleWithString:(nullable NSString *)string;

/*! 判断是否为整形 */
- (BOOL)ba_isPureInt:(nullable NSString*)string;

/*! 判断是否为浮点形 */
- (BOOL)ba_isPureFloat:(nullable NSString*)string;


#pragma mark - *****  特殊字符串处理 类

/*! 重复字符串N次 */
+ (nullable NSString *)getText:(nullable NSString *)text withRepeat:(int)repeat;

/*! 去掉字符串中的html标签的方法 */
- (nullable NSString *)ba_filterHTML:(nullable NSString *)html;

/*! 十六进制转换为普通字符串 */
- (nullable NSString *)ba_stringFromHexString:(nullable NSString *)hexString;

/**
 *   Create a string from the file in main bundle (similar to [UIImage imageNamed:]).
 *
 *  @param name The file name (in main bundle).
 *
 *  @return A new string create from the file in UTF-8 character encoding.
 */
+ (nullable NSString *)stringNamed:(nullable NSString *)name;

/**
 *   Returns a lowercase NSString for md5 hash.
 *
 *  @return  Returns a lowercase NSString for md5 hash.
 */
- (nullable NSString *)ba_md5String;

/*!
 *  判断字符串是否为空
 *
 *  @param aStirng aStirng
 *
 *  @return 判断字符串是否为空
 */
+ (BOOL)ba_NSStringIsNULL:(nullable NSString *)aStirng;

/**
 *   Trim blank characters (space and newline) in head and tail.
 *
 *  @return the trimmed string.
 */
- (nullable NSString *)stringByTrim;

/**
 *   Try to parse this string and returns an `NSNumber`.
 *
 *  @return Returns an `NSNumber` if parse succeed, or nil if an error occurs.
 */
- (nullable NSNumber *)numberValue;

/**
 *  Returns an NSData using UTF-8 encoding.
 *
 *  @return Returns an NSData using UTF-8 encoding.
 */
- (nullable NSData *)dataValue;

/*! 获取字符串的长度 */
+ (NSUInteger)ba_getLengthOfStr:(nullable NSString *)str;

/*!
 *  字典转json
 *
 *  @param dict 传入的字典
 *
 *  @return 返回json字符串
 */
+ (NSString *)ba_JsonTurnWithDictionary:(NSDictionary *)dict;

#pragma mark - *****  获取软件沙盒路径 类

/*! 获取软件沙盒路径 */
+ (nullable NSString *)ba_path_getApplicationSupportPath;

/*! 获取软件沙盒Documents路径 */
+ (nullable NSString *)ba_path_getDocumentsPath;

/*! 获取软件沙盒cache路径 */
+ (nullable NSString *)ba_path_getCachePath;

/*! 获取软件沙盒cachesDic路径 */
+ (nullable NSString *)ba_path_getTemPath;

/*! 在软件沙盒指定的路径创建一个目录 */
+ (BOOL)ba_path_createDirectory:(nullable NSString *)newDirectory;

/*! 在软件沙盒指定的路径删除一个目录 */
+ (BOOL)ba_path_deleteFilesysItem:(nullable NSString*)strItem;

/*! 在软件沙盒路径移动一个目录到另一个目录中 */
+ (BOOL)ba_path_moveFilesysItem:(nullable NSString *)srcPath toPath:(nullable NSString *)dstPath;

/*! 在软件沙盒路径中查看有没有这个路径 */
+ (BOOL)ba_path_fileExist:(nullable NSString*)strPath;

/*! 在软件沙盒路径中获取指定userPath路径 */
- (nullable NSString *)ba_path_getUserInfoStorePath:(nullable NSString *)userPath;

@end

@interface NSString (BALabelWidthAndHeight)

/**
 *  Get the string's height with the fixed width.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *  @param width     Fixed width.
 *
 *  @return String's height.
 */
- (CGFloat)ba_heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute fixedWidth:(CGFloat)width;

/**
 *  Get the string's width.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *
 *  @return String's width.
 */
- (CGFloat)ba_widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

/**
 *  Get a line of text height.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *
 *  @return String's width.
 */
+ (CGFloat)ba_oneLineOfTextHeightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

/**
 *  拼接baseUrl，用于拼接绝对路径
 */
- (NSString *)addBaseUrl;

/**
 *  去除掉text的开头和结尾的空格
 */
- (NSString *)cutwhitespace;

/**
 *  获取文字size
 */
- (CGSize)sizeOfMaxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;

- (CGSize)sizeOfMaxSize:(CGSize)maxSize font:(UIFont *)font;

/**
 *  计算一个字符串在限定的宽度和字体下的长度
 *
 *  @param font  限定的字体
 *  @param width 限定的宽度
 *
 *  @return 字符串的长度
 */
- (NSInteger)heightWithFont:(UIFont* )font width:(CGFloat)width;

- (NSInteger)widthWithFont:(UIFont *)font height:(CGFloat)height;

/**
 *  偏好设置：存字符串（手势密码）
 */
+ (void)saveString:(NSString *)string Key:(NSString *)key;

/**
 *  偏好设置：取字符串
 */
+ (NSString *)getStringWithKey:(NSString *)key;

/**
 *  给我一个button，让它的文字底部对应的range划线
 */
+ (void)stringToBeUnderlineWithRange:(NSRange)range button:(UIButton *)btn lineColor:(UIColor *)color;
+ (void)stringToBeUnderlineWithRange:(NSRange)range button:(UIButton *)btn lineColor:(UIColor *)color controlstate:(UIControlState)state;

// 提供0-9，转换成0，一->九
+ (NSString *)stringChangeNumberToText:(NSInteger)number;

+ (NSString *)checkString:(NSString *)string range:(NSRange)range str:(NSString *)str;


@end


@interface NSString (BARange)

/**
 *  Finds and returns the ranges of a given string, within the given range of the receiver.
 *
 *  @param searchString searchString.
 *  @param mask         A mask specifying search options. The following options may be specified by combining them with the C bitwise OR operator: NSCaseInsensitiveSearch, NSLiteralSearch, NSBackwardsSearch, NSAnchoredSearch. See String Programming Guide for details on these options.
 *  @param range        serachRange.
 *
 *  @return Ranges.
 */
- (NSArray <NSValue *> *)ba_rangesOfString:(NSString *)searchString options:(NSStringCompareOptions)mask serachRange:(NSRange)range;

@end
NS_ASSUME_NONNULL_END
