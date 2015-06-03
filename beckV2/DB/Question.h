//
//  Question.h
//  beckV2
//
//  Created by yj on 15/6/3.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(int, Answertype){
    answeredNone,
    answeredRight,
    answeredwrong
};

@interface Question : NSObject
@property(nonatomic,assign)Answertype answerType;

@end
