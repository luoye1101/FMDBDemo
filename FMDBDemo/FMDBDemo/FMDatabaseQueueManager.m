//
//  FMDatabaseQueueManager.m
//  FMDBDemo
//
//  Created by 黄跃奇 on 2017/12/15.
//  Copyright © 2017年 yueqi. All rights reserved.
//

#import "FMDatabaseQueueManager.h"

@implementation FMDatabaseQueueManager

static FMDatabaseQueueManager *instance;

/// 单例的全局访问点
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // databaseQueueWithPath : 指定一个路径,在该路径下创建数据库文件
        NSString *DBPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"contacts.db"];
        NSLog(@"数据库 contacts.db 的路径=== %@", DBPath);
        // 创建数据库
        instance = [FMDatabaseQueueManager databaseQueueWithPath:DBPath];
    });
    return instance;
}

/// 创建数据库表
+ (void)QLCreateTable:(NSString *)tableName fields:(NSArray *)fields fieldsType:(NSArray *)fieldsType {
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key not null,", tableName];
    for (NSInteger i = 0; i < fieldsType.count; i++) {
        if (i != fieldsType.count - 1) {
            sql = [NSString stringWithFormat:@"%@ %@ %@,", sql, fields[i], fieldsType[i]];
        } else {
            sql = [NSString stringWithFormat:@"%@ %@ %@);", sql, fields[i], fieldsType[i]];
        }
    }
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql];
        if (res) {
            NSLog(@"数据库操作==== %@ 表创建成功！", tableName);
        } else {
            NSLog(@"数据库---表创建失败:%@",db.lastErrorMessage);
        }
    }];
}

/// 插入数据
+ (void)QLInsertDataToTable:(NSString *)tableName dictFields:(NSDictionary *)dictFields {
    NSArray *fieldsKeys = dictFields.allKeys;
    NSArray *fieldsValues = dictFields.allValues;
    NSString *sqlUpdateFirst = [NSString stringWithFormat:@"insert into %@(", tableName];
    NSString *sqlUpdateLast = [NSString stringWithFormat:@" values("];
    for (NSInteger i = 0; i < fieldsKeys.count; i++) {

        if (i != fieldsKeys.count - 1) {
            sqlUpdateFirst = [NSString stringWithFormat:@"%@%@, ", sqlUpdateFirst, fieldsKeys[i]];
            sqlUpdateLast = [NSString stringWithFormat:@"%@?, ", sqlUpdateLast];
        } else {
            sqlUpdateFirst = [NSString stringWithFormat:@"%@%@)", sqlUpdateFirst, fieldsKeys[i]];
            sqlUpdateLast = [NSString stringWithFormat:@"%@?);", sqlUpdateLast];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"%@%@", sqlUpdateFirst, sqlUpdateLast];
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql values:fieldsValues error:nil];
        if (res) {
            NSLog(@"数据库操作==== 插入数据成功！");
        } else {
            NSLog(@"数据库---插入数据失败:%@",db.lastErrorMessage);
        }
    }];
}

/// 修改数据
+ (void)QLModifyDataToTable:(NSString *)tableName dictFields:(NSDictionary *)dictFields conditionsKey:(NSString *)conditionsKey conditionsValues:(NSString *)conditionsValues {
    NSArray *fieldsKeys = dictFields.allKeys;
    NSArray *fieldsValues = dictFields.allValues;
    NSString *values = [fieldsValues componentsJoinedByString:@", "];
    NSString *sqlUpdate = [NSString stringWithFormat:@"update %@ set", tableName];
    for (NSInteger i = 0; i < fieldsKeys.count; i++) {
        if (i != fieldsKeys.count - 1) {
            sqlUpdate = [NSString stringWithFormat:@"%@ %@ = ?,", sqlUpdate, fieldsKeys[i]];
        } else {
            sqlUpdate = [NSString stringWithFormat:@"%@ %@ = ?", sqlUpdate, fieldsKeys[i]];
        }
    }
    sqlUpdate = [NSString stringWithFormat:@"%@ where %@ = ?;", sqlUpdate, conditionsKey];
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set uid = ?, name = ? where id = ?;", tableName];
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql, @14, @"wersd", @2];
        if (res) {
            NSLog(@"数据库操作==== 修改数据成功！");
        } else {
            NSLog(@"数据库---修改数据失败:%@",db.lastErrorMessage);
        }
    }];
}

/// 删除单条数据
+ (void)QLDeleteSingleDataFromTable:(NSString *)tableName fieldKey:(NSString *)fieldKey fieldValue:(id)fieldValue {
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = ?;", tableName, fieldKey];
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql values:@[fieldValue] error:nil];
        if (res) {
            NSLog(@"数据库操作==== 删除数据成功！");
        } else {
            NSLog(@"数据库---删除数据失败:%@",db.lastErrorMessage);
        }
    }];
}

/// 删除全部数据
+ (void)QLDeleteDataFromTable:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"delete from %@;", tableName];
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql];
        if (res) {
            NSLog(@"数据库操作==== 删除数据成功！");
        } else {
            NSLog(@"数据库---删除数据失败:%@",db.lastErrorMessage);
        }
    }];
}

/// 查询数据
+ (NSMutableArray *)QLSelectDataFromTable:(NSString *)tableName fieldsKey:(NSArray *)fieldsKey {
    NSString *sql = [NSString stringWithFormat:@"select * from %@;", tableName];
    NSMutableDictionary *dictFieldsValue = [NSMutableDictionary dictionary];
    NSMutableArray *fieldsValue = [NSMutableArray array];
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        while (resultSet.next) {
            for (NSInteger i = 0; i < fieldsKey.count; i++) {
                NSString *value = [resultSet stringForColumn:fieldsKey[i]];
                [dictFieldsValue setValue:value forKey:fieldsKey[i]];
            }
            [fieldsValue addObject:dictFieldsValue];
        }
    }];
    return fieldsValue;
}

/// 删除表
+ (void)QLDropTable:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"drop table if exists %@;", tableName];
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL res = [db executeUpdate:sql];
        if (res) {
            NSLog(@"数据库操作==== 删除表成功！");
        } else {
            NSLog(@"数据库---删除表失败:%@",db.lastErrorMessage);
        }
    }];
}

/// 新增表字段
+ (void)QLChangeTable:(NSString *)tableName newField:(NSString *)newField {
    [instance inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db columnExists:newField inTableWithName:tableName]) {
            NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@ integer;", tableName, newField];
            BOOL res = [db executeUpdate:sql];
            if (res) {
                NSLog(@"数据库操作==== 新增字段成功！");
            } else {
                NSLog(@"数据库---新增字段失败:%@",db.lastErrorMessage);
            }
        }
    }];
}


@end











































