//
//  NSDate+Additions.h
//  jinsuibao
//  
//  Created by tj on 4/21/16.
//  Copyright © 2016 yiqiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

/* 毫秒 */
- (uint64_t)timeIntervalSince1970_MSEC;

/**
 *  时间戳转换为以月份开头的详细时间
 *  etg.4月13日 10:23:32
 *
 *  @param ts Unix 时间戳
 *
 *  @return 转换后显示时间
 */
+ (NSString *)monthlyDetailTimeWithTimeStrap:(NSTimeInterval)ts;

/**
 * 判断theDate到现在是否超过一个天
 */
+ (BOOL)moreThanADayToNow:(NSDate *)theDate;

/**
 *  获取一个date的转换时区后的日期
 */
+ (NSDate *)getLocalDateWithCurrentDate:(NSDate *)date;
/**
 *  根据自定义格式返回字符串
 *
 *  @param format 日期格式
 *  @param ts     时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString*)dateWithFormat:(NSString*)format WithTS:(NSTimeInterval)ts;
/**
 *  根据unix时间戳返回当天时间,eg. 12:01.
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)dayTimeStringWithTS:(NSTimeInterval)ts;
/**
 *  根据unix时间返回日期,eg. 2015-09-01
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)dateTimeStringWithTS:(NSTimeInterval)ts;
/**
 *  根据unix时间返回日期,eg. 2015年09月
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)monthTimeStringWithTs:(NSTimeInterval)ts;
/**
 *  根据unix时间返回日期,eg. 2015-09-10 13:00:05
 *
 *  @param ts unix时间戳
 *
 *  @return 时间格式字符串
 */
+ (NSString *)detailTimeStringWithTs:(NSTimeInterval)ts;
/**
 *  当前是否在此事件范围之内
 *
 *  @param fromTs 开始时间
 *  @param endTs  结束时间
 *
 */
+ (BOOL)isNowAvailableFromTs:(NSTimeInterval)fromTs endTs:(NSTimeInterval)endTs;

/**
 当前是否参数时间的另外一天
 
 @param date 时间
 */
+ (BOOL)isNowAnothrDayForDate:(NSDate *)date;

/**
 根据字符串获取date
 
 @param formaterString formaterString
 @param dateString 字符串
 */
+ (NSDate *)dateWithFormaterString:(NSString *)formaterString dateString:(NSString *)dateString;

- (NSString *)stringWithFormaterString:(NSString *)formaterString;

/**
 获取当前时间字符串

 @param string 时间格式 (YY-MM-dd HH:mm)
 @return 时间字符串
 */
+(NSString*)getCurrentTimes:(NSString *)string;

/**
 将时间字符串转为时间戳

 @param formatTime 时间字符串
 @param format 时间格式 (YY-MM-dd HH:mm)
 @return 时间字符串
 */
+ (NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

/**  获取当前时间戳有两种方法(以秒为单位)  */
+ (NSString *)getNowTimeTimestamp;

/**  获取当前时间戳 自定义格式  */
+ (NSString *)getNowTimeTimestamp:(NSString *)format;

@end
