//
//  SHCurtain.h
//  SmartHotel
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHCurtain : NSObject


/// 窗帘ID
@property (assign, nonatomic) NSUInteger curtainID;

/// 窗帘名称
@property (copy, nonatomic) NSString *curtainName;

/// 窗帘类型
@property (assign, nonatomic) NSUInteger curtainType;

/// 窗帘子网ID
@property (assign, nonatomic) NSUInteger subnetID;

/// 窗帘设备ID
@property (assign, nonatomic) NSUInteger deviceID;

/// 窗帘打开通道
@property (assign, nonatomic) NSUInteger openChannelNO;

/// 窗帘关闭通道
@property (assign, nonatomic) NSUInteger closeChannelNO;

/// 窗帘停止通道
@property (assign, nonatomic) NSUInteger stopChannelNO;

/// 延时
@property (assign, nonatomic) NSUInteger relayTimeS;


/// 字典转换为模型
+ (instancetype)curtainWithDictionary:(NSDictionary *)dictionary;

@end
