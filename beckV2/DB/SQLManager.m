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
#import "Outline.h"
#import "Subject.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
#import "ChoiceItem.h"

@interface SQLManager()

@end
@implementation SQLManager
singleton_implementation(SQLManager);

-(NSArray*)getCompatyItemByCompid:(NSString*)compatyid{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from compatibility_items where compatibility_id==%@",compatyid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            CompatyItem *item=[CompatyItem new];
            item.answerid=row[0];
            item.item_number=row[1];
            item.item_content=row[2];
            item.is_img=row[3];
            item.compatibiliy_id=row[4];
            item.memo=row[5];
            item.img_content=row[6];
            [result addObject:item];
        }
    }];
    return result;    
}

-(NSArray*)getCompatyQuestionsByinfoId:(NSString*)infoId{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from compatibility_questions where compatibility_id==%@",infoId];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            CompatyQuestion *q=[CompatyQuestion new];
            q.question_id=row[0];;
            q.choice_content=row[1];
            q.is_img=row[2];
            q.choice_parse=row[3];
            q.answer_id=row[4];
            q.compatibility_id=row[5] ;
            q.descript=row[6] ;
            q.memo=row[7];
            q.img_content=row[8];
            [result addObject:q];
        }
    }];
    return result;

}

-(NSArray*)getChoiceItemByChoiceId:(NSString*)choiceid{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from choice_items where choice_id==%@",choiceid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ChoiceItem *item=[ChoiceItem new];
            item.choice_id=row[1];
            item.item_number=row[2];
            item.item_content=row[3];
            item.is_img=row[4];
            item.is_answer=row[5];
            item.memo=row[6];
            item.img_content=row[7];
            [result addObject:item];
        }
    }];
    return result;
}

//已经做过的题目
-(NSInteger)countDoneByOutlineid:(NSString*)outlineid{
    __block NSInteger total=0;
    NSString *sql=[NSString stringWithFormat:@"select count(*) from (select * from choice_questions where outlet_id==%@ and is_valid ==0) union all select count(*) from (select * from compatibility_info where outlet_id==%@ and is_valid ==0)",outlineid,outlineid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            total+=[row[0] integerValue];
        }
    }];
    return total;
}

//计算章节下总数
-(NSInteger)countDownByOutlineid:(NSString*)outlineid{
    __block NSInteger total=0;
    NSString *sql=[NSString stringWithFormat:@"select count(*) from (select * from choice_questions where outlet_id==%@) union all select count(*) from (select * from compatibility_info where outlet_id==%@)",outlineid,outlineid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            total+=[row[0] integerValue];
        }
    }];
    return total;
}
//获取章节下选择题和配伍题
-(NSArray*)getQuestionByOutlineId:(NSString*)outlineId{
    __block NSMutableArray *ar=[NSMutableArray array];
    NSString *choice=[NSString stringWithFormat:@"select * from choice_questions where outlet_id==%@ ORDER BY custom_id asc",outlineId];
    [[AFSQLManager sharedManager] performQuery:choice withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ChoiceQuestion *q=[ChoiceQuestion new];
            q.choice_id=row[0];
            q.custom_id=row[1];
            q.source=row[2];
            q.outlet_id=row[3];
            q.subject_id=row[4];
            q.lib_id=row[5];
            q.product_id=row[6];
            q.hardness=row[7];
            q.choice_num=row[8];
            q.choice_content=row[9];
            q.is_img=row[10];
            q.choice_parse=row[11];
            q.answer=row[12];
            q.is_valid=row[13];
            q.descript=row[14];
            q.memo=row[15];
            q.img_content=row[16];
            [ar addObject:q];
        }
    }];
    NSString *compatibility=[NSString stringWithFormat:@"select * from compatibility_info where outlet_id==%@ ORDER BY custom_id asc",outlineId];
    [[AFSQLManager sharedManager] performQuery:compatibility withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            CompatyInfo *q=[CompatyInfo new];
            q.info_id=row[0];
            q.outlet_id=row[1];
            q.lib_id=row[2];
            q.subject_id=row[3];
            q.custom_id=row[4];
            q.source=row[5];
            q.product_id=row[6];
            q.hardness=row[7];
            q.title=row[8];
            q.is_valid=row[9];
            q.memo=row[10];
            q.is_img=row[11];
            q.img_content=row[12];
            [ar addObject:q];
        }
    }];
    return ar;
}

-(NSArray *)getOutLineByParentId:(NSString*)parentid{
    __block NSMutableArray* outlineList=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from exam_outline where parent_id==%@",parentid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            Outline*outline=[Outline new];
            outline.outlineid=row[0];
            outline.subjectid=row[1];
            outline.parentId=row[4];
            outline.courseName=row[5];
            [outlineList addObject:outline];
        }
    }];
    return outlineList;
}
-(NSArray*)getoutLineByid:(NSString *)subjectid{
    __block NSMutableArray* outlineList=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from exam_outline where subject_id ==%@ and parent_id==0",subjectid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            Outline*outline=[Outline new];
            outline.outlineid=row[0];
            outline.subjectid=row[1];
            outline.parentId=row[4];
            outline.courseName=row[5];
            [outlineList addObject:outline];
        }
    }];
    return outlineList;
}

-(NSArray*)getSubjectByid:(NSArray *)subjectIdList{
    __block NSMutableArray* subjectAr=@[].mutableCopy;
    for (int i=0; i<subjectIdList.count; i++) {
        NSString *subjectid=subjectIdList[i];
        NSString *sql=[NSString stringWithFormat:@"select * from exam_subject where id ==%@",subjectid];
        [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
            if (finished) {
                
            }else{
                Subject*sub=[Subject new];
                sub.subjectName=row[1];
                sub.subjectid=subjectid;
                [subjectAr addObject:sub];
            }
        }];

    }
    return subjectAr;
}
//用titleid  查 subjectidlist
-(NSArray* )getSubjectIdArrayByid:(NSString *)titleid{
    __block NSMutableArray *subjectList=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select subject_id from subject_position_relation where title_id==%@",titleid];
    [[AFSQLManager sharedManager]performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            [subjectList addObject:row[0]];
            
        }
    }];
    return subjectList;
}

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
