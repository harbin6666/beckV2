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
@end
