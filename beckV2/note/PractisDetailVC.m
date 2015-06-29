//
//  PractisDetailVC.m
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PractisDetailVC.h"
#import "UserPractis.h"
#import "PractiseVC.h"
#import "Outline.h"
#import "ExamPaper.h"
#import "QuestionVC.h"
#import "CompatyQuestion.h"
@interface PractisDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UILabel *lab1,*lab2,*lab3,*lab4,*lab5,*lab6,*lab7;
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *ar;
@end

@implementation PractisDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger totalr=0;
    NSInteger totalwrong=0;
    NSInteger totaldone=0;
    NSInteger sqlCount=0;
    NSMutableArray *totalAr=[NSMutableArray array];
    self.ar=@[@"测试时间",@"答对题数",@"答错提数",@"详情"];
    if (self.type==0) {
        self.title=@"练习详情";
        self.lab1.text=[NSString stringWithFormat:@"您总共进行了%zd次模拟练习",self.practisAr.count];
        for (UserPractis*p in self.practisAr) {
            NSInteger r=(NSInteger)p.amount.integerValue*p.accurate_rate.floatValue;
            NSInteger wrong=p.amount.integerValue-r;
            totalr+=r;
            totalwrong+=wrong;
            totaldone+=p.amount.integerValue;
        }
        NSArray*tempTotal=[[SQLManager sharedSingle] getOutLineByParentId:self.outlineid];
        for (Outline *o in tempTotal) {
            [totalAr addObjectsFromArray:[[SQLManager sharedSingle] getQuestionByOutlineId:o.outlineid] ];
        }
        
        for (Question *q in totalAr) {
            if (q.custom_id.integerValue==10||q.custom_id.integerValue==11) {
                CompatyInfo *com=(CompatyInfo*)q;
                NSArray *miniQuestion=[[SQLManager sharedSingle] getCompatyQuestionsByinfoId:com.info_id];
                sqlCount+=miniQuestion.count;
            }else{
                sqlCount++;
            }
        }

    }else{
        self.title=@"考试详情";
        self.lab1.text=[NSString stringWithFormat:@"您总共进行了%zd次考试",self.examAr.count];
        for (UserExam *ue in self.examAr) {
            NSArray *temp=[[SQLManager sharedSingle] getExamPaperContentByPaperid:ue.paper_id];
            [totalAr addObjectsFromArray:temp];//所有题目
            totalr+=ue.right_amount.integerValue;
            totalwrong+=ue.wrong_amount.integerValue;
        }
        totaldone=totalr+totalwrong;
    }
    
    self.table.tableFooterView=[[UIView alloc] init];
    self.lab2.text=[NSString stringWithFormat:@"%zd",sqlCount];
    self.lab3.text=[NSString stringWithFormat:@"%d％",(int)(100*totalr/totalAr.count)];
    self.lab4.text=[NSString stringWithFormat:@"%zd",totalAr.count];
    self.lab5.text=[NSString stringWithFormat:@"%zd",totalr];
    self.lab6.text=[NSString stringWithFormat:@"%zd",totalwrong];
    self.lab7.text=[NSString stringWithFormat:@"%d％",(int)(totaldone/totalAr.count)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type==0) {
        return self.practisAr.count;
    }else{
        return self.examAr.count;

    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    float w=self.view.frame.size.width;
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 30)];
    
    for (int i=0; i<4; i++) {
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(i*w/4, 0, w/4, 30)];
        la.textAlignment=NSTextAlignmentCenter;
        la.text=self.ar[i];
        la.font=[UIFont systemFontOfSize:14];
        [v addSubview:la];
    }
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSString*)transferTime:(NSString*)time{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*d=[dateFormatter dateFromString: time];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter1 stringFromDate:d];
    return strDate;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    float w=self.view.frame.size.width;
    NSInteger r=0;
    NSInteger wrong=0;
    NSString *end=@"";
    if (self.type==1) {
        UserExam *p=self.examAr[indexPath.row];
        r=p.right_amount.integerValue;
        wrong=p.wrong_amount.integerValue;
        end=p.end_time;
    }else{
        UserPractis *p=self.practisAr[indexPath.row];
        r=(NSInteger)p.amount.integerValue*p.accurate_rate.floatValue;
        wrong=p.amount.integerValue-r;
        end=p.end_time;
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i=0; i<4; i++) {
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(i*w/4, 0, w/4, 30)];
        la.textColor=[UIColor blackColor];
        la.textAlignment=NSTextAlignmentCenter;
        switch (i) {
            case 0:
                la.text=[self transferTime:end];
                break;
            case 1:
                la.text=[NSString stringWithFormat:@"%zd",r];
                break;
            case 2:
                la.text=[NSString stringWithFormat:@"%zd",wrong];
                la.textColor=[UIColor greenColor];
                break;
            case 3:
                la.text=@"查看";
                la.textColor=BeckRed;
                break;
            default:
                break;
        }
        la.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:la];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==0) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"question" bundle:[NSBundle mainBundle]];
        QuestionVC *vc=[sb instantiateViewControllerWithIdentifier:@"QuestionVC"];
        UserPractis *p=self.practisAr[indexPath.row];
        vc.fromDetail=YES;
        vc.showAnswer=NO;
        vc.outletid=p.outlineId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        QuestionVC* vc=[[UIStoryboard storyboardWithName:@"question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"QuestionVC"];
        
        UserExam *p=self.examAr[indexPath.row];
//        NSMutableArray *ar=[NSMutableArray array];
//        NSArray *temp=[[SQLManager sharedSingle] getExamPaperContentByPaperid:p.paper_id];
//        for (int i=0; i<temp.count; i++) {
//            ExamPaper_Content *cont=temp[i];
//            Question *q=[[SQLManager sharedSingle] getExamQuestionByItemId:cont.item_id customid:cont.custom_id];
//            [ar addObject:q];
//        }
        vc.paperid=p.paper_id;
        vc.showTimer=NO;
        vc.showAnswer=YES;
        vc.examComp=self.examPapers[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}
@end
