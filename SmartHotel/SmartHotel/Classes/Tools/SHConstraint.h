
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
    
    SHRoomServerTypeCleanOver,
    SHRoomServerTypeClean,
    SHRoomServerTypeDND,
    SHRoomServerTypeLaudry,
    SHRoomServerTypeCleanLaundry,
    SHRoomServerTypeLaundring,
    SHRoomServerTypeRoomReady,
    SHRoomServerTypeMaintenance,
    
    SHRoomServerTypeCleanShoes,
    SHRoomServerTypeRefillMiniBar,
    SHRoomServerTypeReadyBed,
    SHRoomServerTypeTakePlates,
    SHRoomServerTypePleaseWait,
    
    SHRoomServerTypeDoctor,
    SHRoomServerTypeMyCar,
    SHRoomServerTypeMassage,
    SHRoomServerTypeBags,
    SHRoomServerTypeTaxi,
    SHRoomServerTypeCheckOut,
    SHRoomServerTypePanic,
    SHRoomServerTypeButtler,
    SHRoomServerTypeElevrtor,
    
    SHRoomServerTypeTowels,
    SHRoomServerTypePillow,
    SHRoomServerTypeICE,
    SHRoomServerTypeBreakfast
    
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

/// 控制器堆栈时进行隐藏
UIKIT_EXTERN NSNotificationName SHNavigationBarControllerPushHidderTabBarNotification;


#endif /* SHConstraint_h */


