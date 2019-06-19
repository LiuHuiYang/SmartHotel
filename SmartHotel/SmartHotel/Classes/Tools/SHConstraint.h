
//
//  SHConstraint.h
//  Smart-Bus
//
//  Created by Mac on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#ifndef SHConstraint_h
#define SHConstraint_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SHRoomServerType) {
    
    SHRoomServerTypeCleanOver, // 0
    SHRoomServerTypeClean,     // 1
    SHRoomServerTypeDND,       // 2
    SHRoomServerTypeLaudry,    // 3
    SHRoomServerTypeCleanLaundry, // 4
    SHRoomServerTypeLaundring, // 5
    SHRoomServerTypeRoomReady, // 6
    
    SHRoomServerTypeMaintenance, // 0x07
    
    SHRoomServerTypeCleanShoes, // 0x08
    SHRoomServerTypeRefillMiniBar, // 0x09
    SHRoomServerTypeReadyBed, // 10 0x0A
    SHRoomServerTypeTakePlates, // 11 0x0B
    SHRoomServerTypePleaseWait, // 12 0x0C
    
    SHRoomServerTypeDoctor, // 13 0x0D
    SHRoomServerTypeMyCar,  // 14 0x0E
    SHRoomServerTypeMassage, // 15 0x0F
    SHRoomServerTypeBags,    //  16 0x10
    SHRoomServerTypeTaxi,    // 17 0x11
    SHRoomServerTypeCheckOut, // 18 0x12
    SHRoomServerTypePanic,    // 19 0x13
    SHRoomServerTypeButtler, // 20 0x14
    SHRoomServerTypeElevrtor, // 21 0x15
    
    SHRoomServerTypeTowels, // 22 0x16
    SHRoomServerTypePillow, // 23  0x17
    SHRoomServerTypeICE,    // 24 0x18
    SHRoomServerTypeBreakfast // 25 0x19
    
};

/// 控制类型
typedef NS_ENUM(Byte, SHAirConditioningControlType) {
    
    SHAirConditioningControlTypeOnAndOFF = 0X03,
    
    SHAirConditioningControlTypeCoolTemperatureSet = 0X04,
    
    SHAirConditioningControlTypeFanSpeedSet = 0X05,
    
    SHAirConditioningControlTypeAcModeSet = 0X06,
    
    SHAirConditioningControlTypeHeatTemperatureSet = 0X07,
    
    SHAirConditioningControlTypeAutoTemperatureSet = 0X08
    
} ;

/// 工作模式
typedef NS_ENUM(NSUInteger, SHAirConditioningModeKind) {
    
    SHAirConditioningModeKindCool,
    
    SHAirConditioningModeKindHeat,
    
    SHAirConditioningModeKindFan,
    
    SHAirConditioningModeKindAuto
    
} ;

/// 自定义工具条的高度
UIKIT_EXTERN const CGFloat customToolBarHeight;

/// UIPickerView的默认高度(216)
UIKIT_EXTERN const CGFloat pickerViewHeight;

/// 灯泡的最大亮度值
UIKIT_EXTERN const Byte lightMaxBrightness;

/// 导航栏高度
UIKIT_EXTERN const CGFloat navigationBarHeight;

/// 底部tabBar高度
UIKIT_EXTERN const CGFloat tabBarHeight;

/// 底部iPhoneX tabBar高度
UIKIT_EXTERN const CGFloat tabBarHeight_iPhoneX;

/// 控件的默认高度
UIKIT_EXTERN const CGFloat defaultHeight;

/// 状态栏的高度
UIKIT_EXTERN const CGFloat statusBarHeight;

/// 闹钟开与关的key
UIKIT_EXTERN NSString *alarmClockOnOffKey;

/// 闹钟时间
UIKIT_EXTERN NSString *alarmTimeStringKey;

/// 闹钟再次响铃的延迟时间
UIKIT_EXTERN NSString *alarmDelayTimeKey;

/// 闹钟时间
UIKIT_EXTERN NSString *alarmSoundName;

/// 远程登录的开关
UIKIT_EXTERN NSString *remoteControlKey;

/// 远程登录用户名
UIKIT_EXTERN NSString* loginAccout;

/// 远程登录服务名
UIKIT_EXTERN NSString* loginServices;

/// 用户指定发送数据的IP地址，没有指定使用 255
UIKIT_EXTERN NSString *socketRealIP;

/// 选择的设备网卡地址
UIKIT_EXTERN NSString *selectMacAddress;

/// 所有设备网卡地址路径
UIKIT_EXTERN NSString *allDeviceMacAddressListPath;

/// 回到首页控制器的通知
UIKIT_EXTERN NSNotificationName SHControlGoBackHomeControllerNotification;



#endif /* SHConstraint_h */


