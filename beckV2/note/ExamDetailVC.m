//
//  ExamDetailVC.m
//  beckV2
//
//  Created by yj on 15/6/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamDetailVC.h"
#import "ExamPaper.h"
#import "QuestionVC.h"
@interface ExamDetailVC ()
@property(nonatomic,weak)IBOutlet UILabel *datelab,*rightLab,*wrongLab,*rateLab;
@property(nonatomic,weak)IBOutlet UIButton *scoreBtn,*toExamBtn;
@end

@implementation ExamDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"考试详情";

    
//    for (UserExam *ue in self.examAr) {
        UserExam *ue=[self.examAr lastObject];
    self.datelab.text=ue.end_time;
//    NSArray*totalQuestions=[[SQLManager sharedSingle] getExamPaperContentByPaperid:ue.paper_id];
    //所有题目
    self.rightLab.text=ue.right_amount;
    self.wrongLab.text=ue.wrong_amount;
    [self.scoreBtn setTitle:[NSString stringWithFormat:@"成绩%d分",ue.score.intValue] forState:UIControlStateNormal];
    
//    }
    NSInteger totalr=ue.right_amount.integerValue;
    NSInteger totalwrong=ue.wrong_amount.integerValue;
    NSInteger totaldone=totalr+totalwrong;
    
    self.rateLab.text=[NSString stringWithFormat:@"正确率%.0f％",(float)100*totalr/totaldone];
    
    [self.toExamBtn addTarget:self action:@selector(seeExam) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)seeExam{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"question" bundle:[NSBundle mainBundle]];
   QuestionVC*vc =[sb instantiateViewControllerWithIdentifier:@"QuestionVC"];
    vc.showTimer=NO;
    vc.fromDetail=YES;
    UserExam *ue=[self.examAr lastObject];
    vc.paperid=ue.paper_id;
    vc.showAnswer=YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
