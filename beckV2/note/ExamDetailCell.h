//
//  ExamDetailCell.h
//  beckV2
//
//  Created by yj on 15/7/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)();
@interface ExamDetailCell : UITableViewCell
-(void)updateWithExamAr:(UserExam *)ue  block:(selectBlock) block;

@end
