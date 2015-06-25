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
#import "ExamPaper.h"

#import "MessageVO.h"
#import "Collection.h"
#import "UserPractis.h"
#import "PractisAnswer.h"
@interface SQLManager()

@end
@implementation SQLManager

singleton_implementation(SQLManager);
-(NSArray*)findUserWrongByUserId:(NSString*)uid{
    __block NSMutableArray*result=@[].mutableCopy;
//    NSString *sql=[NSString stringWithFormat: @"select * from user_wrong_item where user_id==%@",[[Global sharedSingle].userBean valueForKey:@"userId"]];
    NSString *sql=@"select * from user_wrong_item";
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            WrongItem *c=[WrongItem new];
            c.item_id=row[1];
            c.type_id=row[2];
            c.add_time=row[5];
            c.outline_id=row[7];
            c.subject_id=row[8];
            c.count=row[9];
            [result addObject:c];
        }
    }];
    return result;

}

-(NSArray*)findUserCollectByUserid:(NSString *)uid{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat: @"select * from user_collection where user_id==%@",[[Global sharedSingle].userBean valueForKey:@"userId"]];
//    NSString *sql=@"select * from user_collection";
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            Collection *c=[Collection new];
            c.item_id=row[1];
            c.type_id=row[2];
            c.add_time=row[5];
            c.outline_id=row[7];
            c.subject_id=row[8];
            [result addObject:c];
        }
    }];
    return result;

}

-(NSArray*)getExamByType:(NSString *)type{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat: @"select * from exam_paper where title_id==%@ and type==%@",[[Global sharedSingle] getUserWithkey:@"titleid"],type];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ExamPaper *paper=[ExamPaper new];
            paper.paper_id=row[0];
            paper.paper_name=row[1];
            paper.publish_type=row[2];
            paper.outline_id=row[3];
            paper.type=row[4];
            paper.fullmark=row[5];
            paper.total_amount=row[6];
            paper.answer_time=row[7];
            paper.subject_id=row[8];
            paper.lib_id=row[9];
            paper.year=row[10];
            paper.product_id=row[11];
            paper.creator_id=row[12];
            paper.create_time=row[13];
            paper.is_pbulish=row[14];
            paper.price=row[15];
            paper.points=row[16];
            paper.is_display=row[17];
            paper.descript=row[18];
            paper.memo=row[19];
            paper.title_id=row[20];
            paper.screening=row[21];
            [result addObject:paper];
        }
    }];
    return result;

}
-(NSArray*)getPoints{
    __block NSMutableArray *ar=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat: @"select * from point_transaction where user_id ==%@",[[Global sharedSingle].userBean valueForKey:@"userId"] ];
//    NSString *sql=@"select * from point_transaction";
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            NSMutableDictionary *msg=[NSMutableDictionary dictionary];
            msg[@"description"]=row[7];
            msg[@"payDate"]=row[6];
            msg[@"moeny"]=@([row[4] integerValue]);
            [ar addObject:msg];
        }
    }];
    return ar;
    
}
-(NSArray*)getMessage{
    __block NSMutableArray *ar=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat: @"select * from message where user_id ==%@",[[Global sharedSingle].userBean valueForKey:@"userId"] ];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            MessageVO *msg=[MessageVO new];
            msg.title=row[4];
            msg.content=row[5];
            msg.issue_time=row[6];
            [ar addObject:msg];
        }
    }];
    return ar;

}

-(NSString *)getcourseNameByOutlineId:(NSString*)outlineid{
    __block NSString *st=@"";
    NSString *sql=[NSString stringWithFormat:@"select course_name from exam_outline where outline_id==%@",outlineid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            st=row[0];
        }
    }];
    return st;
}
-(UserNote *)findNoteByItemId:(NSString*)itemid customId:(NSString*)customId{
    __block UserNote *note=[UserNote new];
    NSString *sql=[NSString stringWithFormat:@"select * from user_note where item_id==%@ and type_id==%@",itemid,customId];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            
            note.item_id=row[1];
            note.type_id=row[2];
            note.user_id=row[3];
            note.add_time=row[5];
            note.update_time=row[6];
            note.outline_id=row[8];
            note.subject_id=row[9];
            note.note=row[10];
        }
    }];
    return note;
}
-(NSMutableArray*)getUserNoteByOutlineId:(NSString*)outlineid{
    __block NSMutableArray*result=@[].mutableCopy;

    //获取章节下子课程
    NSArray* ar=[self getOutLineByParentId:outlineid];
    for (int i=0; i<ar.count; i++) {
        Outline*o=ar[i];
        NSString *sql=[NSString stringWithFormat:@"select * from user_note where outline_id==%@",o.outlineid];
        [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
            if (finished) {
                
            }else{
                UserNote *note=[UserNote new];
                note.item_id=row[1];
                note.type_id=row[2];
                note.user_id=row[3];
                note.add_time=row[5];
                note.update_time=row[6];
                note.outline_id=row[8];
                note.subject_id=row[9];
                note.note=row[10];
                [result addObject:note];
            }
        }];

        
        
    }
  
    return result;
    
}



