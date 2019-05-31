

#import "SHUdpSocket.h"
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

/// 重发次数
const NSUInteger udpSocketReSendCount = 3;

/// UDP 广播通知
NSString * SHUdpSocketBroadcastNotification = @"SHUdpSocketBroadcastNotification";

//----------相关的终端参数（暂时不变）----------------

/// 发送数据的方式
NSString *SHUdpSocketSendDataTypeValue = @"SHUdpSocketSendDataTypeValue";

/// 记录的wifi(Server时有效)
NSString *SHUdpSocketSendDataLocalWifi = @"SHUdpSocketSendDataLocalWifi";

/// 远程设备类型标示
const Byte iOS_Flag = 0X02;

/// 本地wifi
NSString *Local_Server_IP_Default = @"255.255.255.255";

/// 远程域名
NSString *Remote_Server_DoMain_Name = @"smartbuscloud.com";

// 绑定本地端口
const UInt16 Local_Server_PORT = 6000;

// 绑定远程端口
const UInt16 Remote_Server_PORT = 8888;

// 最后收到的最小有效数据长度
const NSUInteger reciveDataLength = 27;

// 数据包的前16个固定字节数(源IP + 协议头 + 开始的操作码 --> 不影响解析，所以去除)
const NSUInteger subReciveDataLength = 16;

// 源终端子网ID
const Byte originalSubnetID = 0XBB;

// 源终端设备ID
const Byte originalDeviceID = 0XBB;

// 源终端设备类型
const UInt16 originalDeviceType = 0XCCCC;

/// 获得CRC
void pack_crc(Byte *ptr, unichar len);


@interface SHUdpSocket () <GCDAsyncUdpSocketDelegate>

/// 内容使用的通信socket
@property(nonatomic,strong)GCDAsyncUdpSocket *socket;

/// 发送的设备ID
@property (assign, nonatomic) Byte sendSubNetID;

/// 发送的子网ID
@property (assign, nonatomic) Byte sendDeviceID;

/// 操作返回的操作码
@property (nonatomic, assign) UInt16 returnOperatorCode;

@end

@implementation SHUdpSocket

// MARK: - 代理回调

/**
 接收到服务器返回的数据
 
 @param sock socket
 @param data 接收的数扰
 @param address 地址信息
 @param filterContext 过滤上下文
 */
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    if (data.length < reciveDataLength) { // 达到最低长度的字节
        return;
    }
    
    // 准备好发送数据 只要SN2(包括)以后的内容 (总长度 - 16) (源IP + 协议头 + 开始的操作码统统不要)
    NSData *sendData = [NSData dataWithBytes:(((Byte *) [data bytes]) + subReciveDataLength) length:data.length - subReciveDataLength];
    
    // 记录一些参数方便重发使用
    Byte *recivedData = ((Byte *) [sendData bytes]);
    self.returnOperatorCode = ((recivedData[5] << 8) | recivedData[6]);
    self.sendSubNetID = recivedData[1];
    self.sendDeviceID = recivedData[2];
    
    // 主线程 -〉发送广播 设置UI
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHUdpSocketBroadcastNotification object:sendData];
    });
}

/// socket关闭
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    
    //    SHLog(@"socket关闭 :%@", error);
    [self.socket close];
    self.socket = nil;
    
    [self.socket enableBroadcast:YES error:&error];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    
    // SHLog(@"发送失败");
}

// MARK: - 发送指令


/**
 当前是否使用远程发送数据包的方式
 
 @param macAddress mac地址
 @return 使用方式 NO: 使用本地方式, YES 使用远程
 */
- (BOOL)isRemoteControl:(NSString *)macAddress {
    
    // 用于模拟器调试
    if (TARGET_IPHONE_SIMULATOR) {
        return NO;
    }
    
    // 1. 当前设备没有wifi --> 没有 使用远程
    // 获得当前的wifi
    NSString *currentWifi = [NSString stringWithFormat:@"%@", [UIDevice getWifiName]];
    
    if ([currentWifi isEqualToString:@"(null)"] || !currentWifi) {
        
        // 如果指定了IP 使用本地
        if ([[NSUserDefaults standardUserDefaults] objectForKey:socketRealIP]) {
            
            return NO; // 使用本地wifi的方式
        }
        
        return YES;
    }
    
    // 2.是否开启了远程
    if (![[NSUserDefaults standardUserDefaults] boolForKey:remoteControlKey]) {
        return NO; // 本地
    }
    
    // 3.开启了远程，是否有mac地址
    if (!macAddress) {
        return NO;
    }
    
    // 4.开启远程 && 存在 mac 地址
    
    // 获得保存的wifi
    NSString *saveLocalWifi = [[NSUserDefaults standardUserDefaults] objectForKey:SHUdpSocketSendDataLocalWifi];
    
    /// 没有保存wifi并且保存了指定IP
    if (!saveLocalWifi && ([[NSUserDefaults standardUserDefaults] objectForKey:socketRealIP])) {
        
        return NO; // 使用本地格式
    }
    
    //  当前存在wifi --> 与保存wifi相同 -- 相同，否则-使用远程
    return !([saveLocalWifi isEqualToString:currentWifi]);
}

