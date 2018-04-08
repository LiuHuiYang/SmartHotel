
//
//  SHConstraint.h
//  Smart-Bus
//
//  Created by Mark Liu on 2018/3/15.
//  Copyright © 2018年 SmartHome. All rights reserved.
//

#ifndef SHConstraint_h
#define SHConstraint_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(Byte, SHRoomServerType) {
    
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


/**
 标注不同的设备类型
 */
typedef NS_ENUM(NSUInteger, SHDeviceType)
{
    SHDevTypeDoorBell = 5000,
    SHDevTypeCardHolder = 5010,
    SHDevTypeZoneBeast = 5020,
    SHDevTypeBedside = 5030,
    SHDevTypeAuxPower = 5040,
    SHDevTypeDDP = 5070,
    SHDevTypeIR = 5080,
    SHDevTypeZAudio = 5090,
    SHDevTypeCurtain = 5100,
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

/// 允许修改区域设备是否允许的key
UIKIT_EXTERN NSString *authorChangeDeviceisAllow;

/// 启与关闭修改设备配置的密码的key
UIKIT_EXTERN NSString *authorChangeDevicePasswordKey;

/// 计划保存的通知
UIKIT_EXTERN NSString *SHSchedualSaveDataNotification;

/// 计划执行的通知
UIKIT_EXTERN NSString *SHSchedualPrepareExecuteNotification;

/// 回到首页控制器的通知
UIKIT_EXTERN NSString *SHControlGoBackHomeControllerNotification;


#endif /* SHConstraint_h */


