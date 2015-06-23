//
//  ExamPaper.h
//  beckV2
//
//  Created by yj on 15/6/7.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamPaper : NSObject
@property(nonatomic,strong)NSString *paper_id;
@property(nonatomic,strong)NSString *paper_name;
@property(nonatomic,strong)NSString *publish_type;
@property(nonatomic,strong)NSString *outline_id;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *fullmark;
@property(nonatomic,strong)NSString *total_amount;
@property(nonatomic,strong)NSString *answer_time;
@property(nonatomic,strong)NSString *subject_id;
@property(nonatomic,strong)NSString *lib_id;
@property(nonatomic,strong)NSString *year;
@property(nonatomic,strong)NSString *product_id;
@property(nonatomic,strong)NSString *creator_id;
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSString *is_pbulish;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *points;
@property(nonatomic,strong)NSString *is_display;
@property(nonatomic,strong)NSString *descript;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *title_id;
@property(nonatomic,strong)NSString *screening;
@end
@interface ExamPaperComposition : NSObject
@property(nonatomic,strong)NSString*comp_id;
@property(nonatomic,strong)NSString*paper_id;
@property(nonatomic,strong)NSString*lib_id;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSString*score;
@property(nonatomic,strong)NSString*count;
@property(nonatomic,strong)NSString*priority;
@property(nonatomic,strong)NSString*content;
@property(nonatomic,strong)NSString*custom_id;
@property(nonatomic,strong)NSString*descript;
@property(nonatomic,strong)NSString*memo;

@end
@interface ExamPaper_Content : NSObject
@property(nonatomic,strong)NSString*content_id;
@property(nonatomic,strong)NSString*comp_id;
@property(nonatomic,strong)NSString*paper_id;
@property(nonatomic,strong)NSString*item_id;
@property(nonatomic,strong)NSString*priority;
@property(nonatomic,strong)NSString*score;
@property(nonatomic,strong)NSString*custom_id;
@property(nonatomic,strong)NSString*descript;
@property(nonatomic,strong)NSString*memo;


@end

@interface UserExam : NSObject
@property(nonatomic,strong)NSString *paper_id;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *subject_id;
@property(nonatomic,strong)NSString *lib_id;
@property(nonatomic,strong)NSString *product_id;

@property(nonatomic,strong)NSString *begin_time;
@property(nonatomic,strong)NSString *end_time;
@property(nonatomic,strong)NSString *score;

@property(nonatomic,strong)NSString *user_answer;

@property(nonatomic,strong)NSString *right_amount;
@property(nonatomic,strong)NSString *wrong_amount;
@property(nonatomic,strong)NSString *descript;
@property(nonatomic,strong)NSString *memo;

@end