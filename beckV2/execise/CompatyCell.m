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

@end
@implementation CompatyCell

- (void)awakeFromNib {
    // Initialization code
    self.viewAr=@[].mutableCopy;
}

-(void)updateCompatyCell:(CompatyQuestion*)compatyQ selectedBlock:(ItemSelectBlock)block{
    
    for (UIView *v in self.viewAr) {
        [v removeFromSuperview];
    }

    self.question=compatyQ;
    self.lab.text=[NSString stringWithFormat:@"%zd.%@",self.row+1,compatyQ.choice_content];
    self.lab.tag=10086;
    CGFloat width=self.contentView.frame.size.width/compatyQ.items.count;
    self.block=block;
    for (int i=0; i<compatyQ.items.count; i++) {
        CompatyItem *item=compatyQ.items[i];
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(width*i, 44, width, 40)];
        v.tag=i+100;
        [self.contentView addSubview:v];
        
        UIImageView *sel=[[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 19, 19)];
        sel.image=[UIImage imageNamed:@"radio"];
        sel.tag=99;
        [v addSubview:sel];
        
        
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(20, 5, 20, 30)];
        la.text=item.item_number;
        la.textAlignment=NSTextAlignmentCenter;
        [v addSubview:la];

        UIImageView *signal=[[UIImageView alloc] initWithFrame:CGRectMake(width-20-2, 12, 20, 20)];

        signal.tag=88;
        [v addSubview:signal];
        
        
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=v.bounds;
        b.tag=i+100;
//        b.titleLabel.font=[UIFont systemFontOfSize:13];
//        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [b setTitle:item.item_content forState:UIControlStateNormal];
        b.titleLabel.numberOfLines=2;
        b.highlighted=NO;
        b.titleLabel.textAlignment=NSTextAlignmentLeft;
        [b addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b];
        [self.viewAr addObject:v];
    }

}

-(void)itemClick:(UIButton*)sender{

    
    for (UIView *view in self.viewAr) {
        UIImageView *v=(UIImageView *)[view viewWithTag:99];
        UIImageView *v1=(UIImageView *)[view viewWithTag:88];
        UIButton *btn=(UIButton *)[view viewWithTag:view.tag];
        if (sender.tag==btn.tag) {
            sender.selected=YES;
            v.image=[UIImage imageNamed:@"radio_sel"];
        }else{
            sender.selected=NO;
            v.image=[UIImage imageNamed:@"radio"];

        }
        v1.hidden=YES;
        view.layer.borderColor=[UIColor clearColor].CGColor;

    }
    

    UIImageView *v1=(UIImageView *)[sender.superview viewWithTag:88];


    CompatyItem *item=self.question.items[sender.tag-100];
    if ([item.answerid isEqualToString:self.question.answer_id]) {
        self.block(YES);
    }else{
        self.block(NO);
        v1.image=[UIImage imageNamed:@"choiceWrong"];
        v1.hidden=NO;
        for (int i=0;i<self.question.items.count;i++) {
            CompatyItem *item=self.question.items[i];
            if ([item.answerid isEqualToString:self.question.answer_id]) {
                UIView *view=[self.contentView viewWithTag:i+100];
                view.layer.borderColor=[UIColor greenColor].CGColor;
                view.layer.borderWidth=1;
                
                UIImageView*imgv=(UIImageView *)[view viewWithTag:88];
                imgv.image=[UIImage imageNamed:@"choiceRight"];
                imgv.hidden=NO;
                
            }
        }

    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
