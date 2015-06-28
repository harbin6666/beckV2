//
//  CompatyCell.h
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompatyQuestion.h"
#import "PractisAnswer.h"
#import "AnswerObj.h"
typedef  void(^ItemSelectBlock)(BOOL right,CompatyItem *answer);
@interface CompatyCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lab;
@property(nonatomic)NSInteger row;
@property(nonatomic)NSInteger customid;
-(void)updateCompatyCell:(CompatyQuestion*)compatyQ customid:(NSString *)qCustomid answer:(PractisAnswer*)answer showAnswer:(BOOL)show selectedBlock:(ItemSelectBlock)block;
-(void)updateCompatyCell:(CompatyQuestion*)compatyQ customid:(NSString *)qCustomid AnswerObj:(AnswerObj*)answer showAnswer:(BOOL)show selectedBlock:(ItemSelectBlock)block;
@end
