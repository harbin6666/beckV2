//
//  OutlineCell.m
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//
#import "Outline.h"
#import "OutlineCell.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
@interface OutlineCell()
@end
@implementation OutlineCell

-(void)updateWithoutlineid:(NSString*)outlineid{
    NSInteger done=0;
    NSInteger total=0;
    NSArray *ar=[[SQLManager sharedSingle] getOutLineByParentId:outlineid];
    for (Outline *subOt in ar) {
        done+=[[SQLManager sharedSingle] countDoneByOutlineid:subOt.outlineid];
        total+=[[SQLManager sharedSingle] countDownByOutlineid:subOt.outlineid];
    }
    [self.delegate countDownDelegate:self result:[NSString stringWithFormat:@"%zd/%zd",done,total]];
}


- (void)awakeFromNib {
// Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
