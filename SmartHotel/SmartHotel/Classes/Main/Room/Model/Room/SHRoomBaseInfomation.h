//
//  SHRoomBaseInfomation.h
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHRoomBaseInfomation : NSObject

// MARK: - 设备模块的属性

/// CardHolder的子网ID
@property (assign, nonatomic) NSUInteger subNetIDForCardHolder;

/// CardHolder的设备ID
@property (assign, nonatomic) NSUInteger deviceIDForCardHolder;


/// DoorBell的子网ID
@property (assign, nonatomic) NSUInteger subNetIDForDoorBell;

/// DoorBell的设备ID
@property (assign, nonatomic) NSUInteger deviceIDForDoorBell;


/// BedSide的子网ID
@property (assign, nonatomic) NSUInteger subNetIDForBedSide;

/// BedSide的设备ID
@property (assign, nonatomic) NSUInteger deviceIDForBedSide;



// MARK: - 公共属性

/// 建筑
@property (assign, nonatomic) NSUInteger buildID;  

/// 楼层
@property (assign, nonatomic) NSUInteger floorID;

/// 房间号
@property (assign, nonatomic) NSUInteger roomNumber;

/// 牌号
@property (assign, nonatomic) NSUInteger roomNumberDisplay;

/// 别名
@property (copy, nonatomic) NSString *roomAlias;

/// 酒店名称
@property (copy, nonatomic) NSString *hotelName;


// MARK: - 方法


+ (instancetype)roomBaseInfomationWithDictionary:(NSDictionary *)dictionary;


@end
