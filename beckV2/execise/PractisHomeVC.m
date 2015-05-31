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
@interface PractisHomeVC ()<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>
@property(nonatomic,strong)NSArray *subjectIdList;
@property(nonatomic,strong)NSArray *subjectList;
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataAr;;
@end

@implementation PractisHomeVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarButtonName:@"首页" width:40 isLeft:YES];
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

-(void)leftBtnClick:(UIButton *)sender{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
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

    cell.imageView.image=[UIImage imageNamed:@"uncheckbox"];
//    NSArray *ar=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    Subject *sb=self.subjectList[section];
    cell.textLabel.text=sb.subjectName;

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"outlinecell" forIndexPath:indexPath];
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    cell.textLabel.text=ot.courseName;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *temp=self.dataAr[indexPath.section];
    Outline *ot=temp[indexPath.row];
    CourseVC*vc=[[CourseVC alloc] init];
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
