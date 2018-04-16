//
//  SHChannelType.m
//  SmartHotel
//
//  Created by Mac on 2018/4/16.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHChannelType.h"

@implementation SHChannelType

 
/// 保证外界有值 
- (NSMutableArray *)channels {
    
    if (!_channels) {
        
        _channels = [NSMutableArray array];
    }
    
    return _channels;
}

@end
