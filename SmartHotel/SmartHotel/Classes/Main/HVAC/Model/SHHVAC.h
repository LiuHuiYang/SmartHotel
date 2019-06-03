//
//  SHHVAC.h
//  SmartHotel
//
//  Created by Apple on 2019/5/31.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHHVAC : NSObject
    
/**
 空调的类型
 */
@property (assign, nonatomic) NSUInteger acID;

/**
 空调名称
 */
@property (copy, nonatomic) NSString* acName;

   
/**
 空调的类型
 */
@property (assign, nonatomic) NSUInteger acType;
    
    
/**
空调号, 保留参数
*/
@property (assign, nonatomic) NSUInteger acNumber;
    
    
/**
 空调的子网ID
 */
@property (assign, nonatomic) NSUInteger subnetID;
    
    
/**
 空调的设备ID
 */
@property (assign, nonatomic) NSUInteger deviceID;
    

/**
 空调的通道号 (继电器控制方式有用)
 */
@property (assign, nonatomic) NSUInteger channelNo;
    

    
/**
 字典转换成模型

 @param dictionary 字典
 @return 模型
 */
+ (instancetype)airConditionerWithDictionary:(NSDictionary *)dictionary;
    

@end

NS_ASSUME_NONNULL_END
