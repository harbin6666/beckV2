//
//  PractisDetailVC.h
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"

@interface PractisDetailVC : BaseViewController
@property(nonatomic,strong)NSArray *practisAr;
@property(nonatomic,strong)NSString *outlineid;
@property(nonatomic)NSInteger type;
@property(nonatomic,strong)NSArray *examAr;
@property(nonatomic,strong)NSArray *examPapers;
@end
