/*

 封装使用说明:
 
     1. 直接将UdpSocket这个文件夹中的所有内容全部拖入项目中就可以使用
 
     2. 这个工具是基于线程安全的单例
 
     3. 需要设置通知来解析它，通知的名称是一个宏 SHUdpSocketBroadcastNotification
 
     4. 通知只会把接收到的完整数据从SN2开始的二进制数据返回，不是全部返回。
 */

#import <Foundation/Foundation.h>
#import "UIDevice+IPAddresses.h"

/// UDP重发次数
extern const NSUInteger udpSocketReSendCount;

/// UDP 广播通知
extern NSString * SHUdpSocketBroadcastNotification;


@interface SHUdpSocket : NSObject

// MARK: - 发送数据与校验

/**
 发送设备指令(本地与远程)
 
 @param operatorCode 操作码(查询文档)
 @param targetSubnetID 目标子网ID(查询文档)
 @param targetDeviceID 目标设备ID(查询文档)
 @param additionalContentData 可变参数的二进制(查询文档)
 @param macAddress 远程控制使用的MacAddress (只用本地wifi控件使用 nil, 远程控制使用mac地址)
 @param needReSend 是否启动重发机制
 */
- (void)sendDataWithOperatorCode:(UInt16)operatorCode targetSubnetID:(Byte)targetSubnetID targetDeviceID:(Byte)targetDeviceID additionalContentData:(NSMutableData *)additionalContentData remoteMacAddress:(NSString *)macAddress needReSend:(BOOL)needReSend;



/**
 获得远程发送的MAC地址
 
 @return MAC地址
 */
+ (NSString *)getRemoteControlMacAddress;

/**
 校验CRC

 @param data 接收到的数据
 @return 检验结果
 */
+ (BOOL)verifyCRC:(NSData *)data;


// MARK: - 设置wifi

/// 设置本地发送指令使用的wifi
+ (BOOL)setLocalSendDataWifi:(NSString *)wifi;

/// 获得本地发送指令的wifi
+ (NSString *)getLocalSendDataWifi;

SingletonInterface(SHUdpSocket)

@end
