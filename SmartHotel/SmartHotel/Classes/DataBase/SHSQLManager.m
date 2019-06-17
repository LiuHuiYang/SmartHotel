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

// MARK: - 自定义图片

- (BOOL)updateIcon:(SHIcon *)icon {
    
    printLog(@"尚未实现");
    return NO;
}


/**
 增加图片

 @param icon 图片对象
 @return 增加成功YES. 失败 NO.
 */
- (BOOL)insertIcon:(SHIcon *)icon {
    
    __block BOOL result = NO;
    
    [self.queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
       
         result = [db executeUpdate:@"INSERT INTO iconList (iconID, iconName, iconData) VALUES (?, ?, ?);", @(icon.iconID), icon.iconName, icon.iconData];
        
    }];
    
    return result;
}


/**
 删除指定的图片

 @param icon 图片对象
 @return 删除图片 YES, 失败 NO.
 */
- (BOOL)deleteIcon:(SHIcon *)icon {
    
    NSString *sql = [NSString stringWithFormat:@"delete from iconList where iconID = %zd;", icon.iconID];
    
    return [self executeSql:sql];
}

/**
 查询图片数据

 @param iconName 图片名称
 @return 图片对象
 */
- (SHIcon *)getIcon:(NSString *)iconName {
    
    NSString *sql = [NSString stringWithFormat:@"select iconID, iconName, iconData from iconList where iconName = '%@'; ", iconName];
    
    NSDictionary *dict =
        [[self selectProprty:sql] lastObject];
    
    return [SHIcon iconWithDictionary:dict];
}

/**
 查询所有的图片

 @return 所有的图片数组
 */
- (NSMutableArray *)getIcons {
    
    NSString *sql = @"select iconID, iconName, iconData from iconList order by iconID;";
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *icons =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [icons addObject:
            [SHIcon iconWithDictionary:dict]
        ];
    }

    return icons;
}

/**
 获得可用的图片ID

 @return 图片ID
 */
- (NSUInteger)getAvailableIconID {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(iconID) from iconList;"];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(iconID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger iconID =
    [[dict objectForKey:@"max(iconID)"]integerValue] + 1;
    
    return iconID;
}

// MARK: - macro


/**
 更新MacroCommand

 @param command 宏命令
 @return 更新成功YES, 失败 NO.
 */
- (BOOL)updateMacroCommand:(SHMacroCommand *)command {
    
    NSString *sql = [NSString stringWithFormat:@"update MacroCommand set remark = '%@', commandType = %zd, subnetID = %zd, deviceID = %zd, parameter1 = %zd, parameter2 = %zd, parameter3 = %zd, parameter4 = %zd, parameter5 = %zd, parameter6 = %zd, parameter7 = %zd, parameter8 = %zd, delayTime = %zd where macroID = %zd and macroCommandID = %zd;",
                     command.remark,
                     command.commandType,
                     command.subnetID,
                     command.deviceID,
                     command.parameter1,
                     command.parameter2,
                     command.parameter3,
                     command.parameter4,
                     command.parameter5,
                     command.parameter6,
                     command.parameter7,
                     command.parameter8,
                     command.delayTime,
                     command.macroID,
                     command.macroCommandID
                    ];
    
    return [self executeSql:sql];
}


/**
 删除MacroCommand

 @param command 宏命令
 @return 删除成功YES, 失败NO.
 */
- (BOOL)deleteMacroCommand:(SHMacroCommand *)command {
    
    NSString *sql = [NSString stringWithFormat:@"delete from MacroCommand Where macroCommandID = %zd and macroID = %zd;",
                     command.macroCommandID,
                     command.macroID
                     ];
    
    return [self executeSql:sql];
}

/**
 增加新的MacroCommand

 @param command 宏命令
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertMacroCommand:(SHMacroCommand *)command {
    
    NSString *sql = [NSString stringWithFormat:@"insert into MacroCommand(macroCommandID, macroID, remark, commandType, subnetID, deviceID, parameter1, parameter2, parameter3, parameter4, parameter5, parameter6, parameter7, parameter8, delayTime) values(%zd, %zd, '%@', %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd);",
                     command.macroCommandID,
                     command.macroID,
                     command.remark,
                     command.commandType,
                     command.subnetID,
                     command.deviceID,
                     command.parameter1,
                     command.parameter2,
                     command.parameter3,
                     command.parameter4,
                     command.parameter5,
                     command.parameter6,
                     command.parameter7,
                     command.parameter8,
                     command.delayTime
                     ];
    
    return [self executeSql:sql];
}

/**
 获得指定Macro的命令集合

 @param macro 宏
 @return 宏对对应的命令集合
 */
