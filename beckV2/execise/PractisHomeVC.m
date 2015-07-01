//
//  PractisHomeVC.m
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PractisHomeVC.h"
#import "Subject.h"
#import "Outline.h"
#import "CourseVC.h"
#import "OutlineCell.h"
#import "CachedAnswer.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
@interface PractisHomeVC ()<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>
@property(nonatomic,strong)NSArray *subjectIdList;
@property(nonatomic,strong)NSArray *subjectList;
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataAr;;
@end

@implementation PractisHomeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
        [self.dataAr addObject:sbAr];
    }
    [self.table reloadData];
}

//-(void)rightBtnClick:(UIButton *)sender{
//    if (sender.selected==NO) {
//        sender.selected=YES;
//        [self showPositionPan];
//    }else{
//        sender.selected=NO;
//        
//    }
//}

-(void)selectedPostion{
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
        [self.dataAr addObject:sbAr];
    }
    
    [self.table reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSMutableString *str=[NSMutableString stringWithString:[[Global sharedSingle] getUserWithkey:@"titleName"]];
//    [str appendString:@" ▼"];
//    [self setNavigationBarButtonName:str width:80 isLeft:NO];


//    self.dataAr=[NSMutableArray array];
//    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
//    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
//
//    for (int i=0; i<self.subjectList.count; i++) {
//        Subject*sb=self.subjectList[i];
//        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
//        [self.dataAr addObject:sbAr];
//    }
//
//    [self.table reloadData];
}

-(IBAction)homeClick:(UIButton *)sender{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp=self.dataAr[section];
    return temp.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.subjectList.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"sectionheader"];
    cell.backgroundColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:@"flag"];
//    NSArray *ar=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    Subject *sb=self.subjectList[section];
    cell.textLabel.text=sb.subjectName;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutlineCell* cell=[tableView dequeueReusableCellWithIdentifier:@"outlinecell" forIndexPath:indexPath];
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    cell.textlab.text=ot.courseName;
//    NSInteger done=[[SQLManager sharedSingle] countDoneByOutlineid:ot.outlineid];
//    NSInteger total=[[SQLManager sharedSingle] countDownByOutlineid:ot.outlineid];

    
    NSInteger done=0;
    NSArray *ar=[[SQLManager sharedSingle] getOutLineByParentId:ot.outlineid];
    NSInteger total=0;
    for (Outline *subOt in ar) {
//        done+=[[SQLManager sharedSingle] countDoneByOutlineid:subOt.outlineid];
//        done+=[[CachedAnswer new] getCacheByOutlineid:subOt.outlineid].count;
        NSArray *doneAr=[[SQLManager sharedSingle] getQuestionByOutlineId:subOt.outlineid];
        for (Question *q in doneAr) {
            NSString *itemid=@"";
            if ([q isKindOfClass:[ChoiceQuestion class]]) {
                itemid=[(ChoiceQuestion*)q choice_id];
            }else{
                itemid=[(CompatyInfo*)q info_id];
            }
            if ([[SQLManager sharedSingle] hasDoneQuestion:itemid typeid:q.custom_id]) {
                done++;
            }
//            NSArray *findAr=[[SQLManager sharedSingle] hadDonePractisOutlineid:subOt.outlineid itemid:itemid typeid:q.custom_id];
//            if (findAr!=nil&&findAr.count>0) {
//                done++;
//            }
        }
       total+=[[SQLManager sharedSingle] countDownByOutlineid:subOt.outlineid];
    }
    cell.detailLab.text=[NSString stringWithFormat:@"%zd/%zd",done,total];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
    CourseVC* vc=[sb instantiateViewControllerWithIdentifier:@"CourseVC"];
    vc.parentid=ot.outlineid;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
//    [self performSegueWithIdentifier:@"tocourse" sender:self];
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
