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
@property(nonatomic,strong)NSDictionary *userBean;
@end