- (NSMutableArray *)getMacroCommands:(SHMacro *)macro {
    
    NSString *sql = [NSString stringWithFormat:@"select macroCommandID, macroID, remark, commandType, subnetID, deviceID, parameter1, parameter2, parameter3, parameter4, parameter5, parameter6, parameter7, parameter8, delayTime from MacroCommand where macroID = %zd order by macroCommandID;", macro.macroID];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *commands =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [commands addObject: [SHMacroCommand macroCommandWithDictionary:dict]];
    }
    
    return commands;
}

 
/**
 获取可用的macroCommandID
 
 @return macroCommandID
 */
- (NSUInteger)getAvailableMacroCommandID:(NSUInteger)macroID {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(macroCommandID) from MacroCommand where macroID = %zd;", macroID];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(macroCommandID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger macroCommandID =
    [[dict objectForKey:@"max(macroCommandID)"]integerValue] + 1;
    
    return macroCommandID;
}


/**
 更新 Macro

 @param macro macro对象
 @return 更新成功 YES, 失败 NO.
 */
- (BOOL)updateMacro:(SHMacro *)macro {
    
    NSString *sql = [NSString stringWithFormat:@"update Macro set macroName = '%@', macroIconName = '%@' where macroID = %zd;",
                     macro.macroName,
                     macro.macroIconName,
                     macro.macroID
                    ];
    
    
    return [self executeSql:sql];
}

/**
 删除宏命令

 @param macro 删除宏
 @return 成功删除 YES, 失败 NO.
 */
- (BOOL)deleteMacro:(SHMacro *)macro {
    
    // 删除 宏命令
    NSString *sql = [NSString stringWithFormat:@"delete from MacroCommand Where macroID = %zd;", macro.macroID];
    
    if ([self executeSql:sql] == false) {
        return false;
    }
    
    // 删除 宏
    sql = [NSString stringWithFormat:@"delete from Macro Where macroID = %zd;", macro.macroID];
    
    return [self executeSql:sql];
}


/**
 增加新的宏

 @param macro macro 模型对象
 @return 成功 YES, 失败 NO.
 */
- (BOOL)insertMacro:(SHMacro *)macro {
 
    NSString *sql = [NSString stringWithFormat:@"insert into Macro(macroID, macroName, macroIconName) values(%zd, '%@', '%@');",
                     macro.macroID,
                     macro.macroName,
                     macro.macroIconName
                    ];
    
    return [self executeSql:sql];
}

/**
 获取当前房间中的所有宏场景

 @return 宏数组
 */
- (NSMutableArray *)getMacros {
    
    NSString *sql = [NSString stringWithFormat:@"select macroID, macroName, macroIconName from Macro;"];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *macros =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [macros addObject:[SHMacro macroinitWithDictionary:dict]];
    }
    
    return macros;
}


/**
 获取可用的MacroID

 @return MacroID 
 */
- (NSUInteger)getAvailableMacroID {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(macroID) from Macro;"];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(macroID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger macroID =
    [[dict objectForKey:@"max(macroID)"]integerValue] + 1;
    
    return macroID;
}

// MARK: - TV Channel Group


/**
 删除电视频道

 @param channel 电视频道
 @return 删除成功YES, 失败NO
 */
- (BOOL)deleteTVChannel:(SHChannel *)channel {
    
    NSString *sql = [NSString stringWithFormat:@"delete from TVChannel where tvID = %zd and groupID = %zd and channelID = %zd;",
                     channel.tvID,
                     channel.groupID,
                     channel.channelID];
    
    return [self executeSql:sql];
}


/**
 更新电视频道

 @param channel 电视频道
 @return 更新成功 YES, 失败 NO.
 */
- (BOOL)updateTVChannel:(SHChannel *)channel {
    
    NSString *sql = [NSString stringWithFormat:@"update TVChannel set channelName = '%@', iconName = '%@', subnetID = %zd, deviceID = %zd, channelIRCode = %zd, delayTime = %zd where tvID = %zd and groupID = %zd and channelID = %zd;",
                     channel.channelName,
                     channel.iconName,
                     channel.subnetID,
                     channel.deviceID,
                     channel.channelIRCode,
                     channel.delayTime,
                     channel.tvID,
                     channel.groupID,
                     channel.channelID
                     ];
    
    return [self executeSql:sql];
}


/**
 增加新的电视频道

 @param channel 频道
 @return 增加成功 YES. 失败 NO.
 */
