//
//  SHChannel.h
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHChannel : NSObject

@property (assign, nonatomic) NSUInteger tvID;

@property (copy, nonatomic) NSString* channelName;

@property (copy, nonatomic) NSString* channelType;

@property (assign, nonatomic) NSUInteger schannelID;

@property (assign, nonatomic) NSUInteger channelIRNumber;

@property (assign, nonatomic) NSUInteger channelIconID;

@property (assign, nonatomic) NSUInteger subnetID;

@property (assign, nonatomic) NSUInteger deviceID;

@property (assign, nonatomic) NSUInteger delayTimeBetweenTowIRMillisecend;

/// 通道实例化
+ (instancetype)channelWithDictionary:(NSDictionary *)dictionary;

@end
