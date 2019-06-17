//
//  SHIcon.m
//  SmartHotel
//
//  Created by Apple on 2019/6/14.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHIcon.h"

@implementation SHIcon

/**
 字典转换图片模型
 
 @param dictionary 图片字典
 @return 图片模型
 */
+ (instancetype)iconWithDictionary:(NSDictionary *)dictionary {
    
    SHIcon *icon = [[self alloc] init];
    
    [icon setValuesForKeysWithDictionary:dictionary];
    
    return icon;
}

@end