/**
 发送设备指令
 
 @param operatorCode 操作码(查询文档)
 @param targetSubnetID 目标子网ID(查询文档)
 @param targetDeviceID 目标设备ID(查询文档)
 @param additionalContentData 可变参数的二进制(查询文档)
 @param macAddress 远程控制使用的MacAddress (只用本地wifi控件使用 nil, 远程控制使用mac地址)
 @param needReSend 是否启动重发机制
 */
- (void)sendDataWithOperatorCode:(UInt16)operatorCode targetSubnetID:(Byte)
    targetSubnetID targetDeviceID:(Byte)targetDeviceID additionalContentData:
    (NSMutableData *)additionalContentData  remoteMacAddress:(NSString *)
    macAddress needReSend:(BOOL)needReSend{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        Byte sendDataCount = 0;
        
        /// 重发机制的起点
    RE_SEND_POINT:
        
        [self sendDataWithOperatorCode:operatorCode targetSubnetID:targetSubnetID
            targetDeviceID:targetDeviceID additionalContentData: additionalContentData remoteMacAddress:macAddress];

        if (!needReSend) {
            return ;
        }
        
        NSDate *startSendDate = [NSDate date];
        
        while ((operatorCode + 1) != self.returnOperatorCode || targetSubnetID
               != self.sendSubNetID || self.sendDeviceID != targetDeviceID) {
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:
                [NSDate dateWithTimeIntervalSinceNow:0.003]];
            
            NSDate *finishedSendDate = [NSDate date];
            
            if ([finishedSendDate timeIntervalSinceDate:startSendDate] >= 0.7) {
                
                sendDataCount += 1;
                
                if ( sendDataCount <= udpSocketReSendCount) {
                    
                    printLog(@"重发一次： %d", sendDataCount);
                    goto RE_SEND_POINT;
                    
                } else {
                    
                    goto EXIT_POINT;
                }
            }
        }
        
        // 重发机制结束
    EXIT_POINT:
        printLog(@"结束操作");
        return ;
        
    });
}

/**
 发送设备指令
 
 @param operatorCode 操作码(查询文档)
 @param targetSubnetID 目标子网ID(查询文档)
 @param targetDeviceID 目标设备ID(查询文档)
 @param additionalContentData 可变参数的二进制(查询文档)
 @param macAddress 远程控制使用的MacAddress (只用本地wifi控件使用 nil, 远程控制使用mac地址)
 */
