//
//  SHRoomBaseInfomation.m
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHRoomBaseInfomation.h"

@implementation SHRoomBaseInfomation

+ (instancetype)roomBaseInfomationWithDictionary:(NSDictionary *)dictionary {
    
    SHRoomBaseInfomation *info = [[SHRoomBaseInfomation alloc] init];
    
    //    [info setValuesForKeysWithDictionary:dictionary];
    info.buildID = [[dictionary objectForKey:@"SHBuildID"] integerValue];
    
    info.floorID = [[dictionary objectForKey:@"SHFloorID"] integerValue];
    
    info.roomNumber = [[dictionary objectForKey:@"SHRoomNumber"] integerValue];
    
    info.roomNumberDisplay = [[dictionary objectForKey:@"SHRoomNumberDisplay"] integerValue];
    
    info.roomAlias = [dictionary objectForKey:@"SHRoomAlias"];
    
    info.hotelName = [dictionary objectForKey:@"SHHotelName"];
    
    return info;
}


@end
