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
@interface PractisDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UILabel *lab1,*lab2,*lab3,*lab4,*lab5,*lab6,*lab7;
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *ar;
@end

@implementation PractisDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"练习详情";
    self.ar=@[@"测试时间",@"答对题数",@"答错提数",@"详情"];
    self.lab1.text=[NSString stringWithFormat:@"您总共进行了%zd次模拟练习",self.practisAr.count];
    NSInteger totalr=0;
    NSInteger totalwrong=0;
    NSInteger totaldone=0;
    for (UserPractis*p in self.practisAr) {
        NSInteger r=(NSInteger)p.amount.integerValue*p.accurate_rate.floatValue;
        NSInteger wrong=p.amount.integerValue-r;
        totalr+=r;
        totalwrong+=wrong;
        totaldone+=p.amount.integerValue;
    }
    NSArray*tempTotal=[[SQLManager sharedSingle] getOutLineByParentId:self.outlineid];
    NSMutableArray *totalAr=[NSMutableArray array];
    for (Outline *o in tempTotal) {
        [totalAr addObjectsFromArray:[[SQLManager sharedSingle] getQuestionByOutlineId:o.outlineid] ];
    }
    
    self.table.tableFooterView=[[UIView alloc] init];
    self.lab2.text=[NSString stringWithFormat:@"%zd",totalAr.count];
    self.lab3.text=[NSString stringWithFormat:@"%.2f",(float)totalr/totalAr.count];
    self.lab4.text=[NSString stringWithFormat:@"%zd*100％",totaldone];
    self.lab5.text=[NSString stringWithFormat:@"%zd",totalr];
    self.lab6.text=[NSString stringWithFormat:@"%zd",totalwrong];
    self.lab7.text=[NSString stringWithFormat:@"%.2f*100％",(float)totaldone/totalAr.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.practisAr.count;
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
    UserPractis *p=self.practisAr[indexPath.row];
    NSInteger r=(NSInteger)p.amount.integerValue*p.accurate_rate.floatValue;
    NSInteger wrong=p.amount.integerValue-r;
    for (int i=0; i<4; i++) {
        UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(i*w/4, 0, w/4, 30)];
        la.textColor=[UIColor blackColor];
        la.textAlignment=NSTextAlignmentCenter;
        switch (i) {
            case 0:
                la.text=[self transferTime:p.end_time];
                break;
            case 1:
                la.text=[NSString stringWithFormat:@"%zd",r];
                break;
            case 2:
                la.text=[NSString stringWithFormat:@"%zd",wrong];
                la.textColor=[UIColor greenColor];
                break;
            case 3:
                la.text=@"详情";
                la.textColor=[UIColor redColor];
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
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
    PractiseVC *vc=[sb instantiateViewControllerWithIdentifier:@"practise"];
    UserPractis *p=self.practisAr[indexPath.row];

    vc.outletid=p.outlineId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
