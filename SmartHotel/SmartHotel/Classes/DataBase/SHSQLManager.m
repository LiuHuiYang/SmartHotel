//
//  SHSQLManager.m
//  SmartHotel
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import "SHSQLManager.h"
#import <FMDB/FMDB.h>

/// 数据库的名称
NSString *dataBaseName = @"SmartHotel.sqlite";

@interface SHSQLManager ()

/// 全局操作队列
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation SHSQLManager


// MARK: - Curtain


/**
 更新窗帘对象

 @param curtain 窗帘对象
 @return 更新成功YES, 失败 NO.
 */
- (BOOL)updateCurtain:(SHCurtain *)curtain {
    
    NSString *sql =
        [NSString stringWithFormat:
         @"update Curtains set curtainName = '%@', curtainType = %zd, subnetID = %zd, deviceID = %zd, openChannel = %zd, closeChannel = %zd, stopChannel = %zd, switchIDforOpen = %zd, switchIDforClose = %zd, switchIDforStop = %zd where curtainID = %zd;",
         
            curtain.curtainName,
            curtain.curtainType,
            curtain.subnetID,
            curtain.deviceID,
            curtain.openChannel,
            curtain.closeChannel,
            curtain.stopChannel,
            curtain.switchIDforOpen,
            curtain.switchIDforClose,
            curtain.switchIDforStop,
            curtain.curtainID
         ];
    
    return [self executeSql:sql];
}


/**
 删除窗帘对象

 @param curtain 窗帘对象
 @return 删除成功YES, 失败 NO.
 */
- (BOOL)deleteCurtain:(SHCurtain *)curtain {
    
    NSString *sql =
    [NSString stringWithFormat:
        @"delete from Curtains Where curtainID = %zd and subnetID = %zd and deviceID = %zd;",
     
        curtain.curtainID,
        curtain.subnetID,
        curtain.deviceID
     ];
    
    return [self executeSql:sql];
}

/**
 增加一个新的窗帘

 @param curtain 窗帘对象
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertCurtain:(SHCurtain *)curtain {
    
    NSString *sql =
    [NSString stringWithFormat:
        @"insert into Curtains (curtainID, curtainName, curtainType, subnetID, deviceID, openChannel, closeChannel, stopChannel, switchIDforOpen, switchIDforClose, switchIDforStop) values(%zd, '%@', %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd);",
     
        curtain.curtainID,
        curtain.curtainName,
        curtain.curtainType,
        curtain.subnetID,
        curtain.deviceID,
        curtain.openChannel,
        curtain.closeChannel,
        curtain.stopChannel,
        curtain.switchIDforOpen,
        curtain.switchIDforClose,
        curtain.switchIDforStop
     ];
    
    
    return [self executeSql:sql];
}


/**
 查询当前所有的窗帘

 @return 窗帘数组
 */
- (NSMutableArray *)getCurtains {
    
    NSString *sql =
        [NSString stringWithFormat:@"select curtainID, curtainName, curtainType, subnetID, deviceID, openChannel, closeChannel, stopChannel, switchIDforOpen, switchIDforClose, switchIDforStop from Curtains;"];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *curtains =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [curtains addObject:
            [SHCurtain curtainWithDictionary:dict]
        ];
    }
    
    return curtains;
}

/**
 获得一个可用的窗帘编号

 @return 返回可以直接使用的窗帘编号
 */
