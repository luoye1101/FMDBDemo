//
//  FMDatabaseQueueManager.h
//  FMDBDemo
//
//  Created by 黄跃奇 on 2017/12/15.
//  Copyright © 2017年 yueqi. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabaseQueueManager : FMDatabaseQueue

/// 单例的全局访问点
+ (instancetype)sharedManager;

/**
 创建数据库表

 @param tableName  表名称
 @param fields     表字段
 @param fieldsType 字段类型
 */
+ (void)QLCreateTable:(NSString *)tableName fields:(NSArray *)fields fieldsType:(NSArray *)fieldsType;

/**
 插入数据

 @param tableName  表名称
 @param dictFields key为表字段，value为对应的字段值
 */
+ (void)QLInsertDataToTable:(NSString *)tableName dictFields:(NSDictionary *)dictFields;

/**
 修改数据

 @param tableName        表名称
 @param dictFields       key为表字段，value为对应的字段值
 @param conditionsKey    条件字段
 @param conditionsValues 条件值
 */
+ (void)QLModifyDataToTable:(NSString *)tableName dictFields:(NSDictionary *)dictFields conditionsKey:(NSString *)conditionsKey conditionsValues:(NSString *)conditionsValues;

/**
 删除单条数据

 @param tableName  表名称
 @param fieldKey   表字段
 @param fieldValue 表字段对应的值
 */
+ (void)QLDeleteSingleDataFromTable:(NSString *)tableName fieldKey:(NSString *)fieldKey fieldValue:(id)fieldValue;

/**
 删除全部数据

 @param tableName 表名称
 */
+ (void)QLDeleteDataFromTable:(NSString *)tableName;

/**
 查询数据

 @param tableName 表名称
 @param fieldsKey 表字段
 */
+ (NSMutableArray *)QLSelectDataFromTable:(NSString *)tableName fieldsKey:(NSArray *)fieldsKey;

/**
 删除表

 @param tableName 表名称
 */
+ (void)QLDropTable:(NSString *)tableName;

/**
 新增表字段

 @param tableName 表名
 @param newField  新增表字段
 */
+ (void)QLChangeTable:(NSString *)tableName newField:(NSString *)newField;

@end

















