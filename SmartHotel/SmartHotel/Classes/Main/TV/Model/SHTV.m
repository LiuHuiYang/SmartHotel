//
//  SHTV.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHTV.h"

@implementation SHTV


/// 字典转换为模型
+ (instancetype)tvWithDictionary:(NSDictionary *)dictionary {
    
    SHTV *tv = [[self alloc] init];
    
    [tv setValuesForKeysWithDictionary:dictionary];
    
    return tv;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"SHCTVID"]) {
        
        self.tvID = [value integerValue];
    
    } else if ([key isEqualToString:@"TVName"]) {
    
        self.tvName = value;
    
    } else if ([key isEqualToString:@"TVType"]) {
        
        self.tvType = [key integerValue];
    
    } else {
    
        [super setValue:value forKey:key];
    }
}

@end
