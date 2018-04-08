//
//  SHSQLManager.h
//  SmartHotel
//
//  Created by Mac on 2018/4/2.
//  Copyright © 2018年 Mark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSQLManager : NSObject

// MARK: - 数据操作


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
