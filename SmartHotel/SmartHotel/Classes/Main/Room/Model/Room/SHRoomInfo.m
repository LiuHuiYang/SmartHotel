//
//  SHRoomInfo.m
//  SmartHotel
//
//  Created by Apple on 2019/6/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHRoomInfo.h"

@implementation SHRoomInfo

/// 房间字典转换模型
+ (instancetype)roomInfoWithDictionary:(NSDictionary *)dictionary {
    
    SHRoomInfo *roomInfo = [[self alloc] init];
    
    [roomInfo setValuesForKeysWithDictionary:dictionary];
    
    return roomInfo;
}

@end
