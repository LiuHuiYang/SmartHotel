//
//  SHOperatorCode.m
//  Smart-Bus
//
//  Created by Mark Liu on 2017/6/28.
//  Copyright © 2017年 Mark Liu. All rights reserved.
//

#import "SHOperatorCode.h"

@implementation SHOperatorCode

/**
 通过模型的指令类型获得操作码
 
 @param commandTypeID  指令类型
 @return 操作码
 */
+ (UInt16) getOperatorCode:(NSUInteger)commandTypeID {
    
    switch (commandTypeID) {
        case 0:
            return 0X0002;  // 2个可变参数
            break;
            
        case 1:
        case 5:
            return 0X001A;  // 2个可变参数
            break;
            
        case 2:
        case 9:
            return 0xE01C;  // 2个可变参数
            break;
            
        case 4:
        case 6:
            return 0X0031;  // 4
            break;
            
        case 7:
            return 0XE3E0;  // 2个参数
            break;
            
        case 8:
            return 0x192E; // 8个可变参数
            break;
            
        case 10:
            return 0xE3D8;  // 2
            break;
            
        case 18:
            return 0x0218; // 4
            break;
            
        case 11:
            return 0x0104; // 2
            break;
            
        case 12:
        case 13:
        case 14:
        case 15:
        case 16:
        case 17:
            return 0x010C; // 4
            break;
            
        case 30:
            return 0XF080; // 6
            break;
            
        default:
            return 0;
            break;
    }
}

@end

