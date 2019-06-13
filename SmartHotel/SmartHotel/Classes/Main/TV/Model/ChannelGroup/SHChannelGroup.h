//
//  SHChannelGroup.h
//  SmartHotel
//
//  Created by Apple on 2019/6/13.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHChannelGroup : NSObject

/// 电视 ID
@property (assign, nonatomic) NSUInteger tvID;

/// 分组 ID
@property (assign, nonatomic) NSUInteger groupID;

/// 分组名称
@property (copy, nonatomic) NSString* groupName;

/// 分组下的所有频道
@property (strong, nonatomic) NSMutableArray *channels;


/**
 字典转换为模型

 @param dictionary 字典
 @return 模型对象
 */
+ (instancetype)channelGroupWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
