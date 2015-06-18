//
//  NoteVC.m
//  beckV2
//
//  Created by yj on 15/6/4.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "NoteVC.h"
#import "SeeNoteVC.h"
#import "QuestionCollectionVC.h"
@interface NoteVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView*table;
@end

@implementation NoteVC
-(IBAction)homeClick:(UIButton *)sender{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.tableFooterView=[[UIView alloc] init];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"查看笔记";
            break;
        case 1:
            cell.textLabel.text=@"练习统计";
            break;
        case 2:
            cell.textLabel.text=@"题目收藏";
            break;
        case 3:
            cell.textLabel.text=@"错题重做";
            break;
        default:
            break;
    }
    cell.imageView.image=[UIImage imageNamed:[NSString  stringWithFormat:@"MA%zd",indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            
        case 0:
        case 1:{
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
            SeeNoteVC* vc=[sb instantiateViewControllerWithIdentifier:@"seenote"];
            vc.hidesBottomBarWhenPushed=YES;
            vc.type=indexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 2:
        case 3:
        {
            UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
            QuestionCollectionVC* vc=[sb instantiateViewControllerWithIdentifier:@"seecollect"];
            vc.hidesBottomBarWhenPushed=YES;
            vc.type=indexPath.row-2;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}



@end
