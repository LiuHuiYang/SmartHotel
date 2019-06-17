//
//  SHSQLManager.h
//  SmartHotel
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHRoomInfo.h"
#import "SHRoomDevice.h"
#import "SHCurtain.h"
#import "SHMacro.h"
#import "SHMacroCommand.h"
#import "SHLight.h"
#import "SHTV.h"
#import "SHChannel.h"
#import "SHChannelGroup.h"
#import "SHHVAC.h"
#import "SHIcon.h"


@interface SHSQLManager : NSObject

// MARK: - 自定义图片

/**
 增加图片
 
 @param icon 图片对象
 @return 增加成功YES. 失败 NO.
 */
- (BOOL)insertIcon:(SHIcon *)icon;

/**
 删除指定的图片
 
 @param icon 图片对象
 @return 删除图片 YES, 失败 NO.
 */
- (BOOL)deleteIcon:(SHIcon *)icon;

/**
 查询图片数据
 
 @param iconName 图片名称
 @return 图片对象
 */
- (SHIcon *)getIcon:(NSString *)iconName;

/**
 查询所有的图片
 
 @return 所有的图片数组
 */
- (NSMutableArray *)getIcons;

/**
 获得可用的图片ID
 
 @return 图片ID
 */
- (NSUInteger)getAvailableIconID;


// MARK: - Macro

/**
 更新MacroCommand
 
 @param command 宏命令
 @return 更新成功YES, 失败 NO.
 */
- (BOOL)updateMacroCommand:(SHMacroCommand *)command;

/**
 删除MacroCommand
 
 @param command 宏命令
 @return 删除成功YES, 失败NO.
 */
- (BOOL)deleteMacroCommand:(SHMacroCommand *)command;

/**
 增加新的MacroCommand
 
 @param command 宏命令
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertMacroCommand:(SHMacroCommand *)command ;

/**
 获得指定Macro的命令集合
 
 @param macro 宏
 @return 宏对对应的命令集合
 */
- (NSMutableArray *)getMacroCommands:(SHMacro *)macro;

/**
 获取可用的macroCommandID
 
 @return macroCommandID
 */
- (NSUInteger)getAvailableMacroCommandID:(NSUInteger)macroID;


/**
 更新 Macro
 
 @param macro macro对象
 @return 更新成功 YES, 失败 NO.
 */
- (BOOL)updateMacro:(SHMacro *)macro;

/**
 删除宏命令
 
 @param macro 删除宏
 @return 成功删除 YES, 失败 NO.
 */
- (BOOL)deleteMacro:(SHMacro *)macro;

/**
 增加新的宏
 
 @param macro macro 模型对象
 @return 成功 YES, 失败 NO.
 */
- (BOOL)insertMacro:(SHMacro *)macro;

/**
 获取当前房间中的所有宏场景
 
 @return 宏数组
 */
- (NSMutableArray *)getMacros;

/**
 获取可用的MacroID
 
 @return MacroID
 */
- (NSUInteger)getAvailableMacroID;


// MARK: - Channel Group

/**
 更新电视频道
 
 @param channel 电视频道
 @return 更新成功 YES, 失败 NO.
 */
- (BOOL)updateTVChannel:(SHChannel *)channel;


/**
 删除电视频道
 
 @param channel 电视频道
 @return 删除成功YES, 失败NO
 */
- (BOOL)deleteTVChannel:(SHChannel *)channel;

/**
 增加新的电视频道
 
 @param channel 频道
 @return 增加成功 YES. 失败 NO.
 */
- (BOOL)insertTVChannel:(SHChannel *)channel;

/**
 获当前电视分组下的所有频道
 
 @param group 电视分组
 @return 电视频道数组
 */
- (NSMutableArray *)getTVChannels:(SHChannelGroup *)group;

/**
 获前当前电视频道可用的最大ID
 
 @param channel 频道
 @return 可用ID
 */
- (NSUInteger)getAvailableTVChannelID:(SHChannel *)channel;

/**
 更新电视频道(只有名称)
 
 @param channelGroup 电视频道分组
 @return 更新成功 YES, 失败 NO.
 */
- (BOOL)updateTVChannelGroup:(SHChannelGroup *)channelGroup;

/**
 删除电视频道分组
 
 @param channelGroup 频道分组
 @return 删除成功 YES, 失败 NO.
 */
- (BOOL)deleteTVChannelGroup:(SHChannelGroup *)channelGroup;

/**
 增加新的电视频道分组
 
 @param channelGroup 频道分组
 @return 增加成功 YES, 失败 NO.
 */
- (BOOL)insertTVChannelGroup:(SHChannelGroup *)channelGroup;

/**
 获得当前tv的所有频道分组
 
 @param tv tv对象
 @return 频道分组
 */
- (NSMutableArray *)getTVChannelGroups:(SHTV *)tv;

/**
 获前当前电视频道分组可用的最大ID
 
 @param group 频道分组
 @return 可用ID
 */
- (NSUInteger)getAvailableTVChannelGroupID:(SHChannelGroup *)group;