- (void)sendDataWithOperatorCode:(UInt16)operatorCode targetSubnetID:(Byte)
    targetSubnetID targetDeviceID:(Byte)targetDeviceID additionalContentData:
    (NSMutableData *)additionalContentData remoteMacAddress:(NSString *)
    macAddress {
    
    // 依据手机环境 自动设置使用远程还是本地
//    BOOL isRemoteControl = [self isRemoteControl:macAddress];
    
    // 注意：当前项目不需要远程
    BOOL isRemoteControl = NO;
    
    // 发送的数据包: 目标ip + 固定协议头 + 基础协义部分protocolBaseStructure
    
    // =========== 1. 获得整个数据包的内容大小 ===========
    
    // 1.1 获得目标ip的大小 (远程 && 本地) 【固定】
    NSArray *ipArray = isRemoteControl ? ([UIDevice deviceIPAddressArray: [UIDevice getIPAddressByHostName:Remote_Server_DoMain_Name]]) : ([UIDevice deviceIPAddressArray:[UIDevice getIPAddress:[UIDevice isIPV6]]]);
    
    // 1.2 固定协议头 【固定】
    // 发送协议的数据包头  数据包的下标 4 ~ 13 是协议头，固定 udpPckageHead数组
    const Byte udpPckageHeadArray[] = {0x53, 0x4D, 0x41, 0x52, 0x54, 0x43, 0x4C,
            0x4F, 0x55, 0x44};
    
    // 1.3 UDP Package Head + SoureceIP  的长度【固定】
    const NSUInteger protocolPackageAndSourceIPLength = ipArray.count +
        sizeof(udpPckageHeadArray);
    
    // 1.4 可变参数的长度
    const NSUInteger additionalContentLength = [additionalContentData length];
    
    // 1.5 mac地址的长度
    NSString *macString = [macAddress stringByReplacingOccurrencesOfString:@"."
                                                            withString:@""];
    Byte macAddressArray[macString.length/2];
    
    // 转换为十六进制数组
    for (NSUInteger i = 0; i < macString.length/2; i++) {
        
        unsigned long res =
            strtoul([[macString substringWithRange: NSMakeRange(i * 2, 2)] UTF8String], 0, 16);
        
        macAddressArray[i] = (Byte)res;
    }
    
    const NSUInteger remoteDataLength =
        isRemoteControl ? (1 + sizeof(macAddressArray)) : 0; // 1 表示设备标示符
    
    // 1.5 Protocol Base Structure 协议数据包的长度
    // 远程:(固定部分11 + additionalContentLength + (1个标示位 + 8个mac地地址) +  2个 0x00, 0x00)
    // 本地:(固定部分11 + additionalContentLength + 2个 CRC)
    NSUInteger protocolBaseStructureLength = 11 + additionalContentLength +
        remoteDataLength + 2;
    
    // 1.6 数据包的总大小
    NSUInteger sendUDPBufLength = protocolPackageAndSourceIPLength +
        protocolBaseStructureLength;
    
    // =========== 2. 逐个赋值 ===========
    
    // 声明发送数据包
    Byte maraySendUDPBuf[sendUDPBufLength];

    // 2.1 设置目标ip ip地址
    NSUInteger index = 0;
    while (index < ipArray.count) {

        maraySendUDPBuf[index++] = [ipArray[index] integerValue] & 0xFF;
    }
    
    // 2.2  协议头 固定 udpPckageHead数组
    for (NSUInteger i = 0; i  < sizeof(udpPckageHeadArray); i++) {
        maraySendUDPBuf[index++] = udpPckageHeadArray[i];
    }
    
    // 2.3 Protocol Base Structure 部分
    
    // 2.3.1  开始代码: 0XAAAA固定
    maraySendUDPBuf[index++] = 0xAA;
    maraySendUDPBuf[index++] = 0xAA;
    
    // 2.3.2 数据包的长度  -- 计算(SN2 ~ 10)
    maraySendUDPBuf[index++] = (protocolBaseStructureLength - 2) & 0xFF; // -2 是不含 SN1的内容
    
    // 2.3.3 手机的子网ID
    maraySendUDPBuf[index++] = originalSubnetID & 0xFF;
    // 2.3.4 手机的设备ID
    maraySendUDPBuf[index++] = originalDeviceID & 0xFF;
    
    // 2.3.5 设备类型
    maraySendUDPBuf[index++] = (originalDeviceType >> 8) & 0xFF;
    maraySendUDPBuf[index++] = (originalDeviceType & 0xFF);
    
    // 2.3.6 操作码
    maraySendUDPBuf[index++] = (operatorCode >> 8) & 0xFF; // 高8位
    maraySendUDPBuf[index++] = (operatorCode & 0xFF); // 低8位
    
    // 2.3.7 目标设备的子网ID与设备ID
    maraySendUDPBuf[index++] = targetSubnetID & 0xFF;
    maraySendUDPBuf[index++] = targetDeviceID & 0xFF;
    
    // 2.3.8 可变参数
    for (NSUInteger i = 0; i < additionalContentLength; i++) {
        maraySendUDPBuf[index++] = (((Byte *)[additionalContentData bytes])[i]) & 0xFF;
    }
    
    // 2.3.9 不同部的部分
    if (isRemoteControl) {  // 远程部分
        
        maraySendUDPBuf[index++] = iOS_Flag;
        
        for (NSUInteger i = 0; i < sizeof(macAddressArray); i++) {
            maraySendUDPBuf[index++] = (macAddressArray[i]);
        }
     
        maraySendUDPBuf[index++] = 0;
        maraySendUDPBuf[index++] = 0;
        
    } else {  // 本地部分
        
        // 校验码  -- 由CRC算法来生成
        // 第一个参数：整个数据包的中Protocol Base Structure部分的LEN of Data Package的地址
        // 第二个参数：从【Protocol Base Structure】数据的总大小 - CRC的两个字节(cRCLength) - Start code的大小(2个字节)
        pack_crc(&(maraySendUDPBuf[protocolPackageAndSourceIPLength + 2]),
                 protocolBaseStructureLength - 2 - 2);
    }
    
    // =========== 3.初始化发送条件 ===========
    
//    printLog(@"========准备发送的数据包==开始======");
//
//    for (Byte i = 0; i < sendUDPBufLength; i++) {
//
//         printf(" %#02X ", maraySendUDPBuf[i]);
//    }
//    printLog(@"========准备发送的数据包==结束======");
    
    // 准备发送的参数
    NSData *sendMessageData = [[NSData alloc] initWithBytes:maraySendUDPBuf length:sizeof(maraySendUDPBuf)];
    
    NSString *local_send_IP =
        [[NSUserDefaults standardUserDefaults] objectForKey:socketRealIP];
    
    NSString *hostAddress = isRemoteControl ?
        [UIDevice getIPAddressByHostName:Remote_Server_DoMain_Name] :
        (local_send_IP ? local_send_IP : Local_Server_IP_Default);
    
    UInt16 port = isRemoteControl ? Remote_Server_PORT : Local_Server_PORT;
    
    
    //        printLog(@"目标地址: %@ - 发送端口号", hostAddress );
    
    // =========== 4.发送与接收(注意端口不同) ===========
    // 修改监听端口
    [self.socket bindToPort:port error:nil];
    
    // UDP通信永远是不连接的所以用下面的方法来发送
    [self.socket sendData:sendMessageData toHost:hostAddress port:port
                withTimeout:-1 tag:0];
    
    // 接收数据
    [self.socket beginReceiving:nil];
}