- (BOOL)insertTVChannel:(SHChannel *)channel {
    
    NSString *sql = [NSString stringWithFormat:@"insert into TVChannel (tvID, channelID, groupID, channelName, iconName, subnetID, deviceID, channelIRCode, delayTime) values(%zd, %zd, %zd, '%@', '%@', %zd, %zd, %zd, %zd);",
                     channel.tvID,
                     channel.channelID,
                     channel.groupID,
                     channel.channelName,
                     channel.iconName,
                     channel.subnetID,
                     channel.deviceID,
                     channel.channelIRCode,
                     channel.delayTime
                    ];
    
    
    return [self executeSql:sql];
}

/**
 获当前电视分组下的所有频道

 @param group 电视分组
 @return 电视频道数组
 */
- (NSMutableArray *)getTVChannels:(SHChannelGroup *)group {
    
    NSString *sql = [NSString stringWithFormat:@"select tvID, channelID, groupID, channelName, iconName, subnetID, deviceID, channelIRCode, delayTime from TVChannel where tvID = %zd and groupID = %zd order by channelID;", group.tvID, group.groupID];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *channels = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [channels addObject:[SHChannel channelWithDictionary:dict]];
    }
    
    return channels;
}


/**
 获前当前电视频道可用的最大ID
 
 @param channel 频道
 @return 可用ID
 */
- (NSUInteger)getAvailableTVChannelID:(SHChannel *)channel {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(channelID) from TVChannel where tvID = %zd and groupID = %zd;",
        channel.tvID,
        channel.groupID
    ];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(channelID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger channelID =
    [[dict objectForKey:@"max(channelID)"]integerValue] + 1;
    
    return channelID;
}

/**
 更新电视频道(只有名称)

 @param channelGroup 电视频道分组
 @return 更新成功 YES, 失败 NO.
 */
- (BOOL)updateTVChannelGroup:(SHChannelGroup *)channelGroup {
    
    NSString *sql = [NSString stringWithFormat:@"update TVChannelGroup set groupName = '%@' where tvID = %zd and groupID = %zd;",
                     channelGroup.groupName,
                     channelGroup.tvID,
                     channelGroup.groupID
                     ];
    
    return [self executeSql:sql];
}

/**
 删除电视频道分组

 @param channelGroup 频道分组
 @return 删除成功 YES, 失败 NO.
 */
- (BOOL)deleteTVChannelGroup:(SHChannelGroup *)channelGroup {
    
    // 删除对应的频道
    NSString *sql = [NSString stringWithFormat:@"delete from TVChannel where tvID = %zd and groupID = %zd;",
                     channelGroup.tvID,
                     channelGroup.groupID];
    
    if ([self executeSql:sql] == false) {
        
        return false;
    }
    
    sql = [NSString stringWithFormat:@"delete from TVChannelGroup where tvID = %zd and groupID = %zd;",
           channelGroup.tvID,
           channelGroup.groupID];
    
    return [self executeSql:sql];
}

/**
 增加新的电视频道分组

 @param channelGroup 频道分组
 @return 增加成功 YES, 失败 NO.
 */
- (BOOL)insertTVChannelGroup:(SHChannelGroup *)channelGroup {
    
    NSString *sql = [NSString stringWithFormat:@"insert into TVChannelGroup (tvID, groupID, groupName) values(%zd, %zd, '%@');", channelGroup.tvID, channelGroup.groupID, channelGroup.groupName];
    
    return [self executeSql:sql];
}

/**
 获得当前tv的所有频道分组

 @param tv tv对象
 @return 频道分组
 */
- (NSMutableArray *)getTVChannelGroups:(SHTV *)tv {
    
    NSString *sql = [NSString stringWithFormat:@"select tvID, groupID, groupName from TVChannelGroup where tvID = %zd order by groupID;", tv.tvID];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *groups =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [groups addObject: [SHChannelGroup channelGroupWithDictionary:dict]];
    }
    
    return groups;
}


/**
 获前当前电视频道分组可用的最大ID

 @param group 频道分组
 @return 可用ID
 */
- (NSUInteger)getAvailableTVChannelGroupID:(SHChannelGroup *)group {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(groupID) from TVChannelGroup where tvID = %zd;", group.tvID];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(groupID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger groupID =
    [[dict objectForKey:@"max(groupID)"]integerValue] + 1;
    
    return groupID;
}

// MARK: - TV


/**
 更新TV设备参数

 @param tv tv设备对象
 @return 更新成功YES, 失败NO.
 */
