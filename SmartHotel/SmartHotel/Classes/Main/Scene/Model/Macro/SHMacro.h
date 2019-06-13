//
//  SHMacro.h
//  SmartHotel
//
//  Created by Mac on 2018/4/13.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMacro : NSObject


/// Macro ID
@property (assign, nonatomic) NSUInteger macroID;

/// 宏名称
@property (copy, nonatomic) NSString* macroName;

/// 图标名称
@property (assign, nonatomic) NSString* macroIconName;


/// macro字典转换为模型
+ (instancetype)macroinitWithDictionary:(NSDictionary *)dictionary;

@end
