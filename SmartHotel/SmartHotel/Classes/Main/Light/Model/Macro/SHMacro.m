//
//  SHMacro.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHMacro.h"

@implementation SHMacro


/// macro字典转换为模型
+ (instancetype)macroinitWithDictionary:(NSDictionary *)dictionary {
    
    SHMacro *macro = [[self alloc] init];
    
    [macro setValuesForKeysWithDictionary:dictionary];
    
    return macro;
}

@end
