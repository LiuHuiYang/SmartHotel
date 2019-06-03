//
//  SHHVAC.m
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHHVAC.h"

@implementation SHHVAC
    
    
/**
 字典转换成模型
 
 @param dictionary 字典
 @return 模型
 */
+ (instancetype)airConditionerWithDictionary:(NSDictionary *)dictionary {
    
    SHHVAC *ac = [[self alloc] init];
    
    [ac setValuesForKeysWithDictionary:dictionary];
    
    return ac;
}
    

@end
