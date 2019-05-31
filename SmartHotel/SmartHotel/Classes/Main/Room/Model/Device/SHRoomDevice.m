//
//  SHRoomDevice.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHRoomDevice.h"

@implementation SHRoomDevice

/// 字典转换为模型
+ (instancetype)roomDeviceWithDictionary:(NSDictionary *)dictionary {

    SHRoomDevice *device = [[SHRoomDevice alloc] init];
    
    [device setValuesForKeysWithDictionary:dictionary];
    
    return device;
}

@end
