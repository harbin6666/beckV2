//
//  Collection.h
//  beckV2
//
//  Created by yj on 15/6/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collection : NSObject
@property(nonatomic,strong)NSString *item_id;
@property(nonatomic,strong)NSString *type_id;
@property(nonatomic,strong)NSString *add_time;
@property(nonatomic,strong)NSString *outline_id;
@property(nonatomic,strong)NSString *subject_id;

@end
@interface WrongItem : Collection
@property(nonatomic,strong)NSString *count;
@end