//
//  AnswerObj.m
//  beckV2
//
//  Created by yj on 15/6/28.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "AnswerObj.h"

@implementation AnswerObj
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"nid"
                                                       }];
}
-(NSDictionary *)toPracitsJson{
    
    return nil;
}
@end
@implementation QuestionAnswerA
-(id)init{
    if (self=[super init]) {
        _myAnswer=[[NSMutableArray alloc] init];
    }
    return self;
}
-(NSDictionary *)toPracitsJson{
        NSData*data=[NSJSONSerialization dataWithJSONObject:self.myAnswer options:0 error:nil];
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!self.AnswerState) {
        self.AnswerState=@"2";
    }
        NSMutableDictionary *dic=@{@"isRight":self.AnswerState,@"priority":self.priority,@"titleId":self.nid,@"userAnswer":str,@"titleTypeId":self.customId}.mutableCopy;
    if (self.AnswerState.integerValue==1) {
        [dic setValue:@"true" forKey:@"isRight"];
    }else{
        [dic setValue:@"false" forKey:@"isRight"];
    }

    return dic;
}

-(NSMutableArray*)myAnswer{
    if (_myAnswer) {
        return _myAnswer;
    }
    return [[NSMutableArray alloc] init];
}
@end
@implementation QuestionAnswerB

-(id)init{
    if (self=[super init]) {
        _questionItemBs=[[NSMutableArray alloc] init];
    }
    return self;
}
-(NSDictionary *)toPracitsJson{
    NSMutableArray *ar=[NSMutableArray array];
    for (QuestionItemB*itemb in self.questionItemBs) {
        NSDictionary *dic=[NSDictionary dictionaryWithObject:itemb.myAnswer forKey:itemb.questionId];
        [ar addObject:dic];
    }
    NSData*data=[NSJSONSerialization dataWithJSONObject:ar options:0 error:nil];
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic=@{@"isRight":self.AnswerState,@"priority":self.priority,@"titleId":self.nid,@"userAnswer":str,@"titleTypeId":self.customId}.mutableCopy;
    if (self.AnswerState.integerValue==1) {
        [dic setValue:@"true" forKey:@"isRight"];
    }else{
        [dic setValue:@"false" forKey:@"isRight"];
    }
    return dic;
}

@end
@implementation QuestionItemB
@end
@implementation QuestionAnswerC
-(id)init{
    if (self=[super init]) {
        _questionCItems=[[NSMutableArray alloc] init];
    }
    return self;
}
-(NSDictionary *)toPracitsJson{
    NSMutableArray *ar=[NSMutableArray array];
    for (QuestionItemC*itemb in self.questionCItems) {
        NSDictionary *dic=[NSDictionary dictionaryWithObject:itemb.myAnswer forKey:itemb.questionId];
        [ar addObject:dic];
    }
    NSData*data=[NSJSONSerialization dataWithJSONObject:ar options:0 error:nil];
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic=@{@"isRight":self.AnswerState,@"priority":self.priority,@"titleId":self.nid,@"userAnswer":str,@"titleTypeId":self.customId}.mutableCopy;
    if (self.AnswerState.integerValue==1) {
        [dic setValue:@"true" forKey:@"isRight"];
    }else{
        [dic setValue:@"false" forKey:@"isRight"];
    }
    return dic;
}

@end
@implementation QuestionItemC
@end