//
//  ExamDetailVC.h
//  beckV2
//
//  Created by yj on 15/6/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"

@interface ExamDetailVC : BaseViewController
@property(nonatomic)NSInteger type;
@property(nonatomic,strong)NSArray *examAr;
@property(nonatomic,strong)NSArray *examPapers;

@end
