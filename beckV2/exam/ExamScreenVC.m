//
//  ExamScreenVC.m
//  beckV2
//
//  Created by yj on 15/6/8.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamScreenVC.h"
#import "ExamPaper.h"
#import "Question.h"
#import "ExamVC.h"
#import "PointShopVC.h"
#import "QuestionVC.h"
@interface ExamScreenVC ()
@property(nonatomic,strong)NSMutableArray *qAr;
@property(nonatomic,strong)ExamPaper*currentPaper;
@end

@implementation ExamScreenVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.papers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ExamPaper*p=[self.papers objectAtIndex:indexPath.row];

   /* if (p.type.integerValue==2) {
        NSString *status=[[SQLManager sharedSingle] getExchangePaperStatus:p.paper_id];
        if (status.integerValue==0) {
            cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointbuy"]];
        }else{
            cell.accessoryView=nil;
        }
    }*/
    cell.textLabel.text=p.paper_name;
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   self.currentPaper=self.papers[indexPath.row];
    
  /*
    NSString *status=[[SQLManager sharedSingle] getExchangePaperStatus:self.currentPaper.paper_id];

    if (self.currentPaper.type.integerValue==2&&status.integerValue==0) {
        if (self.currentPaper.points.integerValue>[[Global sharedSingle].userBean[@"currentPoints"] integerValue]) {
            NSString *mess=[NSString stringWithFormat:@"购买试卷需要%@积分，您当前积分%@,不足购买此试卷是否前往购买",self.currentPaper.points,[Global sharedSingle].userBean[@"currentPoints"]];
            [[OTSAlertView alertWithTitle:@"提示" message:mess leftBtn:@"取消" rightBtn:@"购买" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
                    PointShopVC*vc =[sb instantiateViewControllerWithIdentifier:@"PointShopVC"];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }] show];
            return;
        }
        NSString *point=self.currentPaper.points;
        [[OTSAlertView alertWithTitle:@"解锁提示" message:[NSString stringWithFormat:@"%@积分解锁该题目",point] leftBtn:@"取消" rightBtn:@"解锁" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                NSDictionary *param=@{@"token":@"add",@"loginName":[Global sharedSingle].loginName,@"examPaperId":self.currentPaper.paper_id};
                [self showLoading];
                WEAK_SELF;
                [self getValueWithBeckUrl:@"/front/exchangePaperAct.htm" params:param CompleteBlock:^(id aResponseObject, NSError *anError) {
                    STRONG_SELF;
                    [self hideLoading];
                    if (anError==nil) {
                        if ([aResponseObject[@"errorcode"] integerValue]==0) {
                            
                            NSNumber *nowpoint=@([[Global sharedSingle].userBean[@"currentPoints"] integerValue]-point.integerValue);
                            NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[Global sharedSingle].userBean];
                            [dic setObject:nowpoint.stringValue forKey:@"currentPoints"];
                            [Global sharedSingle].userBean=dic;
                            NSArray *list=aResponseObject[@"sqlList"];
                            for (int i=0; i<list.count; i++) {
                                [[SQLManager sharedSingle] excuseSql:list[i]];
                            }
                            [[OTSAlertView alertWithMessage:@"购买成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex){
                                [self.tableView reloadData];
                            }] show];

                        }else{
                            [[OTSAlertView alertWithMessage:@"购买失败" andCompleteBlock:nil] show];
                        }
                    }else{
                        [[OTSAlertView alertWithMessage:@"购买失败" andCompleteBlock:nil] show];
                    }
                }];
            }else{
                
            }
        }] show];
    }else{
        */
        [self goExamVC];
//    }

}

-(void)goExamVC{

    QuestionVC* vc=[[UIStoryboard storyboardWithName:@"question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QuestionVC"];
    vc.paperid=self.currentPaper.paper_id;
    vc.examComp=self.currentPaper;
    vc.showTimer=YES;
    [self.navigationController pushViewController:vc animated:YES];

    
    //    NSArray *examcompose=[[SQLManager sharedSingle] getExamPaperCompositonByPaperId:self.currentPaper.paper_id];
//    NSMutableArray *quest=[[NSMutableArray alloc] init];
//    for (int i=0; i<examcompose.count; i++) {
//        ExamPaperComposition*comp=examcompose[i];
//        NSArray* questions=[[SQLManager sharedSingle] getExamPaperContentByPaperid:comp.paper_id compid:comp.comp_id];
//        [quest addObjectsFromArray:questions];
//    }
//    
//    self.qAr=[[NSMutableArray alloc] init];
//    for (int i=0; i<quest.count; i++) {
//        ExamPaper_Content *con=quest[i];
//        Question* q=[[SQLManager sharedSingle] getExamQuestionByItemId:con.item_id customid:con.custom_id];
//        q.examScore=con.score;
//        [self.qAr addObject:q];
//    }
//    ExamVC* vc=[[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"exam"];
//    vc.questionsAr=self.qAr;
//    vc.examComp=self.currentPaper;
//    [self.navigationController pushViewController:vc animated:YES];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toexamvc"]) {
        
        NSArray *examcompose=[[SQLManager sharedSingle] getExamPaperCompositonByPaperId:self.currentPaper.paper_id];
        NSMutableArray *quest=[[NSMutableArray alloc] init];
        for (int i=0; i<examcompose.count; i++) {
            ExamPaperComposition*comp=examcompose[i];
            NSArray* questions=[[SQLManager sharedSingle] getExamPaperContentByPaperid:comp.paper_id compid:comp.comp_id];
            [quest addObjectsFromArray:questions];
        }
        
        self.qAr=[[NSMutableArray alloc] init];
        for (int i=0; i<quest.count; i++) {
            ExamPaper_Content *con=quest[i];
            Question* q=[[SQLManager sharedSingle] getExamQuestionByItemId:con.item_id customid:con.custom_id];
            [self.qAr addObject:q];
        }

        
        ExamVC*dest=segue.destinationViewController;
        dest.questionsAr=self.qAr;
        dest.examTime=self.currentPaper.answer_time.integerValue;
    }
}
*/

@end
