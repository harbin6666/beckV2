//
//  LoginVC.h
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"

@interface LoginVC : BaseViewController<WeiboSDKDelegate,WXApiDelegate>

@end