- (BOOL)updateTV:(SHTV *)tv {
    
    NSString *sql =
        [NSString stringWithFormat:
         @"update TV set tvName = '%@', subnetID = %zd, deviceID = %zd, turnOn = %zd, turnOff = %zd, muteOn = %zd, muteOff = %zd, volumeUp = %zd, volumeDown = %zd, channelUp = %zd, channelDown = %zd, sure = %zd, number0 = %zd, number1 = %zd, number2 = %zd, number3 = %zd, number4 = %zd, number5 = %zd, number6 = %zd, number7 = %zd, number8 = %zd, number9 = %zd where tvID = %zd;",
            tv.tvName,
            tv.subnetID,
            tv.deviceID,
            tv.turnOn,
            tv.turnOff,
            tv.muteOn,
            tv.muteOff,
            tv.volumeUp,
            tv.volumeDown,
            tv.channelUp,
            tv.channelDown,
            tv.sure,
            tv.number0,
            tv.number1,
            tv.number2,
            tv.number3,
            tv.number4,
            tv.number5,
            tv.number6,
            tv.number7,
            tv.number8,
            tv.number9,
            tv.tvID
         ];
    
    return [self executeSql:sql];
}

/**
 删除tv设备
 
 @param tv tv设备对象
 @return 删除成功 YES, 失败 NO.
 */
- (BOOL)deleteTV:(SHTV *)tv {
    
    NSString *sql = [NSString stringWithFormat:@"delete from TV Where tvID = %zd and subnetID = %zd and deviceID = %zd;",
                     tv.tvID,
                     tv.subnetID,
                     tv.deviceID
                     ];
    
    return [self executeSql:sql];
}

/**
 增加新的TV

 @param tv tv 对象
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertTV:(SHTV *)tv {
    
    NSString *sql = [NSString stringWithFormat:@"insert into TV(tvID, tvName, subnetID, deviceID, turnOn, turnOff, muteOn, muteOff, volumeUp, volumeDown, channelUp, channelDown, sure, number0, number1, number2, number3, number4, number5, number6, number7, number8, number9) values(%zd, '%@', %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd, %zd %zd);",
                     
                     tv.tvID,
                     tv.tvName,
                     tv.subnetID,
                     tv.deviceID,
                     tv.turnOn,
                     tv.turnOff,
                     tv.muteOn,
                     tv.muteOff,
                     tv.volumeUp,
                     tv.volumeDown,
                     tv.channelUp,
                     tv.channelDown,
                     tv.sure,
                     tv.number0,
                     tv.number1,
                     tv.number2,
                     tv.number3,
                     tv.number4,
                     tv.number5,
                     tv.number6,
                     tv.number7,
                     tv.number8,
                     tv.number9
                     
                     ];
    
    return [self executeSql:sql];
}

/**
 查询所有的电视

 @return 电视对象数组
 */
- (NSMutableArray *)getTV {
    
    NSString *sql = [NSString stringWithFormat:@"%@",
                     @"select tvID, tvName, subnetID, deviceID, turnOn, turnOff, muteOn, muteOff, volumeUp, volumeDown, channelUp, channelDown, sure, number0, number1, number2, number3, number4, number5, number6, number7, number8, number9   from TV;"
                     ];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *tvs =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [tvs addObject: [SHTV tvWithDictionary:dict]];
    }
    
    return tvs;
}

/**
 获取电视编号

 @return 可以直接使用的ID编号
 */
- (NSUInteger)getAvailableTVID {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(tvID) from TV;"];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(tvID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger tvID =
    [[dict objectForKey:@"max(tvID)"]integerValue] + 1;
    
    return tvID;
}

    
// MARK: - 灯光
    

/**
 更新灯光设备

 @param light 灯光设备
 @return 更新成功 YES, 更新失败 NO.
 */
- (BOOL)updateLight:(SHLight *)light {
    
    NSString *sql = [NSString stringWithFormat:@"update Light set lightName = '%@', lightType = %zd, subnetID = %zd, deviceID = %zd, channelNo = %zd where lightID = %zd;",
                     light.lightName,
                     light.lightType,
                     light.subnetID,
                     light.deviceID,
                     light.channelNo,
                     light.lightID
                    ];
    
    return [self executeSql:sql];
}
    

/**
 删除灯光设备

 @param light 灯光设备对象
 @return 删除成功 YES, 失败 NO.
 */
- (BOOL)deleteLight:(SHLight *)light {
    
    NSString *sql = [NSString stringWithFormat:@"delete from Light Where lightID = %zd and subnetID = %zd and deviceID = %zd and channelNo = %zd;",
                     light.lightID,
                     light.subnetID,
                     light.deviceID,
                     light.channelNo];
    
    return [self executeSql:sql];
}

