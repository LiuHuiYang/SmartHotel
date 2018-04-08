//
//  SHModelViewController.h
//  SmartHotel
//
//  Created by Mac on 2018/4/8.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#import "SHViewController.h"
#import "SHRoomBaseInfomation.h"


@interface SHModelViewController : SHViewController

/// 房间信息
@property (strong, nonatomic) SHRoomBaseInfomation *roomInfo;

@end
