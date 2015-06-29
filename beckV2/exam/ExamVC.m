//
//  ExamVC.m
//  beckV2
//
//  Created by yj on 15/6/8.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamVC.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
#import "ChoiceCell.h"
#import "CompatyCell.h"
#import "QCollectionVC.h"
#import "FinishExamVC.h"
#import "PractisAnswer.h"
#import "SettingPanVC.h"
@interface ExamVC ()<QCollectionVCDelegate>
@property(nonatomic,weak)IBOutlet UILabel *timeLab;
@property(nonatomic,weak) IBOutlet UILabel *testLab;
@property(nonatomic,assign)NSInteger currentQIndex;
@property(nonatomic,weak) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *choiceArray;//选择题选项数组
@property(nonatomic,strong)NSArray *compatibilyArray;//配伍题 子题目数组

@property(nonatomic,weak)IBOutlet UITabBar* tabbar;

@property(nonatomic,strong)NSMutableArray *answerArray;
@property(nonatomic,strong)PractisAnswer* answer;
@property(nonatomic,assign)BOOL showUndone;
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,assign)NSInteger seconds;

@property (nonatomic, strong) SettingPanVC *settingPanVC;

@property(nonatomic,strong)NSDate *beginTime;
@property(nonatomic,strong)NSString *questionDes;

@end

@implementation ExamVC
- (void)didSelectedItemIndexInAnswerCVC:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.currentQIndex=index;
    [self freshView];
}

