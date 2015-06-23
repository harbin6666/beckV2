//
//  HomeVC.h
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeVC : BaseViewController
@property(nonatomic,assign)BOOL logined;
-(void)updateDB;
@end
