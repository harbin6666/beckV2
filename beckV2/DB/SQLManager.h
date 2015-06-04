//
//  SQLManager.h
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLManager : NSObject
singleton_interface(SQLManager);

-(NSArray*)getTitles;

-(NSDictionary*)getAddinParam;


-(NSInteger)getExamDate:(NSString*)titleid;

-(void)excuseSql:(NSString*)sql;

//用postion id查科目subjcetid
-(NSArray*)getSubjectByid:(NSArray *)subjectIdList;

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

-(void)openDB;
-(void)creatDB;
@end
