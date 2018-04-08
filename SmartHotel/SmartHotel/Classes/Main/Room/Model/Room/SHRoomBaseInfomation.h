//
//  SHRoomBaseInfomation.h
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHRoomBaseInfomation : NSObject

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


+ (instancetype)roomBaseInfomationWithDictionary:(NSDictionary *)dictionary;


@end
