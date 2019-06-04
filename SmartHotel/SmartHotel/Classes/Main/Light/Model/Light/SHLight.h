//
//  SHLight.h
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 灯光设备的类型

 - SHLightTypeNotDimmable: 不可调光
 - SHLightTypeDimmable: 可调光
 - SHLightTypeLED: LED
 - SHLightTypePushOnReleaseOff: 按住开，松开关。
 */
typedef NS_ENUM(NSUInteger, SHLightType) {
    
    SHLightTypeNotDimmable,
    SHLightTypeDimmable,
    SHLightTypeLED,
    SHLightTypePushOnReleaseOff
};

@interface SHLight : NSObject

/// 亮度值： - 这是为了保存方便【没有存储在数据库当中】
@property (nonatomic, assign) Byte brightness;

/// 是否需要解析EFFF(YES - 不需要 NO 需要)
@property (nonatomic, assign) BOOL isNotNeedEFFF;

// MARK: - 数据库 中的信息

/// 灯泡设备的ID
@property (assign, nonatomic) NSUInteger lightID;

/// 灯泡设备的名称
@property (copy, nonatomic) NSString* lightName;

/// 灯泡子网ID
@property (nonatomic, assign) NSUInteger subnetID;

/// 灯泡设备ID
@property (nonatomic, assign) NSUInteger deviceID;

/// 灯泡设备的通道
@property (assign, nonatomic) NSUInteger channelNo;

/// 灯泡设备的类型
@property (assign, nonatomic) SHLightType lightType;


/// 字典转模型
+ (instancetype)lightWithDictionary:(NSDictionary *)dictionary;

@end