// MARK: - TV

/**
 更新TV设备参数
 
 @param tv tv设备对象
 @return 更新成功YES, 失败NO.
 */
- (BOOL)updateTV:(SHTV *)tv;

/**
 删除tv设备
 
 @param tv tv设备对象
 @return 删除成功 YES, 失败 NO.
 */
- (BOOL)deleteTV:(SHTV *)tv;

/**
 增加新的TV
 
 @param tv tv 对象
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertTV:(SHTV *)tv;

/**
 查询所有的电视
 
 @return 电视对象数组
 */
- (NSMutableArray *)getTV;

/**
 获取电视编号
 
 @return 可以直接使用的ID编号
 */
- (NSUInteger)getAvailableTVID;
    
// MARK: - 灯光
    
/**
 更新灯光设备
 
 @param light 灯光设备
 @return 更新成功 YES, 更新失败 NO.
 */
- (BOOL)updateLight:(SHLight *)light;
    
/**
 删除灯光设备
 
 @param light 灯光设备对象
 @return 删除成功 YES, 失败 NO.
 */
- (BOOL)deleteLight:(SHLight *)light;
    
/**
 增加一个新的灯光设备
 
 @param light 窗帘对象
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertLight:(SHLight *)light;
    
/**
 获所有的灯光设备
 
 @return 灯光设备数组
 */
- (NSMutableArray *)getLights;
    

/**
 获得一个可用的灯光编号
 
 @return 返回可以直接使用的空调编号
 */
- (NSUInteger)getAvailableLightID;

// MARK: - 空调
    
/**
 更新空调数据
 
 @param ac 空调数据
 @return 更新成功 YES, 更新失败 NO.
 */
- (BOOL)updateAirConditioner:(SHHVAC *)ac;

/**
 删除空调对象
 
 @param ac 窗帘对象
 @return 删除成功YES, 失败 NO.
 */
- (BOOL)deleteAirConditioner:(SHHVAC *)ac;
    
/**
 增加新的空调
 
 @param ac 空调
 @return 增加成功 YES, 失败 NO
 */
- (BOOL)insertAirConditioner:(SHHVAC *)ac;
    
/**
 获得一个可用的空调编号
 
 @return 返回可以直接使用的空调编号
 */
- (NSUInteger)getAvailableAirConditionerID;

/**
 查询所有的空调数据
 
 @return 空调数组
 */
- (NSMutableArray *)getAirConditioners;
    
    
// MARK: - Curtain


/**
 更新窗帘对象
 
 @param curtain 窗帘对象
 @return 更新成功YES, 失败 NO.
 */
- (BOOL)updateCurtain:(SHCurtain *)curtain;

/**
 删除窗帘对象
 
 @param curtain 窗帘对象
 @return 删除成功YES, 失败 NO.
 */
- (BOOL)deleteCurtain:(SHCurtain *)curtain;

/**
 增加一个新的窗帘
 
 @param curtain 窗帘对象
 @return 增加成功YES, 失败 NO.
 */
- (BOOL)insertCurtain:(SHCurtain *)curtain;

/**
 查询当前所有的窗帘
 
 @return 窗帘数组
 */
- (NSMutableArray *)getCurtains;

/**
 获得一个可用的窗帘编号
 
 @return 返回可以直接使用的窗帘编号
 */
- (NSUInteger)getAvailableCurtainID;

// MARK: - 房间信息

/**
 更新房间信息
 
 @return 更新成功YES, 失败 NO.
 */
- (BOOL)updateRoom:(SHRoomInfo *)roomInfo;

/**
 删除房间
 
 @param roomInfo 房间信息
 @return 删除成功YES. 失败 NO.
 */
- (BOOL)deleteRoom:(SHRoomInfo *)roomInfo;

/**
 增加新的房间
 
 @param roomInfo 房间信息
 @return 增加成功 YES. 失败 NO.
 */
- (BOOL)insertRoom:(SHRoomInfo *)roomInfo;

/**
 查询所有的房间信息
 
 @return 房间信息数组
 */
- (NSMutableArray *)getRoomInfos;

/**
 获得可有的房间ID
 
 @return 房间ID (数据库中的唯一标示)
 */
- (NSUInteger)getAvailableRoomID;


// MARK: - 数据库本身操作相关的API


/**
 删除表格
 
 @param name 表格名称
 @return YES - 删除成功 NO - 删除失败
 */
- (BOOL)deleteTable:(NSString *)name;

/**
 修改数据表的名称
 
 @param srcName 旧名称
 @param destName 新名筄
 @return YES - 修改成功, NO - 修改失败
 */
- (BOOL)renameTable:(NSString *)srcName toName:(NSString *)destName;

/// 执行SQL语句 成功返回YES， 失败返回NO。
- (BOOL)executeSql:(NSString *)sql;

/// 查询封装语句 -- 注意，它返回的【字典】数组
- (NSMutableArray *)selectProprty:(NSString *)sql;

SingletonInterface(SHSQLManager)

@end
