//
//  ChoiceCell.m
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ChoiceCell.h"
@interface ChoiceCell()
@property(nonatomic,copy)ItemSelectBlock block;
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
-(void)updateWithChoice:(ChoiceItem*)item{
    self.item=item;
    self.lab.text=[NSString stringWithFormat:@"%@ %@",item.item_number,item.item_content];
    self.lab.numberOfLines=2;
    self.selectedBackgroundView=[[UIView alloc] init];
}
@end