- (NSUInteger)getAvailableCurtainID {
    
    // "select max(ShadeID) from ShadeInZone " +
    // "where ZoneID = \(zoneID);"
    
    NSString *sql =
        [NSString stringWithFormat:@"select max(curtainID) from Curtains;"];
    
    NSDictionary *dict =
        [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(curtainID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger curtainID =
        [[dict objectForKey:@"max(curtainID)"]integerValue] + 1;
    
    return curtainID;
}


// MARK: - 旧代码


/// 更新房间设备信息
- (BOOL)updateRoomDevice:(SHRoomDevice *)device {
    
    /// 删除这个房间中的这个设备模块(同一类型只有一个)
    NSString *deleteSQL = [NSString stringWithFormat:@"delete from CurrentRoomDevices   \
                           where BuildingID = %zd and FloorID = %zd and RoomNo = %zd    \
                           and DeviceType = %zd;",
                            device.buildingID, device.floorID, device.roomNo, device.deviceType];
    
    [self executeSql:deleteSQL];
    
    
    NSString *insertSQL = [NSString stringWithFormat:@"insert into CurrentRoomDevices   \
                        (BuildingID , FloorID, RoomNo, DeviceType, SubnetID, DeviceID, \
                           DeciceNO, BuildingName, RoomName, DeviceRemark) \
                           values(%zd, %zd, %zd, %zd, %zd, %zd, %zd, '%@', '%@', '%@')",
                           device.buildingID, device.floorID, device.roomNo, device.deviceType,
                           device.subnetID, device.deviceID, device.deciceNO, device.buildingName,
                           device.roomName, device.deviceRemark];
    
    return [self executeSql:insertSQL];
}

/// 更新房间信息
- (BOOL)updateRoomInfo:(SHRoomBaseInfomation *)roomInfo {
    
    //   因为只有一个房间，所以是全部数据都更新
    
    NSString *updateSQL = [NSString stringWithFormat:@"update SHRoomBasicInfo set \
                           SHBuildID = %zd, SHFloorID = %zd, SHRoomNumber = %zd, \
                           SHRoomNumberDisplay = %zd, SHRoomAlias = '%@',       \
                           SHHotelName = '%@';", roomInfo.buildID, roomInfo.floorID,
                           roomInfo.roomNumber, roomInfo.roomNumberDisplay,
                           roomInfo.roomAlias, roomInfo.hotelName];
    
    
    return [self executeSql:updateSQL];
}

/// 获得指定电视的频道类型
- (NSMutableArray *)getAllChannelTypes:(SHTV *)tv {
    
    // 1.先找出所有的种类
    NSString *typeSQL = [NSString stringWithFormat:@"select distinct SHChannelType from SHTVChannels where SHTVID = %zd;", tv.tvID];
    
    NSArray *typeArray = [self selectProprty:typeSQL];
    
    NSMutableArray *types = [NSMutableArray arrayWithCapacity:typeArray.count];
    
    for (NSDictionary *typeDict in typeArray) {
        
        SHChannelType *channelType = [[SHChannelType alloc] init];
        channelType.typeName = [typeDict objectForKey:@"SHChannelType"];
        
        // 查询对应的所有频道
//        printLog(@"当前字典: %@", dict);
        NSString *channelSQL = [NSString stringWithFormat:@"select SHTVID, SHChannelType, SHChannelID, ChannelName, ChannelIRNumber, ChannelIconID, SubnetID, DeviceID, DelayTimeBetweenTowIRMillisecend from SHTVChannels where SHChannelType = '%@' and SHTVID = %zd order by SHChannelID;", channelType.typeName, tv.tvID];
        
        NSArray *channelArray = [self selectProprty:channelSQL];
        
        NSMutableArray *channels = [NSMutableArray arrayWithCapacity:channelArray.count];
        
        for (NSDictionary *channelDict in channelArray) {
            
//            printLog(@"==== %@", channelDict);
            [channels addObject: [SHChannel channelWithDictionary:channelDict]];
        }
        
        channelType.channels = channels;
        
        [types addObject:channelType];
    }
    
    return types;
}

/// 获得房间的电视
- (NSMutableArray *)getTV {
    
    NSString *selectSQL = @"select SHCTVID, TVName, TVType, SubnetID, DeviceID, \
        OpenUniversalSwitchID, CloseUniversalSwitchID, MuteOnUniversalSwitchID, \
        MuteOffUniversalSwitchID, VolUpUniversalSwitchID, VolDownUniversalSwitchID, \
        ChannelUpUniversalSwitchID, ChannelDownUniversalSwitchID, OKUniversalSwitchID, \
        UniversalSwitchIDFor1, UniversalSwitchIDFor2, UniversalSwitchIDFor3, \
        UniversalSwitchIDFor4, UniversalSwitchIDFor5, UniversalSwitchIDFor6, \
        UniversalSwitchIDFor7, UniversalSwitchIDFor8, UniversalSwitchIDFor9, \
    UniversalSwitchIDFor0, OpenIrMacroNo, CloseMactroNo from SHTV;";
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *tvs = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [tvs addObject:[SHTV tvWithDictionary:dict]];
    }
    
    return tvs;
}


/// 获得指定种类的灯泡
- (NSMutableArray *)getLight:(BOOL)canDim {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select LightID, LightName, ChannelNo, CanDim, LightTypeID, SequenceNo from SHLights where canDim = %d order by SequenceNo;", canDim];
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *lights = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [lights addObject:[SHLight lightWithDictionary:dict]];
    }
    
    return lights;
}

/// 获取Sences对应的命令集
- (NSMutableArray *)getSenceCommands:(SHMacro *)macro {
    
    NSString *selectSQL = [NSString stringWithFormat:@"select ScenesID, SequenceNo, Remark, SubnetID, DeviceID, CommandTypeID, FirstParameter, SecondParameter, ThirdParameter, DelayMillisecondAfterSend from ScenesCommands where ScenesID = %zd order by SequenceNo;", macro.macroID];
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *commands = [NSMutableArray arrayWithCapacity:array.count];

    for (NSDictionary *dict in array) {
        
        [commands addObject:[SHMacroCommand macroCommandWithDictionary:dict]];
    }
    
    return commands;
}

/// 查询所有的场景
- (NSMutableArray *)getAllSences {
    
    NSString *selectSQL = @"select MacroID, MacroName, MacroIconID, SequenceNO  \
        from Scenes order by SequenceNO;";
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *sences = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [sences addObject:[SHMacro macroinitWithDictionary:dict]];
    }
    
    return sences;
}


