//
//  SHChannel.h
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHChannel : NSObject

/// 哪个电视
@property (assign, nonatomic) NSUInteger tvID;

/// 分组标号
@property (assign, nonatomic) NSUInteger groupID;

/// 频道标号
@property (assign, nonatomic) NSUInteger channelID;

  
/// 频道名称
@property (copy, nonatomic) NSString* channelName;

/// 频道图片名称
@property (copy, nonatomic) NSString* iconName;

/// 目标地址
@property (assign, nonatomic) NSUInteger subnetID;

/// 目标地址
@property (assign, nonatomic) NSUInteger deviceID;

/// 红外码组合
@property (assign, nonatomic) NSUInteger channelIRCode;

/// 间隔时间
@property (assign, nonatomic) NSUInteger delayTime;






/// 通道实例化
+ (instancetype)channelWithDictionary:(NSDictionary *)dictionary;

@end
