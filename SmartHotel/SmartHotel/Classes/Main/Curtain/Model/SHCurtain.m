//
//  SHCurtain.m
//  SmartHotel
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHCurtain.h"

@implementation SHCurtain

/// 字典转换为模型
+ (instancetype)curtainWithDictionary:(NSDictionary *)dictionary {
    
    SHCurtain *curtain = [[self alloc] init];

    [curtain setValuesForKeysWithDictionary:dictionary];
    
    return curtain;
}


@end
