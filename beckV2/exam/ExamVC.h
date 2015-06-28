//
//  ExamVC.h
//  beckV2
//
//  Created by yj on 15/6/8.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"
#import "ExamPaper.h"
@interface ExamVC : BaseViewController
@property(nonatomic,strong)NSArray *questionsAr;
@property(nonatomic,strong)ExamPaper *examComp;
@property(nonatomic)BOOL fromDB;
@property(nonatomic,strong)NSString *paperid;
@end