/**
 获得远程发送的MAC地址

 @return MAC地址
 */
+ (NSString *)getRemoteControlMacAddress {

//    printLog(@"注意，这个项目暂时没有远程功能");
    return nil;
//    return [[NSKeyedUnarchiver unarchiveObjectWithFile:[[FileTools documentPath] stringByAppendingPathComponent:selectMacAddress]] macAddress];
}


// MARK: - CRC校验码的获取列表与方法 -- 直接使用，不需要修改

// CRC 校验码查询数据的数组表格
const UInt16  CRC_TAB[] = {           /* CRC tab */
    0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7,
    0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef,
    0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6,
    0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de,
    0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485,
    0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d,
    0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4,
    0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc,
    0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823,
    0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b,
    0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12,
    0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a,
    0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41,
    0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49,
    0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70,
    0xFF9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78,
    0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f,
    0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067,
    0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e,
    0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256,
    0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d,
    0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405,
    0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c,
    0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634,
    0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab,
    0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3,
    0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a,
    0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92,
    0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9,
    0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1,
    0xef1f, 0xFF3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8,
    0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0
};

/**
 校验CRC
 
 @param data 接收到的数据
 */
+ (BOOL)verifyCRC:(NSData *)data {
    
    Byte *receiveBytes = (Byte *)[data bytes];
    
    NSUInteger lengthBytes = [data length];
    
    Byte hightByte = receiveBytes[lengthBytes - 2];
    
    Byte lowByte = receiveBytes[lengthBytes - 1];
    
    pack_crc(&receiveBytes[0], lengthBytes-2);
    
    return (hightByte == receiveBytes[lengthBytes - 2] &&
            lowByte == receiveBytes[lengthBytes - 1]);
}

/**
 获得CRC
 
 @param ptr 结果地址: 是基础协议数据包中除了0XAAAA后开始的地址
 @param len 长度: ptr所对应的地址开始的数组再-2个字节（不要CRC的2个字节）
 */
void pack_crc(Byte *ptr, unichar len) {
    
    // 准备两个字节来存储 CRC
    unsigned short crc = 0;
    
    Byte dat = 0;
    
    while(len-- != 0) {  // 长度有效
        
        dat = crc >> 8;
        
        crc <<= 8;
        
        crc ^= CRC_TAB[dat ^ *ptr];
        
        ptr++;
    }
    
    *ptr = crc >> 8;
    
    ptr++;
    
    *ptr = crc;
}

// MARK: -  初始化

/// 为了触发懒加载
- (instancetype)init {
    if (self = [super init]) {
        
        [self.socket localPort];
    }
    return self;
}

/**
 初始化socket
 */
- (GCDAsyncUdpSocket *)socket {
    
    if (!_socket) {
        
        // 初始化
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        
        // 支持iPV4 && IPV6
        [_socket setIPv4Enabled:YES];
        [_socket setIPv6Enabled:YES];
        
        _socket.delegate = self;
        
        // 一定要打开广播功能
        if (![_socket enableBroadcast:YES error:nil]) {
            
            return nil;
        }
        
        // 接收数据
        if (![_socket beginReceiving:nil]) {
            return nil;
        }
    }
    return _socket;
}


// MARK: - wifi操作

/**
 设置本地发送指令使用的wifi
 
 @param wifi wifi名称
 */
+ (BOOL)setLocalSendDataWifi:(NSString *)wifi {
  
    [[NSUserDefaults standardUserDefaults] setObject:wifi forKey:SHUdpSocketSendDataLocalWifi];
    
    return [[NSUserDefaults standardUserDefaults] synchronize];
}


/**
 获得本地发送指令的wifi
 
 @return wifi名称
 */
+ (NSString *)getLocalSendDataWifi {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:SHUdpSocketSendDataLocalWifi];
}

// MARK: - 单例代码

SingletonImplementation(SHUdpSocket)

@end

