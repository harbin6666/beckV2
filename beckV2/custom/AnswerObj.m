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

@end
@implementation QuestionAnswerA
-(id)init{
    if (self=[super init]) {
        _myAnswer=[[NSMutableArray alloc] init];
    }
    return self;
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

@end
@implementation QuestionItemC
@end