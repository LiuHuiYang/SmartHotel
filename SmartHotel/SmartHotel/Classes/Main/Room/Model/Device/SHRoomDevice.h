//
//  SHRoomDevice.h
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 标注不同的设备类型
 */
typedef NS_ENUM(NSUInteger, SHDeviceType)
{
    SHDeviceTypeDoorBell = 5000,
    SHDeviceTypeCardHolder = 5010,
    SHDeviceTypeZoneBeast = 5020,
    SHDeviceTypeBedside = 5030,
    SHDeviceTypeAuxPower = 5040,
    SHDeviceTypeDDP = 5070,
    SHDeviceTypeIR = 5080,
    SHDeviceTypeZAudio = 5090,
    SHDeviceTypeCurtain = 5100,
} ;

@interface SHRoomDevice : NSObject

/// 建筑ID
@property (assign, nonatomic) NSUInteger buildingID;

/// 楼层ID
@property (assign, nonatomic) NSUInteger floorID;

/// 房间号
@property (assign, nonatomic) NSUInteger roomNo;

/// 设备类型
@property (assign, nonatomic) SHDeviceType deviceType;

/// 子网ID
@property (assign, nonatomic) NSUInteger subnetID;

/// 设备ID
@property (assign, nonatomic) NSUInteger deviceID;

/// 设备号
@property (assign, nonatomic) NSUInteger deciceNO;

/// 建筑名称
@property (copy, nonatomic) NSString *buildingName;

/// 房间名称
@property (copy, nonatomic) NSString * roomName;

/// 设备名称
@property (copy, nonatomic) NSString * deviceRemark;

/// 字典转换为模型
+ (instancetype)roomDeviceWithDictionary:(NSDictionary *)dictionary;

@end
