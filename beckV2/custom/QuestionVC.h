//
//  QuestionVC.h
//  beckV2
//
//  Created by yj on 15/6/28.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"
#import "ExamPaper.h"
@interface QuestionVC : BaseViewController
@property(nonatomic,strong)NSString *paperid;
@property(nonatomic,strong)ExamPaper *examComp;
@property(nonatomic,strong)NSString *outletid;
@property(nonatomic)BOOL showAnswer,showTimer;//显示倒计时否
@property(nonatomic)BOOL practisMode,fromDetail,fromPractisDetail;
@end
