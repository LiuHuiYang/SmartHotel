//
//  SHLight.h
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHLight : NSObject

/// 亮度值： - 这是为了保存方便【没有存储在数据库当中】
@property (nonatomic, assign) Byte brightness;

/// 灯泡子网ID
@property (nonatomic, assign) NSUInteger subnetID;

/// 灯泡设备ID
@property (nonatomic, assign) NSUInteger deviceID;


// MARK: - 数据库 中的信息

@property (assign, nonatomic) NSUInteger lightID;

@property (copy, nonatomic) NSString* lightName;

@property (assign, nonatomic) NSUInteger channelNo;

@property (assign, nonatomic) BOOL canDim;

@property (assign, nonatomic) NSUInteger lightTypeID;

@property (assign, nonatomic) NSUInteger sequenceNo;


/// 字典转模型
+ (instancetype)lightWithDictionary:(NSDictionary *)dictionary;

@end
