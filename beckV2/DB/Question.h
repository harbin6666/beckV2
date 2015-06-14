//
//  Question.h
//  beckV2
//
//  Created by yj on 15/6/3.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(int, Answertype){
    answeredNone=0,
    answeredRight=1,
    answeredwrong=2
};

@interface Question : NSObject
@property(nonatomic,assign)Answertype answerType;
@property(nonatomic,strong)NSString *custom_id;
@property(nonatomic,strong)NSString *subject_id;
//user action
@property(nonatomic,strong)id userAnswer;
@end
