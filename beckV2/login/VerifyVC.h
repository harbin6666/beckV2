//
//  VerifyVC.h
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyVC : BaseViewController
@property(nonatomic,strong)NSString *verifyPhone;
@property(nonatomic,strong)NSString *smsCode;
@property(nonatomic,assign)BOOL findpw;

@end
