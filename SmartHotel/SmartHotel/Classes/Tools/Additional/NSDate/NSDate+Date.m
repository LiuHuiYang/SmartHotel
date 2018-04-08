//
//  NSDate+Date.m
//  Smart-Bus
//
//  Created by LHY on 2017/11/30.
//  Copyright © 2017年 SmartHome. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)

/**
 计算两个NSDateComponents的差值NSDateComponents对象
 
 @param fromComponent 开始时间
 @param toComponent 结束时间
 @return NSDateComponents对象
 */
+ (NSDateComponents *)getTimeDiferenceFormComponent:(NSDateComponents *)fromComponent toComponent:(NSDateComponents *)toComponent {
    
    NSCalendarUnit flag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [[NSCalendar currentCalendar] components:flag fromDateComponents:fromComponent toDateComponents:toComponent options:NSCalendarWrapComponents];
}

/**
 计算两个【NSDate】的差值NSDateComponents对象
 
 @param fromDate 开始时间
 @param toDate 结束时间
 @return 日历对象，按属性取值就可以了
 */
+ (NSDateComponents *)getTimeDiferenceFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    // 用日历比较时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置需要获得的属性
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 返回比较后的时间
    return [calendar components:unitFlags fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
}

/**
 获得指定【日期字符串】的时间属性

 @param dateFormatString 日期格式字符串
 @param dateString 日期字符串
 @return 日期属性
 */
+ (NSDateComponents *)getDateComponentsForDateFormatString:(NSString *)dateFormatString byDateString:(NSString *)dateString {
    
    // 日期属性
    NSInteger componentFlags = NSCalendarUnitYear
        | NSCalendarUnitMonth   | NSCalendarUnitDay
        | NSCalendarUnitWeekday | NSCalendarUnitHour
        | NSCalendarUnitMinute  | NSCalendarUnitSecond;

    // 创建日期格式化
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormatString;
    
    // 获得结果
    NSDateComponents *result = [[NSCalendar currentCalendar] components:componentFlags fromDate:[dateFormatter dateFromString:dateString]];
    
    return result;
}

/**
 获得指定【NSDate时间】的时间属性
 
 @param date 指定时间
 @return 时间属性
 */
+ (NSDateComponents *)getCurrentDateComponentsFrom:(NSDate *)date{
    
    // 日期属性
    NSInteger componentFlags = NSCalendarUnitYear
    | NSCalendarUnitMonth   | NSCalendarUnitDay
    | NSCalendarUnitWeekday | NSCalendarUnitHour
    | NSCalendarUnitMinute  | NSCalendarUnitSecond;
    
    
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    
    return currentComponents;
}

/**
 获得当前的时间属性
 */
+ (NSDateComponents *)getCurrentDateComponents {
    
    // 日期属性
    NSInteger componentFlags = NSCalendarUnitYear
        | NSCalendarUnitMonth   | NSCalendarUnitDay
        | NSCalendarUnitWeekday | NSCalendarUnitHour
        | NSCalendarUnitMinute  | NSCalendarUnitSecond;

    
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:componentFlags fromDate:[NSDate date]];
    
    return currentComponents;
}


@end
