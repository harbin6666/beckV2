//
//  ExamDetailCell.m
//  beckV2
//
//  Created by yj on 15/7/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamDetailCell.h"
@interface ExamDetailCell()
@property(nonatomic,weak)IBOutlet UILabel *datelab,*rightLab,*wrongLab,*rateLab;
@property(nonatomic,weak)IBOutlet UIButton *scoreBtn,*toExamBtn;
@property(nonatomic,copy)selectBlock block;
@end
@implementation ExamDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateWithExamAr:(UserExam *)ue  block:(selectBlock) block{
    self.block=block;
    self.datelab.text=ue.end_time;
    ExamPaper*paper=[[SQLManager sharedSingle] getExamPaperByPaperid:ue.paper_id];
    //所有题目
    self.rightLab.text=ue.right_amount;
    self.wrongLab.text=[NSString stringWithFormat:@"%zd",paper.total_amount.integerValue-ue.right_amount.integerValue];
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"成绩%d分",ue.score.intValue] forState:UIControlStateNormal];
    
    //    }
    NSInteger totalr=ue.right_amount.integerValue;
    
    NSInteger total=paper.total_amount.integerValue;
    
    self.rateLab.text=[NSString stringWithFormat:@"正确率  %.0f％",(float)100*totalr/total];
    
    [self.toExamBtn addTarget:self action:@selector(seeExam) forControlEvents:UIControlEventTouchUpInside];

}

-(IBAction)seeExam{
    self.block();
}

@end
