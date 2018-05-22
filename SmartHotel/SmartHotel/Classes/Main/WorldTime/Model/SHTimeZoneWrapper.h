//
//  SHTimeZoneWrapper.h
//  SmartHotel
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHTimeZoneWrapper : NSObject

/// 名称
@property (nonatomic, copy) NSString *localeName;

/// 时区
@property (nonatomic, strong) NSTimeZone *timeZone;

/// 日期
@property (nonatomic, strong) NSDate *date;

/// 日历
@property (nonatomic, strong) NSCalendar *calendar;

/// 哪一天
@property (nonatomic, copy) NSString *whichDay;

/// 缩写
@property (nonatomic, retain) NSString *abbreviation;

/// GMT-偏移量
@property (nonatomic, copy) NSString *gmtOffset;
 

- (instancetype)initWithTimeZone:(NSTimeZone *)timeZone nameComponents:(NSArray *)nameComponents;

@end
