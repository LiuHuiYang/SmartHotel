//
//  SHMacroCommand.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHMacroCommand.h"

@implementation SHMacroCommand

/// 宏命令转换成模型
+ (instancetype)macroCommandWithDictionary:(NSDictionary *)dictionary; {
    
    SHMacroCommand *command = [[self alloc] init];

    [command setValuesForKeysWithDictionary:dictionary];
    
    return command;
}

@end
