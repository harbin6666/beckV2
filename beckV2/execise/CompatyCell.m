//
//  CompatyCell.m
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "CompatyCell.h"

@interface CompatyCell()
@property(nonatomic,copy)ItemSelectBlock block;
@property(nonatomic,strong)CompatyQuestion *question;
@end
@implementation CompatyCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCompatyCell:(CompatyQuestion*)compatyQ selectedBlock:(ItemSelectBlock)block{
    self.question=compatyQ;
    CGFloat width=self.contentView.frame.size.width/compatyQ.items.count;
    self.block=block;
    for (int i=0; i<compatyQ.items.count; i++) {
        CompatyItem *item=compatyQ.items[i];
        UIView *v=[[UIView alloc] initWithFrame:CGRectMake(width*i, 44, width, 40)];
        [self.contentView addSubview:v];
        
        UIImageView *sel=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
        [v addSubview:sel];
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=v.bounds;
        b.tag=i+100;
        [b setTitle:item.item_content forState:UIControlStateNormal];
        b.titleLabel.textAlignment=NSTextAlignmentCenter;
        [b addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b];
    }

}

-(void)itemClick:(UIButton*)sender{
    
    CompatyItem *item=self.question.items[sender.tag-100];
    if ([item.answerid isEqualToString:self.question.answer_id]) {
        self.block(YES);
    }else{
        self.block(NO);
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
