//
//  SHLight.m
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHLight.h"

@implementation SHLight


/// 字典转模型
+ (instancetype)lightWithDictionary:(NSDictionary *)dictionary {

    SHLight *light = [[self alloc] init];
    
    [light setValuesForKeysWithDictionary:dictionary];
  
    return light;
}


@end
