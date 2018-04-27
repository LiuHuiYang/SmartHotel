//
//  SHAlarm.h
//  SmartHotel
//
//  Created by Mac on 2018/4/27.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHAlarm : NSObject

/// 闹钟序号
@property (assign, nonatomic) NSUInteger alarmNumber;

/// 闹钟间隔时间(min)
@property (assign, nonatomic) NSUInteger alarmIntervalTime;

/// 设定的闹钟时间
@property (copy, nonatomic) NSString *alarmTime;

/// 闹铃名称
@property (copy, nonatomic) NSString *alarmSongName;



@end
