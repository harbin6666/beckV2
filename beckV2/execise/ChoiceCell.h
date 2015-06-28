//
//  ChoiceCell.h
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceItem.h"
#import "PractisAnswer.h"
#import "AnswerObj.h"

@interface ChoiceCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lab;
-(void)updateWithChoice:(ChoiceItem*)item answer:(PractisAnswer*)answer showAnswer:(BOOL)b;
@property(nonatomic,weak)IBOutlet UIImageView *mark;
@property(nonatomic,weak)IBOutlet UIImageView *radio;
-(void)updateWithChoice:(ChoiceItem*)item questionAnswerA:(QuestionAnswerA*)answer showAnswer:(BOOL)b;
@end
