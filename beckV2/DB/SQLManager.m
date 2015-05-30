//
//  SQLManager.m
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "SQLManager.h"
#import "Position.h"
#import <AFSQLManager/AFSQLManager.h>

@implementation SQLManager
singleton_implementation(SQLManager);
-(NSArray*)getTitles{
    __block NSMutableArray *array=@[].mutableCopy;
    NSString *sql=@"select title_id,title_name from position_title_info";
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            Position *postion=[Position new];
            postion.titleId=row[0];
            postion.titleName=row[1];
            [array addObject:postion];
        }
    }];
    return array;
}
-(NSInteger)getExamDate:(NSString*)titleid{

    __block NSString *subjectid=nil;
    NSString *sql=[NSString stringWithFormat:@"select subject_id from subject_position_relation where title_id==%@",titleid];
    [[AFSQLManager sharedManager]performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {

        }
        else {
            subjectid=[row firstObject];
        }
    }];
    __block NSString *datestr=nil;
    NSString* sql1=[NSString stringWithFormat:@"select * from product_subject_relation where subject_id==%@",subjectid];
    [[AFSQLManager sharedManager] performQuery:sql1 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            datestr=row[6];
        }

    }];
    NSInteger delta=[datestr string2Date];
    return delta;
}
-(NSDictionary*)getAddinParam{
    /**
     * @param token=” addIn”(固定值)
     * @param loginName  string
     * @param pointId string 表point_transaction最大ID 默认为0
     * @param exchangerId string表exchange_paper最大ID
     * @param userNoteId string表user_note最大ID
     
     * @param userCollectionId string表user_collection最大ID
     * @param userExamId string表user_exam最大ID
     
     * @param userExerciseId string表user_exam_subject最大ID
     * @param examPaperId  string表exam_paper最大ID
     
     * @param titlePaperId string表subject_position_paper最大ID
     */
    
    NSMutableDictionary*addIn=@{@"token":@"addIn",@"loginName":[Global sharedSingle].loginName}.mutableCopy;
    NSString *sql1 = @"select max(id) from point_transaction";
    [[AFSQLManager sharedManager] performQuery:sql1 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"pointId"] = row.firstSqlObj;
        }
    }];
    NSString *sql2 = @"select max(id) from exchange_paper";
    [[AFSQLManager sharedManager] performQuery:sql2 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"exchangerId"] = row.firstSqlObj;
        }
    }];
    
    NSString *sql3 = @"select max(id) from user_note";
    [[AFSQLManager sharedManager] performQuery:sql3 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userNoteId"] = row.firstSqlObj;
        }
    }];
    
    NSString *userCollectionId = @"select max(id) from user_collection";
    [[AFSQLManager sharedManager] performQuery:userCollectionId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userCollectionId"] = row.firstSqlObj;
        }
    }];
    
    NSString *userExamId = @"select max(id) from user_exam";
    [[AFSQLManager sharedManager] performQuery:userExamId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userExamId"] = row.firstSqlObj;
        }
    }];
    
    NSString *userExerciseId = @"select max(id) from user_exam_subject";
    [[AFSQLManager sharedManager] performQuery:userExerciseId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userExerciseId"] = row.firstSqlObj;
        }
    }];
    
    NSString *examPaperId = @"select max(id) from exam_paper";
    [[AFSQLManager sharedManager] performQuery:examPaperId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"examPaperId"] = row.firstSqlObj;
        }
    }];
    
    NSString *titlePaperId = @"select max(id) from subject_position_paper";
    [[AFSQLManager sharedManager] performQuery:titlePaperId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"titlePaperId"] = row.firstSqlObj;
        }
    }];
    return addIn;
}

-(void)excuseSql:(NSString*)sql{
    [[AFSQLManager sharedManager] performQuery:sql withBlock:nil];
}

-(void)openDB{
    [[AFSQLManager sharedManager] openLocalDatabaseWithName:@"beck.db" andStatusBlock:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"beck db open success");
        }
        else {
            NSLog(@"beck db open failed");
        }
    }];

}
@end