/**
 增加一个新的灯光设备
 
 @param light 窗帘对象
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertLight:(SHLight *)light {
    
    NSString *sql =
    [NSString stringWithFormat:@"insert into Light (lightID, lightName, lightType, subnetID, deviceID, channelNo) values(%zd, '%@', %zd, %zd, %zd, %zd);",
     
        light.lightID,
        light.lightName,
        light.lightType,
        light.subnetID,
        light.deviceID,
        light.channelNo
     ];
    
    return [self executeSql:sql];
}
    
/**
 获所有的灯光设备

 @return 灯光设备数组
 */
- (NSMutableArray *)getLights {
    
    NSString *sql = [NSString stringWithFormat:@"select lightID, lightName, lightType, subnetID, deviceID, channelNo from Light order by lightID;"];
    
    NSArray *array = [self selectProprty:sql];
    
    NSMutableArray *lights =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [lights addObject:[SHLight lightWithDictionary:dict]];
    }
    
    return lights;
}
    
/**
 获得一个可用的灯光编号
 
 @return 返回可以直接使用的空调编号
 */
- (NSUInteger)getAvailableLightID {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(lightID) from Light;"];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(lightID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger lightID =
    [[dict objectForKey:@"max(lightID)"]integerValue] + 1;
    
    return lightID;
}

// MARK: - 空调


/**
 更新空调数据

 @param ac 空调数据
 @return 更新成功 YES, 更新失败 NO.
 */
- (BOOL)updateAirConditioner:(SHHVAC *)ac {
    
    NSString *sql =
        [NSString stringWithFormat:
         @"update AirConditioner set acName = '%@', acType = %zd, acNumber = %zd, subnetID = %zd, deviceID = %zd, channelNo = %zd where acID = %zd;",
            ac.acName,
            ac.acType,
            ac.acNumber,
            ac.subnetID,
            ac.deviceID,
            ac.channelNo,
            ac.acID
         ];
    
    return [self executeSql:sql];
}


/**
 删除空调对象
 
 @param ac 窗帘对象
 @return 删除成功YES, 失败 NO.
 */
- (BOOL)deleteAirConditioner:(SHHVAC *)ac {
    
    NSString *sql =
    [NSString stringWithFormat:
        @"delete from AirConditioner Where acID = %zd;", ac.acID
    ];
    
    
    return [self executeSql:sql];
}
    
/**
 增加新的空调

 @param ac 空调
 @return 增加成功 YES, 失败 NO
 */
- (BOOL)insertAirConditioner:(SHHVAC *)ac {
    
    NSString *sql =
        [NSString stringWithFormat:
         @"insert into AirConditioner (acID, acName, acType, acNumber, subnetID, deviceID, channelNo) values(%zd, '%@', %zd, %zd, %zd, %zd, %zd);",
                     ac.acID,
                     ac.acName,
                     ac.acType,
                     ac.acNumber,
                     ac.subnetID,
                     ac.deviceID,
                     ac.channelNo
                    ];
    
    return [self executeSql:sql];
}

/**
 获得一个可用的空调编号
 
 @return 返回可以直接使用的空调编号
 */
- (NSUInteger)getAvailableAirConditionerID {
    
    NSString *sql =
    [NSString stringWithFormat:@"select max(acID) from AirConditioner;"];
    
    NSDictionary *dict =
    [[self selectProprty:sql] lastObject];
    
    if ([dict objectForKey:@"max(acID)"] == [NSNull null]) {
        
        return 1;
    }
    
    NSUInteger acID =
    [[dict objectForKey:@"max(acID)"]integerValue] + 1;
    
    return acID;
}

/**
 查询所有的空调数据

 @return 空调数组
 */
- (NSMutableArray *)getAirConditioners {
    
    NSString *sql =
        [NSString stringWithFormat:
         
         @"select acID, acName, acType, acNumber, subnetID, deviceID, channelNo from AirConditioner order by acID;"];
    
    NSArray *array = [self selectProprty:sql];
    NSMutableArray *acs =
        [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dict in array) {
        
        [acs addObject:
            [SHHVAC airConditionerWithDictionary:dict]
        ];
    }
    
    return acs;
}

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
        [NSString stringWithFormat:@"select curtainID, curtainName, curtainType, subnetID, deviceID, openChannel, closeChannel, stopChannel, switchIDforOpen, switchIDforClose, switchIDforStop from Curtains order by curtainID;"];
    
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
