//
//  CompatyCell.m
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "CompatyCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AnswerObj.h"
@interface CompatyCell()
@property(nonatomic,copy)ItemSelectBlock block;
@property(nonatomic,strong)CompatyQuestion *question;
@property(nonatomic,strong)NSMutableArray *viewAr;
@property(nonatomic,strong)NSMutableArray *answers;
@property(nonatomic,strong)PractisAnswer *answ;

@property(nonatomic)BOOL show;
@property(nonatomic,strong)AnswerObj *answerObj;
@end
@implementation CompatyCell

- (void)awakeFromNib {
    // Initialization code
    self.viewAr=@[].mutableCopy;
}

-(void)updateCompatyCell:(CompatyQuestion*)compatyQ customid:(NSString *)qCustomid AnswerObj:(AnswerObj*)answer showAnswer:(BOOL)show selectedBlock:(ItemSelectBlock)block{
    self.answerObj=answer;
    NSArray *answerItems=[NSMutableArray array];
    if (self.customid==11) {
        QuestionAnswerC*c=(QuestionAnswerC*)answer;
        answerItems=c.questionCItems;
    }else{
        QuestionAnswerB*b=(QuestionAnswerB*)answer;
        answerItems=b.questionItemBs;
    }
    self.question=compatyQ;

    for (UIView *v in self.viewAr) {
        [v removeFromSuperview];
    }
    
    self.lab.text=[NSString stringWithFormat:@"%zd.%@",self.row+1,compatyQ.choice_content];
    self.lab.numberOfLines=0;
    self.lab.tag=10086;
    CGFloat width=self.contentView.frame.size.width/compatyQ.items.count;
    if (qCustomid.intValue==11) {
        width=self.contentView.frame.size.width;
    }
    if (block) {
        self.block=block;
    }
    
    for (int i=0; i<compatyQ.items.count; i++) {
        CompatyItem *item=compatyQ.items[i];
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(width*i, self.lab.frame.size.height, width, 40)];
        if (qCustomid.intValue==11) {
            v.frame=CGRectMake(0, self.lab.frame.size.height+40*i, width, 40);
        }
        v.tag=i+100;
        [self.contentView addSubview:v];
        
        UIImageView *sel=[[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 19, 19)];
        sel.image=[UIImage imageNamed:@"radio"];
        if (self.customid==10) {
            for (QuestionItemB*b in answerItems) {
                if (b.myAnswer.integerValue==item.answerid.integerValue&&self.question.question_id.integerValue==b.questionId.integerValue) {
                    NSLog(@"%@===%@",self.question.question_id,item.answerid);
                    sel.image=[UIImage imageNamed:@"radio_sel"];
                }
//                else{
//                    sel.image=[UIImage imageNamed:@"radio"];
//                }
            }
        }
        else{
            for (QuestionItemC*b in answerItems) {
                if (b.myAnswer.integerValue==item.answerid.integerValue&&self.question.question_id.integerValue==b.questionId.integerValue) {
                    sel.image=[UIImage imageNamed:@"radio_sel"];
                }
//                else{
//                    sel.image=[UIImage imageNamed:@"radio"];
//                }
            }

        }


        sel.tag=99;
        [v addSubview:sel];
        
        
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 20, 40)];
        la.text=item.item_number;
        la.numberOfLines=0;
        la.textAlignment=NSTextAlignmentCenter;
        la.font=[UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] integerForKey:@"fontValue"]];
        if (qCustomid.intValue==11) {
            la.frame=CGRectMake(20, 0, width-42, 40);
            la.text=[NSString stringWithFormat:@"%@ %@",item.item_number,item.item_content];
            la.textAlignment=NSTextAlignmentLeft;
        }
        
        [v addSubview:la];
        
        UIImageView *signal=[[UIImageView alloc] initWithFrame:CGRectMake(width-20-2, 12, 20, 20)];
        if (qCustomid.intValue==11) {
            signal.frame=CGRectMake(width-20-2, 12, 20, 20);
        }
        if (show) {
            if ([item.answerid isEqualToString:self.question.answer_id]){
                signal.image=[UIImage imageNamed:@"choiceRight"];
            }else{
                signal.image=[UIImage imageNamed:@"choiceWrong"];
            }
        }
        signal.tag=88;
        [v addSubview:signal];
        
        
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=v.bounds;
        b.tag=i+100;
        b.titleLabel.numberOfLines=2;
        b.highlighted=NO;
        b.titleLabel.textAlignment=NSTextAlignmentLeft;
        [b addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b];
        [self.viewAr addObject:v];
    }
    [self setNeedsLayout];
    NSArray *arQ=@[qCustomid,compatyQ];
    [self performSelector:@selector(replaceViews:) withObject:arQ afterDelay:0.1];
    
}


