//
//  CompatyCell.m
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "CompatyCell.h"
#import <QuartzCore/QuartzCore.h>
@interface CompatyCell()
@property(nonatomic,copy)ItemSelectBlock block;
@property(nonatomic,strong)CompatyQuestion *question;
@property(nonatomic,strong)NSMutableArray *viewAr;
@property(nonatomic,strong)NSMutableArray *answers;
@property(nonatomic,strong)PractisAnswer *answ;
@property(nonatomic,strong)NSString *customid;
@property(nonatomic)BOOL show;

@end
@implementation CompatyCell

- (void)awakeFromNib {
    // Initialization code
    self.viewAr=@[].mutableCopy;
}


-(void)updateCompatyCell:(CompatyQuestion*)compatyQ customid:(NSString *)qCustomid answer:(PractisAnswer*)answer showAnswer:(BOOL)show selectedBlock:(ItemSelectBlock)block{
    self.answ=answer;
    self.customid=qCustomid;
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

-(void)itemClick:(UIButton*)sender{
    CompatyItem *item=self.question.items[sender.tag-100];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[self.question.question_id]=item.answerid;
    NSDictionary *dest=nil;
    for (NSDictionary *d in self.answ.userAnswer) {
        if (d[self.question.question_id]) {
            dest=d;
        }
    }
    if (dest) {
        [self.answ.userAnswer removeObject:dest];
    }
//    [self.answ.userAnswer removeAllObjects];
    
    
    [self.answ.userAnswer addObject:dic];
//    [self updateCompatyCell:self.question customid:self.customid answer:self.answ showAnswer:self.show selectedBlock:nil];
    
//    for (UIView *view in self.viewAr) {
//        UIImageView *v=(UIImageView *)[view viewWithTag:99];
//        UIImageView *v1=(UIImageView *)[view viewWithTag:88];
//        UIButton *btn=(UIButton *)[view viewWithTag:view.tag];
//        if (sender.tag==btn.tag) {
//            sender.selected=YES;
//            v.image=[UIImage imageNamed:@"radio_sel"];
//        }else{
//            sender.selected=NO;
//            v.image=[UIImage imageNamed:@"radio"];
//
//        }
//        v1.hidden=YES;
//
//    }
//    
//
//    UIImageView *v1=(UIImageView *)[sender.superview viewWithTag:88];
//
//
    if ([item.answerid isEqualToString:self.question.answer_id]) {
        self.block(YES,item);
//        self.answ.isRight=@"true";

    }else{
        self.block(NO,item);
        self.answ.isRight=@"false";
    }
//        v1.image=[UIImage imageNamed:@"choiceWrong"];
//        v1.hidden=NO;
//        for (int i=0;i<self.question.items.count;i++) {
//            CompatyItem *item=self.question.items[i];
//            if ([item.answerid isEqualToString:self.question.answer_id]) {
//                UIView *view=[self.contentView viewWithTag:i+100];
//
//                
//                UIImageView*imgv=(UIImageView *)[view viewWithTag:88];
//                imgv.image=[UIImage imageNamed:@"choiceRight"];
//                imgv.hidden=NO;
//                
//            }
//        }
//
//    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
