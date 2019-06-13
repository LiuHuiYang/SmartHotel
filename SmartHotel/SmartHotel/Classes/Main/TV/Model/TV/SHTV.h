//
//  SHTV.h
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHTV : NSObject

/// 序号
@property (assign, nonatomic) NSUInteger tvID;

/// 名称
@property (copy, nonatomic) NSString *tvName;


/// 子网ID
@property (assign, nonatomic) NSUInteger subnetID;

/// 设备ID
@property (assign, nonatomic) NSUInteger deviceID;

/// 电源开
@property (assign, nonatomic) NSUInteger turnOn;

/// 电源关
@property (assign, nonatomic) NSUInteger turnOff;

/// 静音开
@property (assign, nonatomic) NSUInteger muteOn;

/// 静音关
@property (assign, nonatomic) NSUInteger muteOff;

/// 声音 +
@property (assign, nonatomic) NSUInteger volumeUp;

/// 声音 -
@property (assign, nonatomic) NSUInteger volumeDown;

/// 下一个频道
@property (assign, nonatomic) NSUInteger channelUp;

/// 上一个频道
@property (assign, nonatomic) NSUInteger channelDown;

/// 确定
@property (assign, nonatomic) NSUInteger sure;

/// 数这键1
@property (assign, nonatomic) NSUInteger number1;

/// 数这键2
@property (assign, nonatomic) NSUInteger number2;

/// 数这键3
@property (assign, nonatomic) NSUInteger number3;

/// 数这键4
@property (assign, nonatomic) NSUInteger number4;

/// 数这键5
@property (assign, nonatomic) NSUInteger number5;

/// 数这键6
@property (assign, nonatomic) NSUInteger number6;

/// 数这键7
@property (assign, nonatomic) NSUInteger number7;

/// 数这键8
@property (assign, nonatomic) NSUInteger number8;

/// 数这键9
@property (assign, nonatomic) NSUInteger number9;

/// 数这键0
@property (assign, nonatomic) NSUInteger number0;

/// 频道分组
@property (nonatomic, strong) NSMutableArray *channelGroups;

/// 字典转换为模型
+ (instancetype)tvWithDictionary:(NSDictionary *)dictionary;

@end
