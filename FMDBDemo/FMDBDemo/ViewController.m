//
//  ViewController.m
//  FMDBDemo
//
//  Created by 黄跃奇 on 2017/12/26.
//  Copyright © 2017年 yueqi. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabaseQueueManager.h"

@interface ViewController ()

@property (nonatomic, strong) FMDatabaseQueueManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 实例化全局的数据库管理者
    self.manager = [FMDatabaseQueueManager sharedManager];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //    [FMDatabaseQueueManager QLCreateTable:@"t_student" fields:@[@"uid", @"name", @"title"] fieldsType:@[@"integer", @"text", @"text"]];
    NSDictionary *dict = @{@"name": @"hkjk"};
    //    [FMDatabaseQueueManager QLInsertDataToTable:@"t_student" dictFields:dict];
    [FMDatabaseQueueManager QLModifyDataToTable:@"t_student" dictFields:dict conditionsKey:@"title" conditionsValues:@"boy"];
    //    [FMDatabaseQueueManager QLDeleteSingleDataFromTable:@"t_person" fieldKey:@"id" fieldValue:@2];
    //    [FMDatabaseQueueManager QLDeleteDataFromTable:@"t_person"];
    //    [FMDatabaseQueueManager QLSelectDataFromTable:@"t_person" fieldsKey:@[@"name", @"title"]];
    //    [FMDatabaseQueueManager QLDropTable:@"t_person"];
    //    [FMDatabaseQueueManager QLAlterTable:@"t_student" newTableName:@"t_person"];
    
    //    [FMDatabaseQueueManager QLChangeTable:@"" newTableName:@"t_student" newField:@"sex" fields:@[] fieldsType:@[]];
}


@end
