//
//  ChoiceQuestion.h
//  beckV2
//
//  Created by yj on 15/5/31.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoiceQuestion : NSObject
@property(nonatomic,strong)NSString *choice_id;
@property(nonatomic,strong)NSString *custom_id;
@property(nonatomic,strong)NSString *source;
@property(nonatomic,strong)NSString *outlet_id;
@property(nonatomic,strong)NSString *subject_id;
@property(nonatomic,strong)NSString *lib_id;
@property(nonatomic,strong)NSString *product_id;
@property(nonatomic,strong)NSString *hardness;
@property(nonatomic,strong)NSString *choice_num;
@property(nonatomic,strong)NSString *choice_content;
@property(nonatomic,strong)NSString *is_img;
@property(nonatomic,strong)NSString *choice_parse;
@property(nonatomic,strong)NSString *answer;
@property(nonatomic,strong)NSString *is_valid;
@property(nonatomic,strong)NSString *descript;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *img_content;
@end
