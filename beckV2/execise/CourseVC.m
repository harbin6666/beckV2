//
//  CourseVC.m
//  beckV2
//
//  Created by yj on 15/5/31.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "CourseVC.h"
#import "Outline.h"
@interface CourseVC ()
@property(nonatomic,weak)IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *dataAr;
@end

@implementation CourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataAr=[[SQLManager sharedSingle] getOutLineByParentId:self.parentid];
    [self.table reloadData];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"course"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"course"];
    }
    Outline *ol=self.dataAr[indexPath.row];
    cell.textLabel.text=ol.courseName;
    NSInteger done=[[SQLManager sharedSingle] countDoneByOutlineid:ol.outlineid];
    NSInteger total=[[SQLManager sharedSingle] countDownByOutlineid:ol.outlineid];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld/%ld",done,total];

    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Outline *ol=self.dataAr[indexPath.row];
    NSArray* ar=[[SQLManager sharedSingle] getQuestionByOutlineId:ol.outlineid];
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
