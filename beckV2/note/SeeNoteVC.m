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

@interface SeeNoteVC ()
@property(nonatomic,strong)NSArray *subjectIdList;
@property(nonatomic,strong)NSArray *subjectList;
@property(nonatomic,strong)NSMutableArray *dataAr;;

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
    if (self.type==0) {
        self.title=@"查看笔记";
    }else{
        self.title=@"练习统计";
    }

    
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
        [self.dataAr addObject:sbAr];
    }
    
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *temp=self.dataAr[section];
    return temp.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.subjectList.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"headerview"];
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
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    cell.textLabel.text=ot.courseName;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    
    UIStoryboard*sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
    NoteListVC*vc=[sb instantiateViewControllerWithIdentifier:@"notelist"];
    
    vc.outlineid=ot.outlineid;
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
    //    [self performSegueWithIdentifier:@"tocourse" sender:self];
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
