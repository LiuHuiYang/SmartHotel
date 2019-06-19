//
//  SHDeviceParametersViewController.h
//  SmartHotel
//
//  Created by Apple on 2019/6/3.
//  Copyright © 2019 SmartHome. All rights reserved.
//

#import "SHViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHDeviceParametersViewController : SHViewController

/// 房间信息
@property (strong, nonatomic) SHRoomInfo *roomInfo;

/// light
@property (strong, nonatomic) SHLight *light;
 
/// 空调
@property (strong, nonatomic) SHHVAC *ac;

/// 窗帘
@property (strong, nonatomic) SHCurtain *curtain;

/// 电视
@property (strong, nonatomic) SHTV *tv;

/// 宏命令
@property (strong, nonatomic) SHMacroCommand *macroCommand;


@end

NS_ASSUME_NONNULL_END
