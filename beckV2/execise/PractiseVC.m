//
//  PractiseVC.m
//  beckV2
//
//  Created by yj on 15/6/1.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PractiseVC.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
@interface PractiseVC ()
@property(nonatomic,strong)NSArray *questionsAr;
@property(nonatomic,weak) IBOutlet UILabel *testLab;

@end

@implementation PractiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarButtonName:@"提交" width:40 isLeft:NO];
    [self setNavigationBarButtonName:@"首页" width:40 isLeft:YES];

    self.questionsAr=[[SQLManager sharedSingle] getQuestionByOutlineId:self.outletid];
    self.title=[NSString stringWithFormat:@"1/%zd",self.questionsAr.count];
    
    ChoiceQuestion* q=[self.questionsAr firstObject];
    
    self.testLab.text= q.choice_content;
    
    NSArray * choices=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];

    
    CompatyInfo *comp=[self.questionsAr lastObject];
    self.testLab.text=comp.title;
    
    NSArray *comQuestions=[[SQLManager sharedSingle] getCompatyQuestionsByinfoId:comp.info_id];
    //子题目
    for (int i=0; i<comQuestions.count; i++) {
        CompatyQuestion* q=comQuestions[i];
        //选项
        NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id];
        
        
    }
    
//    if ([q isKindOfClass:[ChoiceQuestion class]]) {
//        
//    }else{
//        
//    }
    // Do any additional setup after loading the view.
}


-(void)rightBtnClick:(UIButton *)sender{
    
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
