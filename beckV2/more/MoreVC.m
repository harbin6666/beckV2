//
//  MoreVC.m
//  beckV2
//
//  Created by yj on 15/6/4.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "MoreVC.h"
#import "HighFrequencyListVC.h"
@interface MoreVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView*table;
@end

@implementation MoreVC

-(IBAction)homeClick:(UIButton *)sender{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.tableFooterView=[[UIView alloc] init];

    self.table.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    lab.text=@"Copyright © 武汉贝英信息技术有限公司\nAll Rights Reserved  版权所有";
    lab.numberOfLines=0;
    lab.font=[UIFont systemFontOfSize:14];
    lab.backgroundColor=[UIColor clearColor];
    lab.textColor=[UIColor grayColor];
    lab.textAlignment=NSTextAlignmentCenter;
    self.tableView.tableFooterView=lab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 3;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*v=[[UIView alloc] init];
    v.backgroundColor=[UIColor clearColor];
    return v;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    int p=0;
    switch (section) {
        case 0:
            p=3;
            break;
        case 1:
            p=3;
            break;
        case 2:
            p=2;
            break;
            
        default:
            break;
    }

    return p;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSInteger gg=indexPath.row;
    if (indexPath.section==1) {
        gg=2+indexPath.row;
    }else if(indexPath.section==2){
        gg=5+indexPath.row;
    }
    NSString *imgstr=[NSString stringWithFormat:@"more%zd",gg];
    cell.imageView.image=[UIImage imageNamed:imgstr];
    NSString *text;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            text=@"高频考点";
        }else if(indexPath.row==1){
            text=@"题库更新";
        }else{
            text=@"积分商城";
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            text=@"个人档案";
        }else if(indexPath.row==1){
            text=@"我的消息";
        }else{
            text=@"软件分享";
        }
    }else {
        if (indexPath.row==0) {
            text=@"意见反馈";
        }else{
            text=@"使用帮助";
        }
    }
    cell.textLabel.text=text;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [self performSegueWithIdentifier:@"tohigh" sender:self];
        }else if (indexPath.row==1){
            [self performSegueWithIdentifier:@"updatedb" sender:self];
        }else if (indexPath.row==2){
            [self performSegueWithIdentifier:@"topointshop" sender:self];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            [self performSegueWithIdentifier:@"tousercenter" sender:self];
        }else if (indexPath.row==1){
            [self performSegueWithIdentifier:@"tomessage" sender:self];
        }else{
            
        }
    }else{
        if (indexPath.row==0) {
            [self performSegueWithIdentifier:@"tofeedback" sender:self];
        }else{
            [self performSegueWithIdentifier:@"tohelp" sender:self];
        }
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
