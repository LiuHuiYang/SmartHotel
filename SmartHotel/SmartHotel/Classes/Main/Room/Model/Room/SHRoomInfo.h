//
//  SHRoomInfo.h
//  SmartHotel
//
//  Created by Apple on 2019/6/17.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHRoomInfo : NSObject

/// 房间在数据库中的唯一ID
@property (assign, nonatomic) NSUInteger roomID;

/// 酒店名称
@property (copy, nonatomic) NSString* hotelName;

/// 房间标注信息
@property (copy, nonatomic) NSString* remark;

/// 建筑ID
@property (assign, nonatomic) NSUInteger buildingNumber;

/// 楼层ID
@property (assign, nonatomic) NSUInteger floorNumber;

/// 房间ID
@property (assign, nonatomic) NSUInteger roomNumber;


/// CardHolder的子网ID
@property (assign, nonatomic) NSUInteger cardHolderSubNetID;

/// CardHolder的设备ID
@property (assign, nonatomic) NSUInteger cardHolderDeviceID;

/// DoorBell的子网ID
@property (assign, nonatomic) NSUInteger doorBellSubNetID;

/// DoorBell的设备ID
@property (assign, nonatomic) NSUInteger doorBellDeviceID;

/// bedSide的子网ID
@property (assign, nonatomic) NSUInteger bedSideSubNetID;

/// bedSide的设备ID
@property (assign, nonatomic) NSUInteger bedSideDeviceID;


/// 温度传感器的子网ID
@property (assign, nonatomic) NSUInteger temperatureSubNetID;

/// 温度传感器的设备ID
@property (assign, nonatomic) NSUInteger temperatureDeviceID;

/// 温度传感器的通道
@property (assign, nonatomic) NSUInteger temperatureChannelNo;

/// 房间字典转换模型
+ (instancetype)roomInfoWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
