//
//  NSDate+JJ.h
//  易商
//
//  Created by 伍松和 on 14/10/24.
//  Copyright (c) 2014年 Ruifeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define YYYY_MM_DD_HH_MM_SS @"YYYY-MM-dd HH:mm:ss"
#define YYYY_MM_DD_HH_MM @"YYYY-MM-dd HH:mm"
#define YYYY_MM_DD @"YYYY-MM-dd"
#define HH_MM_SS @"HH:mm:ss"
#define HH_MM @"HH:mm"


#define MM_DD @"MM-dd"

@interface NSDate (JJ)
#pragma mark -时间相关

#pragma mark -传一个时间戳跟日期格式得到正确日期字符串
+(NSString*)getRealTime:(NSString *)timestamp
             withFormat:(NSString*)format;

#pragma mark -传一个NSDate跟日期格式得到正确日期字符串

+(NSString*)getRealDateTime:(NSDate *)date
                 withFormat:(NSString*)format;

#pragma mark -根据一个Date得到一个时间戳(10位的,看需求)
+(NSString*)getTimeStampWithDate:(NSDate*)date;
//次要方法
#pragma mark -根据一个Date得到一个时间戳(13位的,看需求)
+(NSString*)getTimeStampWith13Date:(NSDate*)date;

#pragma mark -根据时间戳获取年月日
+(NSString*)getRealTime:(NSString *)timestamp;
#pragma mark -根据时间戳获取分钟秒钟
+(NSString*)getDayRealTime:(NSString *)timestamp;

+(NSDate *)dateString:(NSString *)dateString
               Format:(NSString*)format;
#pragma mark -根据字符串拿到Date
+(NSDate *)dateString:(NSString *)dateString;

#pragma mark -比较现在时间是否超越N天
+(NSString*) compareCurrentTime:(NSDate*) compareDate;

#pragma mark -根据月日得到星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d;
#pragma mark - 根据时间戳得到一个date
+(NSDate*)getDateWithTime:(NSTimeInterval)time;

+ (NSInteger)weekdayInThisMonth:(NSDate *)date;
+ (NSDate *)nextToMinute:(NSDate *)date offset:(NSInteger)offset;
+ (NSDate *)nextToHour:(NSDate *)date offset:(NSInteger)offset;
+ (NSDate *)nextToDay:(NSDate *)date offset:(NSInteger)offset;
+ (NSInteger)minutes:(NSDate *)date;
+ (NSInteger)hour:(NSDate *)date;
+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
@end
