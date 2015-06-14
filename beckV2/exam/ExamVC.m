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

#import "PractisAnswer.h"

@interface ExamVC ()
@property(nonatomic,weak)IBOutlet UILabel *timeLab;
@property(nonatomic,weak) IBOutlet UILabel *testLab;
@property(nonatomic,assign)NSInteger currentQIndex;
@property(nonatomic,weak) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *choiceArray;//选择题选项数组
@property(nonatomic,strong)NSArray *compatibilyArray;//配伍题 子题目数组

@property(nonatomic,weak)IBOutlet UITabBar* tabbar;

@property(nonatomic,strong)NSMutableArray *answerArray;
@property(nonatomic,strong)ExamAnswer* answer;
@property(nonatomic,assign)BOOL showUndone;
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,assign)NSInteger seconds;


@property(nonatomic,strong)NSDate *beginTime;
@end

@implementation ExamVC
- (void)didSelectedItemIndexInAnswerCVC:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.currentQIndex=index;
    [self freshView];
}

-(void)updateTime{
    self.seconds--;
    self.timeLab.text=[NSString stringWithFormat:@"%zd",self.seconds];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.beginTime=[NSDate date];
    self.seconds=self.examComp.answer_time.integerValue*60;
    self.timeLab.text=[NSString stringWithFormat:@"%zd",self.seconds];

    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    self.answerArray=[[NSMutableArray alloc] init];

    self.currentQIndex=0;
    [self freshView];
}

-(void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)freshView{
    self.title=[NSString stringWithFormat:@"%zd/%zd",self.currentQIndex+1,self.questionsAr.count];
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    
    if (self.answer!=nil) {
        [self addAnswer:self.answer];
    }
    self.answer=nil;
    self.answer=[ExamAnswer new];
    
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        self.table.allowsSelection=YES;
        ChoiceQuestion* q=(ChoiceQuestion*)p;
        self.testLab.text= q.choice_content;
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
        if (comp.custom_id.intValue!=11) {
            for (int i=0; i<q.items.count; i++) {
                CompatyItem* it=q.items[i];
                [str appendFormat:@"\n%@ %@",it.item_number,it.item_content];
            }
            
        }
        self.testLab.text=str;
        self.testLab.textAlignment=NSTextAlignmentLeft;
        
    }
    
    [self.table reloadData];
    
    UITabBarItem*item5= [self.tabbar.items lastObject];
    UITabBarItem*item1= [self.tabbar.items firstObject];
    
    UITabBarItem*item3= [self.tabbar.items objectAtIndex:2];
    UITabBarItem*item4= [self.tabbar.items objectAtIndex:3];
    
    
    [item4 setImage:[[UIImage imageNamed:@"favorate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"favorate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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

//多选
-(void)addMultiAnswer:(NSString *)item_mun{
    NSString *dest=nil;
    for (NSString *num in self.answer.multiAnswer) {
        if ([num isEqualToString:item_mun]) {
            dest=num;
            break;
        }
    }
    if (dest!=nil) {
        [self.answer.multiAnswer removeObject:dest];
    }
    [self.answer.multiAnswer addObject:item_mun];
    ChoiceQuestion * c=[self.questionsAr objectAtIndex:self.currentQIndex];
    //只要有一个候选答案不对，题目就错了
    for (NSString *str in self.answer.multiAnswer) {
        if (![c.answer containsString:str]) {
            self.answer.isRight=@"false";
            break;
        }
    }
}
#warning answer todo

-(void)addAnswer:(ExamAnswer*)pAnswer{
    ExamAnswer *dest=nil;
    for (ExamAnswer*a in self.answerArray) {
        if (a.titleId.integerValue==pAnswer.titleId.integerValue&&a.titleTypeId.integerValue==pAnswer.titleTypeId.integerValue) {
            dest=a;
            break;
        }
    }
    Question*q=[self.questionsAr objectAtIndex:self.currentQIndex];
    if (dest!=nil&&q.custom_id.integerValue!=12) {
        [self.answerArray removeObject:dest];
    }
    [self.answerArray addObject:pAnswer];
    
}

-(NSDictionary *)formatSubmitArg{
    
    NSMutableDictionary *json = @{}.mutableCopy;
    json[@"loginName"] = [Global sharedSingle].loginName;
    json[@"paperId"] = self.examComp.paper_id;
    json[@"beginTime"] = self.beginTime;
    json[@"endTime"]=[NSDate date];
    return [self addAccurateRateList:json];
}

-(NSDictionary*)addAccurateRateList:(NSMutableDictionary *)olderDic{
    
    NSInteger count=0;
    NSInteger wrongCount=0;
    NSMutableArray *ar=[NSMutableArray array];
    for (ExamAnswer*an in self.answerArray) {
        if ([an.isRight isEqualToString:@"true"]) {
            count++;
        }else{
            wrongCount++;
        }
    }
    olderDic[@"rightAmount"]=@(count);
    olderDic[@"wrongAmount"]=@(wrongCount);
//    float rate=(float)count/self.answerArray.count;
//    olderDic[@"accurateRate"]=[NSString stringWithFormat:@"%.2f",rate];
//    olderDic[@"list"]=ar;
#warning answer todo
//    olderDic[@"Score"]=;
//    olderDic[@"userAnswer"]=;
    return olderDic;
    
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
        ChoiceQuestion* c=(ChoiceQuestion*)p;
            ChoiceCell* cell=(ChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"choicecell" forIndexPath:indexPath];
            cell.mark.image=nil;
            cell.contentView.layer.borderColor=[UIColor clearColor].CGColor;
            
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
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]&&indexPath.row<self.choiceArray.count) {
        ChoiceQuestion *q=(ChoiceQuestion*)p;
        ChoiceItem *item=q.choiceItems[indexPath.row];
        self.answer.priority=@(self.currentQIndex+1).stringValue;
        
        //显示答案
        if (item.is_answer.integerValue==0) {
            self.answer.isRight=@"false";
        }else {
            self.answer.isRight=@"true";
        }
        self.answer.titleId=q.choice_id;
        self.answer.titleTypeId=q.custom_id;
        
        if ([p custom_id].intValue!=12) {
            self.answer.userAnswer=item.item_number;
            
        }else{
            [self addMultiAnswer:item.item_number];
        }
    }
    
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
            [self addFaver:item];
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
}

-(void)addFaver:(UITabBarItem *)item{
    
    
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"token"] = @"add";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self formatSubmitArg] options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    params[@"json"] = jsonString;
    
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/userExamAct.htm" params:params CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.integerValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                if (aResponseObject[@"sql"]) {
                    [[SQLManager sharedSingle] excuseSql:aResponseObject[@"sql"]];
                }
                NSArray *sqlAr=aResponseObject[@"list"];
                if (sqlAr.count>0) {
                    for (int i=0; i<sqlAr.count; i++) {
                        [[SQLManager sharedSingle] excuseSql:sqlAr[i]];
                    }
                }
                [[OTSAlertView alertWithMessage:@"提交成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                }] show];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"提交失败" andCompleteBlock:nil] show];
        }
    }];
    
}

-(void)showSetting:(UITabBarItem *)item{
    
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toprogress"]) {
        QCollectionVC *vc=segue.destinationViewController;
        vc.vcDelegate=self;
        vc.questions=self.questionsAr;
    }
}
@end
