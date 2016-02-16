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
#import "AlipayObj.h"
#import "WechatObj.h"
@interface ExamScreenVC ()<UIActionSheetDelegate>
@property(nonatomic,strong)NSMutableArray *qAr;
@property(nonatomic,strong)ExamPaper*currentPaper;
@property(nonatomic,strong)NSArray *netPaper;
@property(nonatomic,strong)NSString *orderSN;
@property(nonatomic,strong)NSDictionary *tarDic;
@end

@implementation ExamScreenVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.exam) {
        [self freshData];
    }
}
-(void)freshData{
    NSString * titleid=[[Global sharedSingle] getUserWithkey:@"titleid"];
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/exchangePaperAct.htm" params:@{@"token":@"list",@"loginName":[Global sharedSingle].loginName,@"titleId":titleid,@"screening":self.screenNo} CompleteBlock:^(id aResponseObject, NSError *anError) {
        [self hideLoading];
        if (anError==nil) {
            self.netPaper=aResponseObject[@"list"];
            [self.tableView reloadData];
        }else{
            
        }
        
    }];

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
    for (NSDictionary *dic in self.netPaper) {
        if (p.paper_id.integerValue==[dic[@"paperId"] integerValue]&&[dic[@"pay"] integerValue]==0) {
            cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointbuy"]];
            break;
        }
    }
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
    NSString *status=@"0";
    for (NSDictionary *dic in self.netPaper) {
        if (self.currentPaper.paper_id.integerValue==[dic[@"paperId"] integerValue]) {
            if ([dic[@"pay"] integerValue]==1) {
                status=@"1";
            }else{
                status=@"0";
            }
            self.tarDic=dic;
            break;
        }
    }

//    NSString *status=[[SQLManager sharedSingle] getExchangePaperStatus:self.currentPaper.paper_id];

    if (self.currentPaper.type.integerValue==2&&status.integerValue==0) {
        NSNumber *point=self.tarDic[@"price"];
        if (point==nil) {
            return;
        }
        [[OTSAlertView alertWithTitle:@"购买提示" message:[NSString stringWithFormat:@"%@元购买该试卷",point] leftBtn:@"取消" rightBtn:@"购买" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==1) {
                NSDictionary *param=@{@"token":@"addpaper",@"loginName":[Global sharedSingle].loginName,@"paperId":self.currentPaper.paper_id};
                [self showLoading];
                WEAK_SELF;
                [self getValueWithBeckUrl:@"/front/orderAct.htm" params:param CompleteBlock:^(id aResponseObject, NSError *anError) {
                    STRONG_SELF;
                    [self hideLoading];
                    if (anError==nil) {
                        if ([aResponseObject[@"errorcode"] integerValue]==0) {
                            self.orderSN=aResponseObject[@"orderSn"];
                            UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"请选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝支付",@"微信支付", nil];
                            [sheet showInView:self.view];

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
        [self goExamVC];
    }

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [self payWithAlipay];
    }else{
        [self payWx];
    }
}
-(void)payWithAlipay{
    [[AlipayObj sharedSingle] sendPayProduct:self.currentPaper.paper_name price:[NSString stringWithFormat:@"%@",self.tarDic[@"price"]] orderNum:self.orderSN Block:^(NSDictionary *aResponseDic) {
        NSNumber *paystatus=aResponseDic[@"resultStatus"];
        if (paystatus.integerValue==9000) {
            [[OTSAlertView alertWithMessage:@"支付成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                [self freshData];
            }] show];
        }else if (paystatus.integerValue==6001){
            
        }else{
            [[OTSAlertView alertWithMessage:@"支付失败" andCompleteBlock:nil] show];
        }
    }];

}
-(void)payWx{
    int p=(int)([self.tarDic[@"price"] floatValue]*100);
    NSString *price=[NSString stringWithFormat:@"%zd",p];
    [[WechatObj sharedSingle] sendPayProduct:self.currentPaper.paper_name price:price orderNum:self.orderSN Block:^(BaseResp* aResponseObject) {
        if ([aResponseObject isKindOfClass:[PayResp class]]) {
            PayResp *re=(PayResp*)aResponseObject;
            if (re.errCode==0) {
                [[OTSAlertView alertWithMessage:@"支付成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                    [self freshData];
                }] show];
            }else{
                [[OTSAlertView alertWithMessage:@"支付失败" andCompleteBlock:nil] show];
            }
        }
    }];

    
//    [self getValueWithBeckUrl:@"/front/orderTrainingAct.htm" params:@{@"token":@"add",@"loginName":[Global sharedSingle].loginName,@"trainingCourseId":courseid,@"userName":self.tf1.text,@"userPhone":self.tf2.text,@"cityId":self.selectCity[@"id"]} CompleteBlock:^(id aResponseObject, NSError *anError) {
//        if (anError==nil&&[aResponseObject[@"errorcode"] integerValue]==0) {
//            NSString *price=[NSString stringWithFormat:@"%zd",[self.selectDic[@"money"] integerValue]*100];
//        }
//    }];
    
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
