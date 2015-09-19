//
//  QQObj.h
//  beckV2
//
//  Created by yj on 15/6/24.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
typedef void(^QQCompletionBlock)(id aResponseObject);
@interface QQObj : NSObject<TencentLoginDelegate,TencentSessionDelegate>
singleton_interface(QQObj)
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
-(void)loginWithBlock:(QQCompletionBlock)block;
-(void)sharedQQWithBlock:(QQCompletionBlock)block;
@end
