//
//  Global.h
//  beckV2
//
//  Created by yj on 15/5/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject
singleton_interface(Global)
@property(nonatomic,assign)BOOL logined;
@property(nonatomic,strong)NSString *loginName;
@property(nonatomic,strong)NSMutableDictionary *userBean;
@property(nonatomic,strong)NSString *passWord;
@property(nonatomic,strong)NSString *userId;
-(void)setUserValue:(id)value Key:(NSString*)key;
-(id)getUserWithkey:(NSString*)key;
@property(nonatomic,strong)NSString *nickName;
@end