-(NSString*)getMaxidWithTableName:(NSString*)tableName colName:(NSString*)col{
    NSString *sql1 = [NSString stringWithFormat:@"select max(%@) from %@",col,tableName];
    __block NSString *s=@"";
    [[AFSQLManager sharedManager] performQuery:sql1 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            s = row[0];
        }
    }];
    if (s==nil||[s isKindOfClass:[NSNull class]]||s.length==0) {
        s=@"0";
    }
    return s;
}


-(Question*)getExamQuestionByItemId:(NSString*)qid customid:(NSString*)customid{
    __block NSMutableArray *ar=[NSMutableArray array];

    //到配伍题表找
    if (customid.integerValue==10||customid.integerValue==11) {
        NSString *compatibility=[NSString stringWithFormat:@"select * from compatibility_info where id==%@",qid];
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

    }else{
        NSString *choice=[NSString stringWithFormat:@"select * from choice_questions where choice_id==%@",qid];
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

    }
    if (ar.count) {
        return ar[0];
    }
    return nil;
}
-(NSArray*)getPractisWithOutlineid:(NSString*)outlineid{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from user_exercise where outline_id==%@ ",outlineid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            UserPractis *paper=[UserPractis new];
            paper.accurate_rate=row[8];
            paper.amount=row[9];
            paper.end_time=row[7];
            paper.outlineId=row[5];
            [result addObject:paper];
        }
    }];
    return result;

}

-(NSArray*)getExamPaperContentByPaperid:(NSString*)paperid{
    
    
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from exam_paper_content where paper_id==%@ ORDER BY priority asc",paperid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ExamPaper_Content *paper=[ExamPaper_Content new];
            paper.content_id=row[0];
            paper.paper_id=row[2];
            paper.comp_id=row[1];
            paper.item_id=row[3];
            paper.priority=row[4];
            paper.score=row[5];
            paper.custom_id=row[6];
            paper.descript=row[7];
            paper.memo=row[8];
            [result addObject:paper];
        }
    }];
    return result;
}

-(NSArray*)getExamPaperContentByPaperid:(NSString*)paperid compid:(NSString*)compid{
    
    
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from exam_paper_content where paper_id==%@ and comp_id==%@ ORDER BY priority asc",paperid,compid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ExamPaper_Content *paper=[ExamPaper_Content new];
            paper.content_id=row[0];
            paper.paper_id=row[2];
            paper.comp_id=row[1];
            paper.item_id=row[3];
            paper.priority=row[4];
            paper.score=row[5];
            paper.custom_id=row[6];
            paper.descript=row[7];
            paper.memo=row[8];
            [result addObject:paper];
        }
    }];
    return result;
}

-(NSArray*)getExamPaperCompositonByPaperId:(NSString*)paperid{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from exam_paper_composition where paper_id==%@",paperid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ExamPaperComposition *paper=[ExamPaperComposition new];
            paper.comp_id=row[0];
            paper.paper_id=row[1];
            paper.lib_id=row[2];
            paper.title=row[3];
            paper.score=row[4];
            paper.count=row[5];
            paper.priority=row[6];
            paper.content=row[7];
            paper.custom_id=row[8];
            paper.descript=row[9];
            paper.memo=row[10];
            [result addObject:paper];
        }
    }];
    return result;
}
-(NSArray*)getExamPaperType:(NSString*)type screen:(NSString *)screenid{
    __block NSMutableArray*result=@[].mutableCopy;
//    NSString *subjectid=[self getSubjectidByTitleId:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    
    
    NSString *sql=[NSString stringWithFormat: @"select * from exam_paper where title_id==%@ and type==%@ and screening==%@",[[Global sharedSingle] getUserWithkey:@"titleid"],type,screenid ];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ExamPaper *paper=[ExamPaper new];
            paper.paper_id=row[0];
            paper.paper_name=row[1];
            paper.publish_type=row[2];
            paper.outline_id=row[3];
            paper.type=row[4];
            paper.fullmark=row[5];
            paper.total_amount=row[6];
            paper.answer_time=row[7];
            paper.subject_id=row[8];
            paper.lib_id=row[9];
            paper.year=row[10];
            paper.product_id=row[11];
            paper.creator_id=row[12];
            paper.create_time=row[13];
            paper.is_pbulish=row[14];
            paper.price=row[15];
            paper.points=row[16];
            paper.is_display=row[17];
            paper.descript=row[18];
            paper.memo=row[19];
            paper.title_id=row[20];
            paper.screening=row[21];
            [result addObject:paper];
        }
    }];
    return result;

    
}
-(NSArray*)getUserExamByPaperId:(NSString *)pId{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat: @"select * from user_exam where user_id==%@ and paper_id==%@",[Global sharedSingle].userBean[@"userId"] ,pId];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            UserExam *paper=[UserExam new];
            paper.paper_id=row[1];
            paper.type=row[2];
            paper.user_id=row[3];
            paper.product_id=row[4];
            paper.subject_id=row[5];
            paper.lib_id=row[6];
            paper.begin_time=row[7];
            paper.end_time=row[8];
            paper.score=row[9];
            paper.user_answer=row[10];
            paper.right_amount=row[11];
            paper.wrong_amount=row[12];
            paper.descript=row[13];
            paper.memo=row[14];
            [result addObject:paper];
        }
    }];
    return result;
    
}



