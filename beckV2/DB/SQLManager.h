//
//  SQLManager.h
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "UserNote.h"
@interface SQLManager : NSObject
singleton_interface(SQLManager);

-(NSArray*)getPractisWithOutlineid:(NSString*)outlineid;
-(NSString*)getMaxidWithTableName:(NSString*)tableName colName:(NSString*)col;
-(NSArray*)getTitles;

-(NSDictionary*)getAddinParam;


-(NSInteger)getExamDate:(NSString*)titleid;

-(void)excuseSql:(NSString*)sql;

//用postion id查科目subjcetid
-(NSArray*)getSubjectByid:(NSArray *)subjectIdList;

-(NSString*)getSubjectidByTitleId:(NSArray*)titleid;

//用科目 subjectid查 章节outlineid
-(NSArray*)getoutLineByid:(NSString *)subjectid;

-(NSArray* )getSubjectIdArrayByid:(NSString *)titleid;

-(NSArray *)getOutLineByParentId:(NSString*)parentid;

-(NSArray*)getQuestionByOutlineId:(NSString*)outlineId;

-(NSInteger)countDoneByOutlineid:(NSString*)outlineid;

-(NSInteger)countDownByOutlineid:(NSString*)outlineid;


-(NSArray*)getChoiceItemByChoiceId:(NSString*)choiceid;

-(NSArray*)getCompatyQuestionsByinfoId:(NSString*)infoId;

-(NSArray*)getCompatyItemByCompid:(NSString*)compatyid;

-(NSArray*)getCompatyItemByCompid:(NSString *)compatyid memo:(NSString*)memo;

-(NSArray*)getExamPaperType:(NSString*)type screen:(NSString *)screenid;

-(NSArray*)getExamPaperCompositonByPaperId:(NSString*)paperid;

-(NSArray*)getExamPaperContentByPaperid:(NSString*)paperid compid:(NSString*)compid;
-(NSArray*)getExamPaperContentByPaperid:(NSString*)paperid;
-(Question*)getExamQuestionByItemId:(NSString*)qid customid:(NSString*)customid;


-(NSMutableArray*)getUserNoteByOutlineId:(NSString*)outlineid;


-(NSString *)getcourseNameByOutlineId:(NSString*)outlineid;


-(NSArray*)getMessage;


-(NSArray*)getPoints;

-(NSArray*)getExamByType:(NSString *)type;

-(UserNote *)findNoteByItemId:(NSString*)itemid customId:(NSString*)customId;
-(NSArray*)findUserWrongByUserId:(NSString*)uid;
-(NSArray*)findUserCollectByUserid:(NSString*)uid;

-(NSArray*)getUserExamByPaperId:(NSString *)pId;
-(NSString *)getQuestionTypeWithCustomId:(NSString*)customid;
-(NSArray*)getDonePractis:(NSString*)outlineid;
-(void)openDB;

@end
