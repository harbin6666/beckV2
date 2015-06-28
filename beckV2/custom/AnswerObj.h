//
//  AnswerObj.h
//  beckV2
//
//  Created by yj on 15/6/28.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "JSONModel.h"

@interface AnswerObj : JSONModel
@property(nonatomic,strong)NSString *priority;
@property(nonatomic,strong)NSString *customId;
@property(nonatomic,strong)NSString *nid;
@property(nonatomic,strong)NSString *outletId;
@property(nonatomic,strong)NSString *subjectId;
@property(nonatomic,strong)NSString *AnswerState;
-(NSDictionary*)toPracitsJson;
@end


@interface QuestionAnswerA : AnswerObj//选择
@property(nonatomic,strong)NSMutableArray *myAnswer;
@property(nonatomic)BOOL isAnswerShow;
@property(nonatomic)BOOL isCollect;
@property(nonatomic)BOOL isImg;

@end
@protocol QuestionItemB
@end
@interface QuestionItemB : AnswerObj
@property(nonatomic,strong)NSString *myAnswer;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *questionId;
@property(nonatomic)BOOL isImg;
@property(nonatomic,strong)NSString *questionAnswerId;
@property(nonatomic)BOOL isAnswerShow;
@end

@interface QuestionAnswerB : AnswerObj//综合
@property(nonatomic,strong)NSMutableArray <QuestionItemB>*questionItemBs;
@property(nonatomic)BOOL isCollect;
@property(nonatomic)BOOL isAnswerShow;
@property(nonatomic)BOOL isImg;
@end

@protocol QuestionItemC

@end
@interface QuestionItemC : AnswerObj
@property(nonatomic,strong)NSString *answerId;
@property(nonatomic)BOOL isAnswerShow;
@property(nonatomic)BOOL isImg;
@property(nonatomic,strong)NSString *myAnswer;
@property(nonatomic,strong)NSString *questionId;
@end

@interface QuestionAnswerC : AnswerObj//配伍
@property(nonatomic,strong)NSMutableArray <QuestionItemC>*questionCItems;
@property(nonatomic)BOOL isCollect;
@property(nonatomic)BOOL isAnswerShow;
@property(nonatomic)BOOL isImg;

@end
