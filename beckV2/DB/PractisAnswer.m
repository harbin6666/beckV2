//
//  PractisAnswer.m
//  beckV2
//
//  Created by yj on 15/6/6.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PractisAnswer.h"

@implementation PractisAnswer
-(NSDictionary*)toJson{
    NSDictionary *dic=@{@"isRight":self.isRight,@"priority":self.priority,@"titleId":self.titleId,@"userAnswer":self.userAnswer,@"titleTypeId":self.titleTypeId};
    return dic;
}

-(NSMutableArray*)multiAnswer{
    if (_multiAnswer==nil) {
        _multiAnswer=[[NSMutableArray alloc] init];
    }
    return _multiAnswer;
}

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
@end
