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
@interface PractisHomeVC ()<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate,OutlineCellDelegate>
@property(nonatomic,strong)NSArray *subjectIdList;
@property(nonatomic,strong)NSArray *subjectList;
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataAr;
@property(nonatomic,strong)NSMutableArray *hiddenAr;
@end

@implementation PractisHomeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showLoading];
    [self performSelector:@selector(delayLoad) withObject:nil afterDelay:0.3];
}

-(void)delayLoad{
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
        [self.dataAr addObject:sbAr];
    }
    [self.table reloadData];
    [self hideLoading];
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
    self.hiddenAr=[[NSMutableArray alloc] init];
    self.table.tableFooterView=[[UIView alloc] init];
}

-(IBAction)homeClick:(UIButton *)sender{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BOOL b=NO;
    for (NSString *t in self.hiddenAr) {
        if (t.integerValue==section) {
            b=YES;
            break;
        }
    }
    if (b) {
        return 0;
    }
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
    cell.textLabel.backgroundColor=[UIColor clearColor];
    UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=cell.bounds;
    b.tag=section;
    [b addTarget:self action:@selector(recordhidden:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:b];
    return cell;
}

-(void)recordhidden:(UIButton*)b{
    NSString *dest=nil;
    for (NSString *t in self.hiddenAr) {
        if (t.integerValue==b.tag) {
            dest=t;
            break;
        }
    }
    if (dest!=nil) {
        [self.hiddenAr removeObject:dest];
    }else{
        [self.hiddenAr addObject:[NSString stringWithFormat:@"%zd",b.tag]];
    }
//    [self.table reloadSections:[NSIndexSet indexSetWithIndex:dest.integerValue] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OutlineCell* cell=[tableView dequeueReusableCellWithIdentifier:@"outlinecell" forIndexPath:indexPath];
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    cell.textlab.text=ot.courseName;
    cell.delegate=self;
    [cell updateWithoutlineid:ot.outlineid];
//    NSInteger done=0;
//    NSInteger total=0;
//
//    NSArray *ar=[[SQLManager sharedSingle] getOutLineByParentId:ot.outlineid];
//    for (Outline *subOt in ar) {
//        done+=[[SQLManager sharedSingle] countDoneByOutlineid:subOt.outlineid];
//        total+=[[SQLManager sharedSingle] countDownByOutlineid:subOt.outlineid];
//    }
//    cell.detailLab.text=[NSString stringWithFormat:@"%zd/%zd",done,total];
    return cell;
}

-(void)countDownDelegate:(OutlineCell *)cell result:(NSString *)result{
    cell.detailLab.text=result;
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
