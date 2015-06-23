//
//  AlipayObj.h
//  beckV2
//
//  Created by yj on 15/6/24.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

typedef void(^alipayCompletionBlock)(NSDictionary* aResponseDic);

@interface AlipayObj : NSObject
singleton_interface(AlipayObj)
@property(nonatomic,copy)alipayCompletionBlock block;
-(void)sendPayProduct:(NSString*)orderName price:(NSString *)price orderNum:(NSString*)num Block:(alipayCompletionBlock)block;
@end
