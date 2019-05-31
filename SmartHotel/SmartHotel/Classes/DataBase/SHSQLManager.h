//
//  SHSQLManager.h
//  SmartHotel
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHRoomBaseInfomation.h"
#import "SHRoomDevice.h"
#import "SHCurtain.h"
#import "SHMacro.h"
#import "SHMacroCommand.h"
#import "SHLight.h"
#import "SHTV.h"
#import "SHChannel.h"
#import "SHChannelType.h"

@interface SHSQLManager : NSObject

// MARK: - 数据操作

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

/// 更新房间设备信息
- (BOOL)updateRoomDevice:(SHRoomDevice *)device;

/// 更新房间信息
- (BOOL)updateRoomInfo:(SHRoomBaseInfomation *)roomInfo;

/// 获得指定电视的频道类型
- (NSMutableArray *)getAllChannelTypes:(SHTV *)tv;

/// 获得房间的电视 
- (NSMutableArray *)getTV;

/// 获得指定种类的灯泡
- (NSMutableArray *)getLight:(BOOL)canDim;

/// 获取Sences对应的命令集
- (NSMutableArray *)getSenceCommands:(SHMacro *)macro;

/// 查询所有的场景
- (NSMutableArray *)getAllSences;
 

/// 获得该房间的所有设备
- (NSMutableArray *)getRoomDevice:(SHRoomBaseInfomation *)room;

/// 获得所有的房间信息
- (NSMutableArray *)getRoomBaseInformation;




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
