//
//  SHOperatorCode.h
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHOperatorCode : NSObject


/**
 通过模型的指令类型获得操作码

 @param commandTypeID  指令类型
 @return 操作码
 */
+ (UInt16) getOperatorCode:(NSUInteger)commandTypeID;

@end
