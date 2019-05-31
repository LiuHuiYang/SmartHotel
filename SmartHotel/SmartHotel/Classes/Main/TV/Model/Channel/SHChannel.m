//
//  SHChannel.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHChannel.h"

@implementation SHChannel

/// 通道实例化
+ (instancetype)channelWithDictionary:(NSDictionary *)dictionary {
    
    SHChannel *channel = [[self alloc] init];
    
    [channel setValuesForKeysWithDictionary:dictionary];
    
    return channel;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    if ([key isEqualToString:@"SHTVID"]) {
        
        self.tvID = [value integerValue];
        
    } else if ([key isEqualToString:@"SHChannelType"]) {
        
        self.channelType = value;
        
    } else if ([key isEqualToString:@"SHChannelID"]) {
        
        self.schannelID = [value integerValue];
        
    } else {
        
        [super setValue:value forKey:key];
    }
}

@end