/// 获得该房间的所有设备
- (NSMutableArray *)getRoomDevice:(SHRoomBaseInfomation *)room {
    
    // IR 以后的暂时没有，所以不获取
    NSString *selectSQL = @"select BuildingID, FloorID, RoomNo, DeviceType, SubnetID, \
            DeviceID, DeciceNO, BuildingName, RoomName, DeviceRemark from   \
    CurrentRoomDevices where DeviceType < 5090 order by DeviceType;";
    
    NSArray *array = [self selectProprty:selectSQL];
    
    NSMutableArray *devices = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [devices addObject:[SHRoomDevice roomDeviceWithDictionary:dict]];
    }
    
    return devices;
}


/// 获得所有的房间信息
- (NSMutableArray *)getRoomBaseInformation {

    NSString *selectSQL = @"SELECT SHBuildID, SHFloorID, SHRoomNumber, SHRoomNumberDisplay, SHRoomAlias, SHHotelName FROM SHRoomBasicInfo;";

    NSMutableArray *array = [self selectProprty:selectSQL];

    NSMutableArray *infos = [NSMutableArray arrayWithCapacity:array.count];

    for (NSDictionary *dict in array) {

        [infos addObject:[SHRoomBaseInfomation roomBaseInfomationWithDictionary:dict]];
    }

    return infos;
}

// MARK: - 创建表格

///  创建表格
- (void)createSqlTables {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SQL.sql" ofType:nil];
    
    NSString *sql = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // 创建单张表格
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if ([db executeStatements:sql]) {
            printLog(@"%@", [FileTools documentPath]);
        }
    }];
}

// MARK: - 公共封装部分

/**
 删除表格
 
 @param name 表格名称
 @return YES - 删除成功 NO - 删除失败
 */
- (BOOL)deleteTable:(NSString *)name {
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@;", name];
    
    return [self executeSql:deleteSQL];
}

/**
 修改数据表的名称
 
 @param srcName 旧名称
 @param destName 新名筄
 @return YES - 修改成功, NO - 修改失败
 */
- (BOOL)renameTable:(NSString *)srcName toName:(NSString *)destName {
    
    NSString *renameSQL = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@;", srcName, destName];
    
    return [self executeSql:renameSQL];
}

/**
 判断表中是否存在字段
 
 @param columnName 字段名称
 @param tableName 表格名称
 @return YES - 存在 NO - 不存在
 */
- (BOOL)isColumnName:(NSString *)columnName consistinTable:(NSString *)tableName {
    
    NSString * sqlstr = [NSString stringWithFormat:@"select * from %@", tableName];
    
    __block FMResultSet * result;
    
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        result = [db executeQuery:sqlstr];
    }];
    
    
    for (int col = 0; col < result.columnCount; col++) {
        
        // 获得字段名称
        NSString * tableColumnName = [result columnNameForIndex:col];
        
        // 判断是否存在 (由于SQL不区分大小，所以需要统一区分成大小。)
        if ([tableColumnName.uppercaseString isEqualToString:columnName.uppercaseString]) {
            
            return YES;
        }
    }
    
    return NO;
}

/// 插入语句 成功返回YES， 失败返回NO。
- (BOOL)executeSql:(NSString *)sql {
    
    __block BOOL res = YES;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if (![db executeUpdate:sql]) {
            res = NO;
        }
    }];
    
    return res;
}

/// 查询封装语句 -- 注意，它返回的【字典】数组
- (NSMutableArray *)selectProprty:(NSString *)sql {
    
    // 准备一个数组来存储所有内容
    __block NSMutableArray *array = [NSMutableArray array];
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        // 获得全部的记录
        FMResultSet *resultSet = [db executeQuery:sql];
        
        // 遍历结果
        while (resultSet.next) {
            
            // 准备一个字典
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            // 获得列数
            int count = [resultSet columnCount];
            
            // 遍历所有的记录
            for (int i = 0; i < count; i++) {
                
                // 获得字段名称
                NSString *name = [resultSet columnNameForIndex:i];
                
                // 获得字段值
                NSString *value = [resultSet objectForColumn:name];
                
                // 存储在字典中
                dict[name] =  value;
            }
            
            // 添加到数组
            [array addObject:dict];
        }
    }];
    
    return array;
}

/// 创建数据库
- (instancetype)init {
    
    if (self = [super init]) {
        
        // 1.数据库的目标路径
        NSString *filePath = [[FileTools documentPath] stringByAppendingPathComponent:dataBaseName];
        
        // 2.获得资源路径
        NSString *sourceDataBasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataBaseName];

        // 判断路径是否存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

            if ([[NSFileManager defaultManager] copyItemAtPath:sourceDataBasePath toPath:filePath error:nil]) {

                //                SHLog(@"拷贝成功");
            }
        }
        
        // 如果数据库不存在，会建立数据库，然后，再创建队列，并且打开数据库
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        
        // 创建表格
        [self createSqlTables];
        
    }
    return self;
}


SingletonImplementation(SHSQLManager)

@end