-(void)replaceViews:(NSArray *)arQ{
    NSString *qCustomid=arQ[0];
    CompatyQuestion *compatyQ=arQ[1];
    CGFloat width=self.contentView.frame.size.width/compatyQ.items.count;
    if (qCustomid.intValue==11) {
        width=self.contentView.frame.size.width;
    }
    for (UIView *v in self.viewAr) {
        NSInteger i=v.tag-100;
        if (qCustomid.intValue==11) {
            v.frame=CGRectMake(0, self.lab.frame.size.height+40*i, width, 40);
        }else{
            v.frame=CGRectMake(width*i, self.lab.frame.size.height, width, 40);
        }
    }
    [self setNeedsLayout];
}
-(void)updateCompatyCell:(CompatyQuestion*)compatyQ customid:(NSString *)qCustomid answer:(PractisAnswer*)answer showAnswer:(BOOL)show selectedBlock:(ItemSelectBlock)block{
    self.answ=answer;
    self.customid=qCustomid.integerValue;
    for (UIView *v in self.viewAr) {
        [v removeFromSuperview];
    }

    self.question=compatyQ;
    self.lab.text=[NSString stringWithFormat:@"%zd.%@",self.row+1,compatyQ.choice_content];
    self.lab.tag=10086;
    CGFloat width=self.contentView.frame.size.width/compatyQ.items.count;
    if (qCustomid.intValue==11) {
        width=self.contentView.frame.size.width;
    }
    if (block) {
        self.block=block;
    }
//    NSDictionary *selectDic=nil;
//    if (self.answ.userAnswer.count>0) {
//        selectDic=self.answ.userAnswer[0];
//    }
    for (int i=0; i<compatyQ.items.count; i++) {
        CompatyItem *item=compatyQ.items[i];
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(width*i, 44, width, 40)];
        if (qCustomid.intValue==11) {
            v.frame=CGRectMake(0, 44+40*i, width, 40);
        }
        v.tag=i+100;
        [self.contentView addSubview:v];
        
        UIImageView *sel=[[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 19, 19)];
        sel.image=[UIImage imageNamed:@"radio"];
        
        for (NSDictionary *d in self.answ.userAnswer) {
            if ([d[self.question.question_id] integerValue]==item.answerid.integerValue&&self.question.question_id.integerValue==[d.allKeys[0] integerValue]) {
                sel.image=[UIImage imageNamed:@"radio_sel"];
            }
//            else{
//                sel.image=[UIImage imageNamed:@"radio"];
//                
//            }
        }
        sel.tag=99;
        [v addSubview:sel];
        
        
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 20, 30)];
        la.text=item.item_number;
        la.textAlignment=NSTextAlignmentCenter;
        la.numberOfLines=0;
        la.font=[UIFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] integerForKey:@"fontValue"]];
        if (qCustomid.intValue==11) {
            la.frame=CGRectMake(20, 5, width-42, 30);
            la.text=[NSString stringWithFormat:@"%@ %@",item.item_number,item.item_content];
            la.textAlignment=NSTextAlignmentLeft;
        }

        [v addSubview:la];

        UIImageView *signal=[[UIImageView alloc] initWithFrame:CGRectMake(width-20-2, 12, 20, 20)];
        if (qCustomid.intValue==11) {
            signal.frame=CGRectMake(width-20-2, 12, 20, 20);
        }
        if (show) {
            if ([item.answerid isEqualToString:self.question.answer_id]){
                signal.image=[UIImage imageNamed:@"choiceRight"];
            }else{
                signal.image=[UIImage imageNamed:@"choiceWrong"];
            }
        }
        signal.tag=88;
        [v addSubview:signal];
        
        
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=v.bounds;
        b.tag=i+100;
        b.titleLabel.numberOfLines=2;
        b.highlighted=NO;
        b.titleLabel.textAlignment=NSTextAlignmentLeft;
        [b addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b];
        [self.viewAr addObject:v];
    }

}


-(void)additem:(id)item{
    if ([item isKindOfClass:[QuestionItemB class]]) {
        QuestionAnswerB *b=(QuestionAnswerB*)self.answerObj;
        id dest=nil;
        for (QuestionItemB*itemb in b.questionItemBs) {
            if (itemb.questionId.intValue==[item questionId].intValue) {
                dest=itemb;
                break;
            }
        }
        if (!dest) {
            [b.questionItemBs addObject:item];
        }else{
            [b.questionItemBs removeObject:dest];
            [b.questionItemBs addObject:item];
        }
        
    }else{
        QuestionAnswerC *b=(QuestionAnswerC*)self.answerObj;
        id dest=nil;
        for (QuestionItemC*itemb in b.questionCItems) {
            if (itemb.questionId.intValue==[item questionId].intValue) {
                dest=item;
                break;
            }
        }
        if (!dest) {
            [b.questionCItems addObject:item];
        }else{
            [b.questionCItems removeObject:dest];
            [b.questionCItems addObject:item];
        }

    }
}

-(void)itemClick:(UIButton*)sender{
    CompatyItem *item=self.question.items[sender.tag-100];
    
    if (self.customid==10) {

        QuestionItemB* itemB=[QuestionItemB new];
        itemB.myAnswer=item.answerid;
        itemB.questionId=[self.question question_id];
        itemB.questionAnswerId=[self.question answer_id];
        if ([self.question.answer_id isEqualToString:item.answerid]) {
            itemB.AnswerState=@"1";
        }else{
            itemB.AnswerState=@"0";
        }
        [self additem:itemB];
        
    }else{
        QuestionItemC* itemB=[QuestionItemC new];
        itemB.myAnswer=item.answerid;
        itemB.questionId=[self.question question_id];
//        itemB.questionAnswerId=[self.question answer_id];
        if ([self.question.answer_id isEqualToString:item.answerid]) {
            itemB.AnswerState=@"1";
        }else{
            itemB.AnswerState=@"0";
        }

        [self additem:itemB];
    }
    

    if ([item.answerid isEqualToString:self.question.answer_id]) {
        self.block(YES,item);
    }else{
        self.block(NO,item);
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
