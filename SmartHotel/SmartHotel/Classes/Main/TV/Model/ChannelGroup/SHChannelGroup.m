//
//  SHChannelGroup.m
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHChannelGroup.h"

@implementation SHChannelGroup

/**
 字典转换为模型
 
 @param dictionary 字典
 @return 模型对象
 */
+ (instancetype)channelGroupWithDictionary:(NSDictionary *)dictionary {
    
    SHChannelGroup *group = [[self alloc] init];
    
    [group setValuesForKeysWithDictionary:dictionary];
    
    
    group.channels =
        [SHSQLManager.shareSHSQLManager getTVChannels: group];
    
    return group;
}

@end
