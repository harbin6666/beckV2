//
//  UserNote.h
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNote : NSObject
@property(nonatomic,strong)NSString*nid;
@property(nonatomic,strong)NSString*item_id;
@property(nonatomic,strong)NSString*type_id;
@property(nonatomic,strong)NSString*user_id;
@property(nonatomic,strong)NSString*product_id;
@property(nonatomic,strong)NSString*add_time;
@property(nonatomic,strong)NSString*update_time;
@property(nonatomic,strong)NSString*cancel_time;
@property(nonatomic,strong)NSString*outline_id;
@property(nonatomic,strong)NSString*subject_id;
@property(nonatomic,strong)NSString*note;
@end
