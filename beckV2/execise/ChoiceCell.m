//
//  ChoiceCell.m
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ChoiceCell.h"
@interface ChoiceCell()
@property(nonatomic,strong)ChoiceItem *item;

@end
@implementation ChoiceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    if (self.item.is_answer.intValue) {
//        self.block(YES);
//    }else{
//        self.block(NO);
//    }    
}

-(void)updateWithChoice:(ChoiceItem*)item answer:(PractisAnswer*)answer showAnswer:(BOOL)b{
    NSMutableArray*ar=answer.userAnswer;
    self.radio.image=[UIImage imageNamed:@"radio"];

    for (ChoiceItem * it in ar) {
        if (item.nid.integerValue==it.nid.integerValue) {
            self.radio.image=[UIImage imageNamed:@"radio_sel"];
        }
    }
    if (b) {
        if (![answer.isRight isEqualToString:@"true"]) {
            if (item.is_answer.integerValue==1) {
                self.mark.image=[UIImage imageNamed:@"choiceRight"];
            }else{
                self.mark.image=[UIImage imageNamed:@"choiceWrong"];
            }
        }
    }

    
    self.item=item;
    self.lab.text=[NSString stringWithFormat:@"%@ %@",item.item_number,item.item_content];
    self.lab.numberOfLines=2;

    self.selectedBackgroundView=[[UIView alloc] init];
}
@end
