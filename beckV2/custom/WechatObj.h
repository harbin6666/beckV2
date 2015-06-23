//
//  WechatObj.h
//  beckV2
//
//  Created by yj on 15/6/23.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
typedef void(^WechatCompletionBlock)(id aResponseObject);
@interface WechatObj : NSObject<WXApiDelegate>
singleton_interface(WechatObj)
@property(nonatomic,strong)NSString*accessToken;
-(void)sendPayProduct:(NSString*)orderName price:(NSString *)price orderNum:(NSString*)num Block:(WechatCompletionBlock)block;
-(void)sendLoginBlock:(WechatCompletionBlock)block;
@end
