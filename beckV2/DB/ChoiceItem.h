//
//  ChoiceItem.h
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoiceItem : NSObject
@property(nonatomic,strong)NSString *choice_id;
@property(nonatomic,strong)NSString *item_number;
@property(nonatomic,strong)NSString *item_content;

@property(nonatomic,strong)NSString *is_img;
@property(nonatomic,strong)NSString *is_answer;
@property(nonatomic,strong)NSString *memo;
@property(nonatomic,strong)NSString *img_content;

@end