-(void)updateTime{
    self.seconds--;
    NSInteger h=(NSInteger)self.seconds/60;
    NSInteger s=self.seconds%60;
    self.timeLab.text=[NSString stringWithFormat:@"%zd:%zd",h,s];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.answerArray=[[NSMutableArray alloc] init];

    if (!self.fromDB) {
        self.beginTime=[NSDate date];
        self.seconds=self.examComp.answer_time.integerValue*60;
        NSInteger h=(NSInteger)self.seconds/60;
        NSInteger s=self.seconds%60;
        self.timeLab.text=[NSString stringWithFormat:@"%zd:%zd",h,s];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }else{
        UserExam *ue=[[[SQLManager sharedSingle] getUserExamByPaperId:self.paperid] lastObject];
        NSArray *d=[NSJSONSerialization JSONObjectWithData:[ue.user_answer dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        self.answerArray=[NSMutableArray arrayWithArray:d];
    }

    self.currentQIndex=0;
    [self freshView];
}

-(void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)freshView{
    self.title=[NSString stringWithFormat:@"%zd/%zd",self.currentQIndex+1,self.questionsAr.count];
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    
    BOOL containAnswer=NO;
    for (PractisAnswer* an in self.answerArray) {
        NSString *titid=nil;
        if ([p isKindOfClass:[ChoiceQuestion class]]) {
            titid=[(ChoiceQuestion*)p choice_id];
        }else{
            titid=[(CompatyInfo*)p info_id];
        }
        if (an.titleId.integerValue==titid.integerValue&&an.titleTypeId.integerValue==p.custom_id.integerValue) {
            self.answer=an;
            containAnswer=YES;
            break;
        }
    }
    
    if (containAnswer) {
    }else{
        self.answer=nil;
        self.answer=[PractisAnswer new];
        self.answer.priority=[NSString stringWithFormat:@"%zd", self.currentQIndex+1];
        self.answer.titleTypeId=p.custom_id;
        if ([p isKindOfClass:[ChoiceQuestion class]]) {
            self.answer.titleId=[(ChoiceQuestion*)p choice_id];
        }else{
            self.answer.titleId=[(CompatyInfo*)p info_id];
        }
        [self addAnswer:self.answer];
    }
    
    
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        self.table.allowsSelection=YES;
        ChoiceQuestion* q=(ChoiceQuestion*)p;
        self.questionDes= q.choice_content;
        if (q.custom_id.intValue==12) {
            self.table.allowsMultipleSelection=YES;
        }else{
            self.table.allowsMultipleSelection=NO;
        }
        q.choiceItems=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];
        self.choiceArray=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];
        
    }else{
        self.table.allowsSelection=NO;
        CompatyInfo *comp=(CompatyInfo*)p;
        
        self.compatibilyArray=[[SQLManager sharedSingle] getCompatyQuestionsByinfoId:comp.info_id];
        //子题目
        for (int i=0; i<self.compatibilyArray.count; i++) {
            CompatyQuestion* q=self.compatibilyArray[i];
            //选项
            if (comp.custom_id.intValue==11) {
                NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id memo:@(i+1).stringValue];
                q.items=comItem;
            }else{
                NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id];
                q.items=comItem;
            }
        }
        CompatyQuestion* q=self.compatibilyArray[0];
        NSMutableString *str=comp.title.mutableCopy;
        if (comp.custom_id.integerValue==11) {
            str=@"".mutableCopy;
        }
        if (comp.custom_id.intValue!=11) {
            for (int i=0; i<q.items.count; i++) {
                CompatyItem* it=q.items[i];
                [str appendFormat:@"\n%@ %@",it.item_number,it.item_content];
            }
            
        }
        self.questionDes=str;
    }
    self.testLab.text=[[SQLManager sharedSingle] getQuestionTypeWithCustomId:p.custom_id];
    self.testLab.textAlignment=NSTextAlignmentCenter;

    [self.table reloadData];
    
    UITabBarItem*item5= [self.tabbar.items lastObject];
    UITabBarItem*item1= [self.tabbar.items firstObject];
    
    UITabBarItem*item3= [self.tabbar.items objectAtIndex:2];
    UITabBarItem*item4= [self.tabbar.items objectAtIndex:3];
    
    
    [item4 setImage:[[UIImage imageNamed:@"submit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"submit_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
    
    [item3 setImage:[[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    
    if (self.currentQIndex==self.questionsAr.count-1) {
        [item1 setImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [item5 setImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setSelectedImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        
    }else if (self.currentQIndex==0) {
        [item1 setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        [item5 setImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setSelectedImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
    }else{
        [item5 setImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setSelectedImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [item1 setImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
    }
}

#warning answer todo

-(void)addAnswer:(PractisAnswer*)pAnswer{
    PractisAnswer *dest=nil;
    for (PractisAnswer*a in self.answerArray) {
        if (a.titleId.integerValue==pAnswer.titleId.integerValue&&a.titleTypeId.integerValue==pAnswer.titleTypeId.integerValue) {
            dest=a;
            break;
        }
    }
    
    if (dest!=nil) {
        [self.answerArray removeObject:dest];
    }
    [self.answerArray addObject:pAnswer];
    
}

//-(NSDictionary *)formatSubmitArg{
//    
//    NSMutableDictionary *json = @{}.mutableCopy;
//    json[@"loginName"] = [Global sharedSingle].loginName;
//    json[@"paperId"] = self.examComp.paper_id;
//    json[@"beginTime"] = [NSString stringWithFormat:@"%@",self.beginTime];
//    json[@"endTime"]=[NSString stringWithFormat:@"%@",[NSDate date]];
//    return [self addAccurateRateList:json];
//}

-(NSDictionary*)addAccurateRateList:(NSMutableDictionary *)olderDic{
    
    NSInteger count=0;
    NSInteger wrongCount=0;
    NSInteger score=0;
    NSMutableArray *ar=[NSMutableArray array];
    for (PractisAnswer*an in self.answerArray) {
        if ([an.isRight isEqualToString:@"true"]) {
            count++;
            Question*q=self.questionsAr[an.priority.integerValue];
            score+=q.examScore.integerValue;
        }else{
            wrongCount++;
        }
    [ar addObject:[an toExamJson]];
    }
    olderDic[@"rightAmount"]=@(count);
    olderDic[@"wrongAmount"]=@(wrongCount);
    olderDic[@"Score"]=@(score);
    olderDic[@"userAnswer"]=ar;
    return olderDic;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if (p.custom_id.integerValue==11) {
        return 0;
    }
    CGSize size =[self.questionDes sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 1000)];
    float h=0;
    if (size.height<50) {
        h=50;
    }else {
        h=size.height;
    }
    
    return h+15;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGSize size =[self.questionDes sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 1000)];
    float h=0;
    if (size.height<50) {
        h=50;
    }else {
        h=size.height;
    }
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, h)];

    la.textAlignment=NSTextAlignmentCenter;
    la.numberOfLines=0;
    la.font=[UIFont systemFontOfSize:14];
    la.text=self.questionDes;
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h+15)];
    v.backgroundColor=[UIColor lightGrayColor];
    [v addSubview:la];
    return v;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        return self.choiceArray.count;
    }else{
        return self.compatibilyArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *q=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([[self.questionsAr objectAtIndex:self.currentQIndex] isKindOfClass:[CompatyInfo class]]) {
        if (indexPath.row<self.compatibilyArray.count) {
            if (q.custom_id.intValue==11) {
                CompatyQuestion* comp=[self.compatibilyArray objectAtIndex:indexPath.row];
                return  48+40*comp.items.count;
            }
            return 88;
        }
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        ChoiceCell* cell=(ChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"choicecell" forIndexPath:indexPath];
        cell.mark.image=nil;
        
        [cell updateWithChoice:self.choiceArray[indexPath.row] answer:self.answer showAnswer:NO];
        return cell;
    }else{
            CompatyCell* cell=(CompatyCell* )[tableView dequeueReusableCellWithIdentifier:@"compatycell" forIndexPath:indexPath];
            cell.row=indexPath.row;
            CompatyQuestion *q=self.compatibilyArray[indexPath.row];
            [cell updateCompatyCell:q  customid:p.custom_id answer:self.answer showAnswer:NO selectedBlock:^(BOOL right,CompatyItem *answer) {
                if(q.answer_id==answer.answerid){
                    
                }
            }];
            
            
            return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]&&indexPath.row<self.choiceArray.count) {
        ChoiceQuestion *q=(ChoiceQuestion*)p;
        ChoiceItem *item=q.choiceItems[indexPath.row];
        //        self.answer.priority=@(self.currentQIndex+1).stringValue;
        
        //显示答案
        if (item.is_answer.integerValue==0) {
            self.answer.isRight=@"false";
            p.answerType=answeredwrong;
        }else {
            self.answer.isRight=@"true";
            p.answerType=answeredRight;
            
        }
        p.answerType=answereddone;
        
        if ([p custom_id].intValue!=12) {
            [self.answer.userAnswer removeAllObjects];
            [self.answer.userAnswer addObject:item];
            
        }else{
            ChoiceItem *dest=nil;
            for (ChoiceItem*it in self.answer.userAnswer) {
                if (it.nid.integerValue==item.nid.integerValue) {
                    dest=it;
                }
            }
            if (dest) {
                [self.answer.userAnswer removeObject:dest];
            }else {
                [self.answer.userAnswer addObject:item];
            }
        }
    }
    [tableView reloadData];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            [self backwardPress:item];
            break;
        case 1:
            [self showAnswer:item];
            break;
        case 2:
            [self showSetting:item];
            break;
        case 3:
            [self submit:item];
            break;
        case 4:
            [self forwardPress:item];
            break;
        default:
            break;
    }
}

-(IBAction)notePress{

}

-(void)showAnswer:(UITabBarItem *)item{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
    QCollectionVC*vc=[sb instantiateViewControllerWithIdentifier:@"QCollectionVC"];
    vc.vcDelegate=self;
    vc.questions=self.questionsAr;
    vc.fromExam=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)submit:(UITabBarItem *)item{
    
    
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"token"] = @"add";
    
    NSMutableDictionary *dic=@{}.mutableCopy;
    dic[@"loginName"] = [Global sharedSingle].loginName;
    dic[@"paperId"] = self.examComp.paper_id;
    dic[@"beginTime"] = [NSString stringWithFormat:@"%@",self.beginTime];
    NSDate *finishDate=[NSDate date];
    dic[@"endTime"]=[NSString stringWithFormat:@"%@",[NSDate date]];
    NSInteger count=0;
    NSInteger wrongCount=0;
    NSInteger score=0;
    NSMutableArray *ar=[NSMutableArray array];
    for (PractisAnswer*an in self.answerArray) {
        if ([an.isRight isEqualToString:@"true"]) {
            count++;
            Question*q=self.questionsAr[an.priority.integerValue];
            score+=q.examScore.integerValue;
        }else{
            wrongCount++;
        }
        [ar addObject:[an toExamJson]];
    }
    dic[@"rightAmount"]=[NSString stringWithFormat:@"%zd",count];
    dic[@"wrongAmount"]=[NSString stringWithFormat:@"%zd",wrongCount];
    dic[@"score"]=[NSString stringWithFormat:@"%zd",score];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ar options:kNilOptions error:&error];
    NSString *answerString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dic[@"userAnswer"]=answerString;

    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];

    params[@"json"] = jsonString;
    
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/userExamAct.htm" params:params CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.integerValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                if (aResponseObject[@"examSql"]) {
                    [[SQLManager sharedSingle] excuseSql:aResponseObject[@"examSql"]];
                }
                if (aResponseObject[@"sql"]) {
                    [[SQLManager sharedSingle] excuseSql:aResponseObject[@"sql"]];
                }

                [[OTSAlertView alertWithMessage:@"提交成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"pan" bundle:[NSBundle mainBundle]];
                    FinishExamVC*vc=[sb instantiateViewControllerWithIdentifier:@"FinishExamVC"];
                    vc.paper=self.examComp;
                    vc.examTitle=self.examComp.paper_name;
                    vc.wrong=[NSString stringWithFormat:@"%zd",wrongCount];
                    vc.right=[NSString stringWithFormat:@"%zd",score];
                    vc.time=self.examComp.answer_time;
                    vc.cost=[NSString stringWithFormat:@"%zd",(int)[finishDate timeIntervalSinceDate:self.beginTime]/60000];
                    vc.point=[NSString stringWithFormat:@"%@",aResponseObject[@"num"]];
                    vc.paperid=self.paperid;
                    [self presentViewController:vc animated:YES completion:nil];
//                    [self.navigationController popViewControllerAnimated:YES];
                }] show];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"提交失败" andCompleteBlock:nil] show];
        }
        [self hideLoading];
    }];
    
}

-(void)showSetting:(UITabBarItem *)item{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"pan" bundle:[NSBundle mainBundle]];
    self.settingPanVC = [sb instantiateViewControllerWithIdentifier:@"settingPanVC"];
    [self.view addSubview:self.settingPanVC.view];

}

-(void)backwardPress:(UITabBarItem *)item{
    if (self.currentQIndex==0) {
        
        return;
    }
    
    
    if (self.currentQIndex>0) {
        self.currentQIndex--;
    }
    
    [self freshView];
}

-(void)forwardPress:(UITabBarItem *)item{
    if (self.currentQIndex==self.questionsAr.count-1) {
        return;
    }
    
    if (self.currentQIndex<self.questionsAr.count) {
        self.currentQIndex++;
    }
    [self freshView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
