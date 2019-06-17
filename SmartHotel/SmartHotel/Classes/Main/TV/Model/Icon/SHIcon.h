//
//  SHIcon.h
//  SmartHotel
//
//  Created by Apple on 2019/6/14.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHIcon : NSObject

/**
 图片序号
 */
@property (assign, nonatomic) NSUInteger iconID;

/**
 图片名称
 */
@property (copy, nonatomic) NSString *iconName;

/**
 图片数据
 */
@property (copy, nonatomic) NSData *iconData;


/**
 字典转换图片模型

 @param dictionary 图片字典
 @return 图片模型
 */
+ (instancetype)iconWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
