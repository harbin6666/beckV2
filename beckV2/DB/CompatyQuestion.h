//
//  CompatyQuestion.h
//  beckV2
//
//  Created by yj on 15/5/31.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "Question.h"

@interface CompatyInfo : Question
@property(nonatomic,strong)NSString *info_id;
@property(nonatomic,strong)NSString *outlet_id;
@property(nonatomic,strong)NSString *lib_id;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *product_id;
@property(nonatomic,strong)NSString *hardness;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *is_valid;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *is_img;
@property(nonatomic,strong)NSString *img_content;
@end


@interface CompatyQuestion : NSObject
@property(nonatomic,strong)NSString *question_id;
@property(nonatomic,strong)NSString *choice_content;
@property(nonatomic,strong)NSString *is_img;
@property(nonatomic,strong)NSString *choice_parse;
@property(nonatomic,strong)NSString *answer_id;
@property(nonatomic,strong)NSString *compatibility_id ;
@property(nonatomic,strong)NSString *descript ;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *img_content;

@property(nonatomic,strong)NSArray *items;
@end


@interface CompatyItem : NSObject
@property(nonatomic,strong)NSString *answerid;
@property(nonatomic,strong)NSString *item_number;
@property(nonatomic,strong)NSString *item_content;

@property(nonatomic,strong)NSString *is_img;
@property(nonatomic,strong)NSString *compatibiliy_id;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *img_content;

@end