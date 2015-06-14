//
//  PractisAnswer.h
//  beckV2
//
//  Created by yj on 15/6/6.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PractisAnswer : NSObject<NSCoding>
@property(nonatomic,strong)NSString *isRight;
@property(nonatomic,strong)NSString *priority;
@property(nonatomic,strong)NSString *titleId;
@property(nonatomic,strong)NSMutableArray* userAnswer;
@property(nonatomic,strong)NSString *titleTypeId;
//@property(nonatomic,strong)NSMutableArray *multiAnswer;
-(NSDictionary*)toJson;
-(NSDictionary*)toExamJson;
@end

@interface ExamAnswer : NSObject
@property(nonatomic,strong)NSString *isRight;
@property(nonatomic,strong)NSString *priority;
@property(nonatomic,strong)NSString *titleId;
@property(nonatomic,strong)NSString *userAnswer;
@property(nonatomic,strong)NSString *titleTypeId;
@property(nonatomic,strong)NSMutableArray *multiAnswer;

@end