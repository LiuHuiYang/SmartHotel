//
//  SHMacroCommand.h
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMacroCommand : NSObject

@property (assign, nonatomic) NSUInteger scenesID;

@property (assign, nonatomic) NSUInteger sequenceNo;

@property (copy, nonatomic) NSString* remark;

@property (assign, nonatomic) NSUInteger subnetID;

@property (assign, nonatomic) NSUInteger deviceID;

@property (assign, nonatomic) NSUInteger commandTypeID;

@property (assign, nonatomic) NSUInteger firstParameter;

@property (assign, nonatomic) NSUInteger secondParameter;

@property (assign, nonatomic) NSUInteger thirdParameter;

@property (assign, nonatomic) NSUInteger delayMillisecondAfterSend;


/// 宏命令转换成模型
+ (instancetype)macroCommandWithDictionary:(NSDictionary *)dictionary;

@end
