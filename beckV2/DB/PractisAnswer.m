//
//  PractisAnswer.m
//  beckV2
//
//  Created by yj on 15/6/6.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PractisAnswer.h"
#import "ChoiceItem.h"

@implementation PractisAnswer
-(NSDictionary*)toJson{
    id answer=nil;
    if (self.titleTypeId.integerValue==10||self.titleTypeId.integerValue==1) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];

        for (NSDictionary *d in self.userAnswer) {
            [dic addEntriesFromDictionary:d];
        }
        answer=dic;
    }else{
        NSMutableArray *ar=[NSMutableArray array];
        for (int i=0; i<self.userAnswer.count; i++) {
            ChoiceItem*it=(ChoiceItem*)self.userAnswer[i];
            [ar addObject:it.nid];
        }
        answer=ar;
    }
    NSData*data=[NSJSONSerialization dataWithJSONObject:answer options:0 error:nil];
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"isRight":self.isRight,@"priority":self.priority,@"titleId":self.titleId,@"userAnswer":str,@"titleTypeId":self.titleTypeId};
    return dic;
}

-(NSDictionary*)toExamJson{
    id answer=nil;
    if (self.titleTypeId.integerValue==10||self.titleTypeId.integerValue==1) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        
        for (NSDictionary *d in self.userAnswer) {
            [dic addEntriesFromDictionary:d];
        }
        answer=dic;
    }else{
        NSMutableArray *ar=[NSMutableArray array];
        for (int i=0; i<self.userAnswer.count; i++) {
            ChoiceItem*it=(ChoiceItem*)self.userAnswer[i];
            [ar addObject:it.nid];
        }
        answer=ar;
    }
    NSData*data=[NSJSONSerialization dataWithJSONObject:answer options:0 error:nil];
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic=@{@"userAnswer":str};
    return dic;
}
/*
 isRight;
 @property(nonatomic,strong)NSString *priority;
 @property(nonatomic,strong)NSString *titleId;
 @property(nonatomic,strong)NSMutableArray* userAnswer;
 @property(nonatomic,strong)NSString *titleTypeId;

 */
-(NSString*)priority{
    if (_priority) {
        return _priority;
    }
    return @"0";
}
-(NSString*)titleId{
    if (_titleId) {
        return _titleId;
    }
    return @"0";
}

-(NSString*)titleTypeId{
    if (_titleTypeId) {
        return _titleTypeId;
    }
    return @"0";
}

-(NSString*)isRight{
    if (_isRight) {
        return _isRight;
    }
    return @"0";
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_isRight forKey:@"isRight"];
    [aCoder encodeObject:_priority forKey:@"priority"];
    [aCoder encodeObject:_titleId forKey:@"titleId"];
    [aCoder encodeObject:_titleTypeId forKey:@"titleTypeId"];
    [aCoder encodeObject:_userAnswer forKey:@"userAnswer"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
                _isRight = [aDecoder decodeObjectForKey:@"isRight"];
                _priority = [aDecoder decodeObjectForKey:@"priority"];
                _titleId = [aDecoder decodeObjectForKey:@"titleId"];
                _titleTypeId = [aDecoder decodeObjectForKey:@"titleTypeId"];
                _userAnswer = [aDecoder decodeObjectForKey:@"userAnswer"];
    }
    return self;
}
//-(NSMutableArray*)multiAnswer{
//    if (_multiAnswer==nil) {
//        _multiAnswer=[[NSMutableArray alloc] init];
//    }
//    return _multiAnswer;
//}

-(NSMutableArray*)userAnswer{
    if (_userAnswer==nil) {
        _userAnswer=[[NSMutableArray alloc] init];
    }
    return _userAnswer;

//    NSMutableString*str=@"".mutableCopy;
//    if (self.multiAnswer!=nil&&self.multiAnswer.count>0) {
//        for (NSString *a in self.multiAnswer) {
//            [str appendFormat:@"%@,",a];
//        }
//        _userAnswer=[str substringToIndex:str.length-2];
//    }
//    return _userAnswer;
}

@end

@implementation ExamAnswer

-(NSString*)userAnswer{
    NSMutableString*str=@"".mutableCopy;
    if (self.multiAnswer!=nil&&self.multiAnswer.count>0) {
        for (NSString *a in self.multiAnswer) {
            [str appendFormat:@"%@,",a];
        }
        _userAnswer=[str substringToIndex:str.length-2];
    }
    return _userAnswer;
}

-(NSMutableArray*)multiAnswer{
    if (_multiAnswer==nil) {
        _multiAnswer=[[NSMutableArray alloc] init];
    }
    return _multiAnswer;
}


@end
