//
//  SeeNoteVC.m
//  beckV2
//
//  Created by yj on 15/6/8.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "SeeNoteVC.h"
#import "Subject.h"
#import "Outline.h"
#import "NoteListVC.h"
#import "SelectionPan.h"
#import "ExamPaper.h"
#import "PractisDetailVC.h"
@interface SeeNoteVC ()
@property(nonatomic,strong)NSArray *subjectIdList;
@property(nonatomic,strong)NSArray *subjectList;
@property(nonatomic,strong)NSMutableArray *dataAr;;
@property(nonatomic,strong) SelectionPan* pan;
@property(nonatomic,assign)NSInteger titleSelect;
@property(nonatomic,strong)NSArray *examArray;
@end

@implementation SeeNoteVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem*bar= self.navigationItem.rightBarButtonItem;
    [bar setTitle:[[Global sharedSingle] getUserWithkey:@"titleName"]];
   

    
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
        [self.dataAr addObject:sbAr];
    }
    if (self.type==0) {
        self.title=@"查看笔记";
    }else{
        self.title=@"练习统计";
//        NSArray *moni=[[SQLManager sharedSingle] getExamByType:@"1"];
//        NSArray *zhenti=[[SQLManager sharedSingle] getExamByType:@"2"];
        NSArray *moni=@[@"场次一",@"场次二",@"场次三",@"场次四"];
        self.examArray=@[moni,moni];
        self.pan=[[SelectionPan alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [self.pan updatePanWithTitles:@[@"练习统计",@"考试统计"] selectBlock:^(NSInteger buttonIndex) {
            self.titleSelect=buttonIndex;
            self.title=@[@"练习统计",@"考试统计"][buttonIndex];
            [self.tableView reloadData];
        }];
        self.tableView.tableHeaderView=self.pan;
    }
    self.tableView.tableFooterView=[[UIView alloc] init];
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.titleSelect==1) {
        return [(NSArray*)self.examArray[section] count];
    }
    NSArray *temp=self.dataAr[section];
    return temp.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.titleSelect==1) {
        return self.examArray.count;
    }
    return self.subjectList.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"headerview"];
    cell.backgroundColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:@"flag"];
    //    NSArray *ar=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    Subject *sb=self.subjectList[section];
    cell.textLabel.text=sb.subjectName;

    if (self.titleSelect==1&&section==0) {
        cell.textLabel.text= @"模拟考试";
    }
    if (self.titleSelect==1&&section==1) {
        cell.textLabel.text= @"真题考试";
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    cell.textLabel.text=ot.courseName;
    if (self.titleSelect==1) {
        NSArray * ar=self.examArray[indexPath.section];
        NSString*p=ar[indexPath.row];
        cell.textLabel.text=p;
        //该场次下所有考试1，2，3，4
        NSArray *arr=[[SQLManager sharedSingle]getExamPaperType:[NSString stringWithFormat:@"%zd",indexPath.section+1] screen:[NSString stringWithFormat:@"%zd",indexPath.row+1]];
        NSMutableArray *recodes=[NSMutableArray array];
        for (ExamPaper *p in arr) {
            NSArray *temp=[[SQLManager sharedSingle] getUserExamByPaperId:p.paper_id];
            if (temp!=nil&&temp.count) {
                [recodes addObjectsFromArray:temp];
            }
        }
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%zd",recodes.count];
    }
    if (self.type==1&&self.titleSelect==0) {
        NSMutableArray * ar=[NSMutableArray array];
        NSArray *outlinelist=[[SQLManager sharedSingle] getOutLineByParentId:ot.outlineid];
        for (Outline *o in outlinelist) {
            NSArray *temp=[[SQLManager sharedSingle] getPractisWithOutlineid:o.outlineid];
            [ar addObjectsFromArray:temp];
        }
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%zd",ar.count];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard*sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];

    if (self.titleSelect==1) {
        NSInteger r=(indexPath.row+1);
        NSArray *arr=[[SQLManager sharedSingle]getExamPaperType:[NSString stringWithFormat:@"%zd",indexPath.section+1] screen:[NSString stringWithFormat:@"%zd",r]];
        NSMutableArray *recodes=[NSMutableArray array];
        for (ExamPaper *p in arr) {
            NSArray *temp=[[SQLManager sharedSingle] getUserExamByPaperId:p.paper_id];
            if (temp!=nil&&temp.count) {
                [recodes addObjectsFromArray:temp];
            }
        }
        PractisDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"PractisDetailVC"];
        vc.examPapers=arr;
        vc.type=1;
        vc.examAr=recodes;
        [self.navigationController pushViewController:vc animated:YES];

        
    }else{
       
        NSArray *temp=self.dataAr[indexPath.section];
        Outline *ot=temp[indexPath.row];
        
        if (self.type==0) {
            NoteListVC*vc=[sb instantiateViewControllerWithIdentifier:@"notelist"];
            
            vc.outlineid=ot.outlineid;
            vc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSMutableArray * ar=[NSMutableArray array];
            NSArray *outlinelist=[[SQLManager sharedSingle] getOutLineByParentId:ot.outlineid];
            for (Outline *o in outlinelist) {
                NSArray *temp=[[SQLManager sharedSingle] getPractisWithOutlineid:o.outlineid];
                [ar addObjectsFromArray:temp];
            }

            PractisDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"PractisDetailVC"];
            
            vc.type=0;
            vc.outlineid=ot.outlineid;
            vc.practisAr=ar;
            [self.navigationController pushViewController:vc animated:YES];

        }

    }
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