-(NSArray*)getCompatyItemByCompid:(NSString *)compatyid memo:(NSString*)memo{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from compatibility_items where compatibility_id==%@ and memo =%@",compatyid,memo];
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
-(ChoiceItem *)getChoiceItemById:(NSString*)nid{
   __block ChoiceItem* item=[ChoiceItem new];;
    NSString *sql=[NSString stringWithFormat:@"select * from choice_items where id==%@",nid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            item.nid=row[0];
            item.choice_id=row[1];
            item.item_number=row[2];
            item.item_content=row[3];
            item.is_img=row[4];
            item.is_answer=row[5];
            item.memo=row[6];
            item.img_content=row[7];
        }
    }];
    return item;
}

-(NSArray*)getChoiceItemByChoiceId:(NSString*)choiceid{
    __block NSMutableArray*result=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from choice_items where choice_id==%@",choiceid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            ChoiceItem *item=[ChoiceItem new];
            item.nid=row[0];
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
-(NSString *)getQuestionTypeWithCustomId:(NSString*)customid{
    __block NSString *str=@"";
    NSString *sql=[NSString stringWithFormat:@"select custom_name from custom_question_type where custom_id==%@",customid];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            str=row[0];
        }

    }];
    return str;
}

-(NSArray*)getDonePractis:(NSString*)outlineid{
    __block NSMutableArray *total=@[].mutableCopy;
    NSString *sql=[NSString stringWithFormat:@"select * from user_exercise_ext where outline_id==%@ and user_id==%@",outlineid,[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            PractisAnswer *an=[PractisAnswer new];
            NSString *s=row[10];
            if (s.integerValue==1) {
                an.isRight=@"true";
            }else if (s.integerValue==0){
                an.isRight=@"false";
            }
            an.priority=row[11];
            an.titleId=row[7];
            an.titleTypeId=row[8];
            
            NSString *answer=row[9];
            NSArray *ar=[NSJSONSerialization JSONObjectWithData:[answer dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            if (an.titleTypeId.integerValue!=10&&an.titleTypeId.integerValue!=11) {
                an.userAnswer=[NSMutableArray array];
                for (NSString *s in ar) {
                    ChoiceItem *item=[self getChoiceItemById:s];
                    [an.userAnswer addObject:item];
                }
            }
            
            [total addObject:an];
        }
    }];
    return total;
}
//已经做过的题目
-(NSInteger)countDoneByOutlineid:(NSString*)outlineid{
    __block NSInteger total=0;
    NSString *sql=[NSString stringWithFormat:@"select count(*) from (select * from user_exercise_ext where outline_id==%@)",outlineid];
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
    NSLog(@"%@",sql);
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
    NSString *sql=@"select * from position_title_info ORDER BY is_valid desc";
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            Position *postion=[Position new];
            postion.titleId=row[0];
            postion.titleName=row[1];
            postion.type_id=row[3];
            postion.is_vaild=row[4];
            [array addObject:postion];
        }
    }];
    return array;
}

-(NSString*)getSubjectidByTitleId:(NSArray*)titleid{
    __block NSString *subjectid=nil;
    NSString *sql=[NSString stringWithFormat:@"select subject_id from subject_position_relation where title_id==%@",titleid];
    [[AFSQLManager sharedManager]performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            subjectid=[row firstObject];
        }
    }];
    return subjectid;
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
    NSString *sql1 =[NSString stringWithFormat:@"select max(id) from point_transaction where user_id==%@",[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:sql1 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"pointId"] = row.firstSqlObj;
        }
    }];
    NSString *sql2 = [NSString stringWithFormat:@"select max(id) from exchange_paper where user_id==%@",[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:sql2 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"exchangerId"] = row.firstSqlObj;
        }
    }];
    
    NSString *sql3 = [NSString stringWithFormat:@"select max(id) from user_note where user_id==%@",[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:sql3 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userNoteId"] = row.firstSqlObj;
        }
    }];
    
    NSString *userCollectionId =[NSString stringWithFormat: @"select max(id) from user_collection where user_id==%@",[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:userCollectionId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userCollectionId"] = row.firstSqlObj;
        }
    }];
    
    NSString *userExamId =[NSString stringWithFormat: @"select max(id) from user_exam where user_id==%@",[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:userExamId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userExamId"] = row.firstSqlObj;
        }
    }];
    
    NSString *userExerciseId =[NSString stringWithFormat: @"select max(id) from user_exercise where user_id==%@",[Global sharedSingle].userBean[@"userId"]];
    [[AFSQLManager sharedManager] performQuery:userExerciseId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userExerciseId"] = row.firstSqlObj;
        }
    }];
    
    NSString *examPaperId = @"select max(paper_id) from exam_paper";
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
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished){
        if (error!=nil) {
            NSLog(@"%@",error);
        }
        if (finished) {
            
        }
    
    }];
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
