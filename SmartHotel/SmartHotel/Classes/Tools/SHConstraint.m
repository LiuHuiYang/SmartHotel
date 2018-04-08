//
//  SHConstraint.m
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#include "SHConstraint.h"

/// 自定义工具条的高度
const CGFloat customToolBarHeight = 98;

/// UIPickerView的默认高度(216)
const CGFloat pickerViewHeight = 216;

/// 灯泡的最大亮度值
const Byte lightMaxBrightness= 100;

/// 导航栏高度
const CGFloat navigationBarHeight = 64;

/// 底部tabBar高度
const CGFloat tabBarHeight = 49;

/// 底部iPhoneX tabBar高度
const CGFloat tabBarHeight_iPhoneX = 83;

/// 控件的默认高度
const CGFloat defaultHeight = 44;

/// 状态栏的高度
const CGFloat statusBarHeight = 20;

 
/// 远程登录的开关
NSString *remoteControlKey = @"SHTurnOnRemoteControlKey";

/// 远程登录用户名
NSString* loginAccout = @"SHRemoteTelnetAccount";

/// 远程登录服务名
NSString* loginServices = @"SHRemoteTelnetServices";

/// 用户指定发送数据的IP地址，没有指定使用 255
NSString *socketRealIP = @"SHUdpSocketSendDataRealIPAddress";

/// 选择的设备网卡地址
NSString *selectMacAddress = @"SHSelectDeviceMacAddress.data";

/// 所有设备网卡地址路径
NSString *allDeviceMacAddressListPath = @"AllDeviceList.plist";


/// 允许修改区域设备是否允许的key
NSString *authorChangeDeviceisAllow = @"SHAuthorChangeDeviceisAllow";

/// 启与关闭修改设备配置的密码的key
NSString *authorChangeDevicePasswordKey = @"SHAuthorChangeDevicePasswordKey";

/// 计划保存的值
NSString *SHSchedualSaveDataNotification = @"SHSchedualSaveDataNotification";

/// 计划执行的通知
NSString *SHSchedualPrepareExecuteNotification = @"SHSchedualPrepareExecuteNotification";

/// 回到首页控制器的通知
NSString *SHControlGoBackHomeControllerNotification = @"SHControlGoBackHomeControllerNotification";
