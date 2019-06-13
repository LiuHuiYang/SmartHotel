//
//  SHMacroCommand.h
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMacroCommand : NSObject

/// 宏序号
@property (assign, nonatomic) NSUInteger macroID;

/// 宏指令的序号
@property (assign, nonatomic) NSUInteger macroCommandID;

/// 操作类型
@property (assign, nonatomic) NSUInteger commandType;

/// 设备ID
@property (assign, nonatomic) NSUInteger subnetID;

/// 子网ID
@property (assign, nonatomic) NSUInteger deviceID;

/// 命令标记
@property (copy, nonatomic) NSString *remark;

/// 可变参数1
@property (assign, nonatomic) NSUInteger parameter1;

/// 可变参数2
@property (assign, nonatomic) NSUInteger parameter2;

/// 可变参数3
@property (assign, nonatomic) NSUInteger parameter3;

/// 可变参数4
@property (assign, nonatomic) NSUInteger parameter4;

/// 可变参数5
@property (assign, nonatomic) NSUInteger parameter5;

/// 可变参数6
@property (assign, nonatomic) NSUInteger parameter6;

/// 可变参数7
@property (assign, nonatomic) NSUInteger parameter7;

/// 可变参数8
@property (assign, nonatomic) NSUInteger parameter8;


/// 延时参数
@property (assign, nonatomic) NSUInteger delayTime;


/// 宏命令转换成模型
+ (instancetype)macroCommandWithDictionary:(NSDictionary *)dictionary;

@end
