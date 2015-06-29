//
//  FinishExamVC.h
//  beckV2
//
//  Created by yj on 15/6/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"

@interface FinishExamVC : BaseViewController
@property(nonatomic,strong)NSString *examTitle,*right,*wrong,*cost,*point,*time,*paperid;
@property(nonatomic,strong)ExamPaper*paper;
@end
