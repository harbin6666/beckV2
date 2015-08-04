//
//  CourseVC.m
//  beckV2
//
//  Created by yj on 15/5/31.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "CourseVC.h"
#import "Outline.h"
#import "QuestionVC.h"
#import "CachedAnswer.h"
#import "CourseCell.h"
@interface CourseVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSArray *dataAr;
@end

@implementation CourseVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *temp=[[SQLManager sharedSingle] getOutLineByParentId:self.parentid];
    NSMutableArray *ar=[NSMutableArray array];
    for (int i=0; i<temp.count; i++) {
        Outline *ol=temp[i];
        NSInteger total=[[SQLManager sharedSingle] countDownByOutlineid:ol.outlineid];
        if (total>0) {
            [ar addObject:ol];
        }
    }
    self.dataAr=ar;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.dataAr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCell* cell=[tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"course"];
//    }
    Outline *ol=self.dataAr[indexPath.row];
    cell.textlab.text=ol.courseName;
//    NSInteger done=[[SQLManager sharedSingle] countDoneByOutlineid:ol.outlineid];
    NSInteger done=[[CachedAnswer new] getCacheByOutlineid:ol.outlineid].count;
    NSInteger total=[[SQLManager sharedSingle] countDownByOutlineid:ol.outlineid];
    cell.detailLab.text=[NSString stringWithFormat:@"%zd/%zd",done,total];

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Outline *ol=self.dataAr[indexPath.row];
    NSInteger total=[[SQLManager sharedSingle] countDownByOutlineid:ol.outlineid];
    if (total==0) {
        return;
    }
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"question" bundle:[NSBundle mainBundle]];
    QuestionVC *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestionVC"];
    vc.practisMode=YES;
    vc.outletid=ol.outlineid;
    [self.navigationController pushViewController:vc animated:YES];
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
