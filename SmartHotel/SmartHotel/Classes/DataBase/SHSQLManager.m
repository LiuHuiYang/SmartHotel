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
NSString *dataBaseName = @"SHDB.sqlite3";

@interface SHSQLManager ()

/// 全局操作队列
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation SHSQLManager


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
