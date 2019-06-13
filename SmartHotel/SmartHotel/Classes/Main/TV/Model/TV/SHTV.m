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
    
    tv.channelGroups =
        [SHSQLManager.shareSHSQLManager getTVChannelGroups:tv];
    
    return tv;
}


@end
