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
    
//    [light setValuesForKeysWithDictionary:dictionary];
    light.lightName = dictionary[@"LightName"];
    light.lightID = [dictionary[@"LightID"] integerValue];
    light.channelNo = [dictionary[@"ChannelNo"] integerValue];
    light.canDim = [dictionary[@"CanDim"] integerValue];
    light.lightTypeID = [dictionary[@"LightTypeID"] integerValue];
    light.sequenceNo = [dictionary[@"SequenceNo"] integerValue];
    
    return light;
}


@end
