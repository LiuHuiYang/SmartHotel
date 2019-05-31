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

/// 类型
@property (assign, nonatomic) NSUInteger tvType;

/// 子网ID
@property (assign, nonatomic) NSUInteger subnetID;

/// 设备ID
@property (assign, nonatomic) NSUInteger deviceID;

/// 电源开
@property (assign, nonatomic) NSUInteger openUniversalSwitchID;

/// 电源关
@property (assign, nonatomic) NSUInteger closeUniversalSwitchID;

/// 静音开
@property (assign, nonatomic) NSUInteger muteOnUniversalSwitchID;

/// 静音关
@property (assign, nonatomic) NSUInteger muteOffUniversalSwitchID;

/// 声音 +
@property (assign, nonatomic) NSUInteger volUpUniversalSwitchID;

/// 声音 -
@property (assign, nonatomic) NSUInteger volDownUniversalSwitchID;

/// 下一个频道
@property (assign, nonatomic) NSUInteger ChannelUpUniversalSwitchID;

/// 上一个频道
@property (assign, nonatomic) NSUInteger ChannelDownUniversalSwitchID;

/// 确定
@property (assign, nonatomic) NSUInteger OKUniversalSwitchID;

/// 数这键1
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor1;

/// 数这键2
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor2;

/// 数这键3
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor3;

/// 数这键4
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor4;

/// 数这键5
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor5;

/// 数这键6
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor6;

/// 数这键7
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor7;

/// 数这键8
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor8;

/// 数这键9
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor9;

/// 数这键0
@property (assign, nonatomic) NSUInteger UniversalSwitchIDFor0;

/// 打开自定义宏号
@property (assign, nonatomic) NSUInteger openIrMacroNo;

/// 关闭自定义的宏号
@property (assign, nonatomic) NSUInteger closeMactroNo;

/// 字典转换为模型
+ (instancetype)tvWithDictionary:(NSDictionary *)dictionary;

@end
