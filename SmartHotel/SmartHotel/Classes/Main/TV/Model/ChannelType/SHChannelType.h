//
//  SHChannelType.h
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHChannelType : NSObject

/// 类型名称
@property (copy, nonatomic) NSString *typeName;

/// 所有的频道
@property (strong, nonatomic) NSMutableArray *channels;

@end
