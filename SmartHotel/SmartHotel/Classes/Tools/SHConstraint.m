//
//  SHConstraint.m
//  Smart-Bus
//
//  Created by Mac on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#include "SHConstraint.h"

/// UIPickerView的默认高度(216)
const CGFloat pickerViewHeight = 216;

/// 自定义工具条的高度
const CGFloat customToolBarHeight = 98;


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


/// 闹钟开与关的key
NSString *alarmClockOnOffKey = @"alarmClockOnOffKey";

/// 闹钟时间字符串
NSString *alarmTimeStringKey = @"alarmTimeStringKey";

/// 闹钟时间
NSString *alarmSoundName = @"schedulesound.wav";

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
 

/// 回到首页控制器的通知
NSNotificationName SHControlGoBackHomeControllerNotification = @"SHControlGoBackHomeControllerNotification";

/// 控制器堆栈时进行隐藏 
NSNotificationName SHNavigationBarControllerPushHidderTabBarNotification = @"SHNavigationBarControllerPushHidderTabBarNotification";
