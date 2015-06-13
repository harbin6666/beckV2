//
//  PointDetailVC.m
//  beckV2
//
//  Created by yj on 15/6/14.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PointDetailVC.h"
#import "BaseViewController.h"
#import "PointDetailCell.h"
@interface PointDetailVC ()
@property(nonatomic,strong)NSArray *buylist;
@property(nonatomic,strong)NSArray *historylist;
@end

@implementation PointDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url=@"";
    if (self.type==0) {
        url=@"/front/pointTransAct.htm";
        self.title=@"我的积分";
    }else{
        url=@"/front/orderAct.htm";
        self.title=@"支付信息";
    }
    [self showLoading];
    [self getValueWithBeckUrl:url params:@{@"token":@"list",@"loginName":[Global sharedSingle].loginName} CompleteBlock:^(id aResponseObject, NSError *anError) {
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                if (self.type==0) {
//                    NSArray *ar=aResponseObject[@"list"];
//                    for (NSString *sql in ar) {
//                        [[SQLManager sharedSingle] excuseSql:sql];
//                    }
                    
                    self.buylist=[[SQLManager sharedSingle] getPoints];
                    [self.tableView reloadData];
                }else{
                    self.buylist=aResponseObject[@"list"];
                    [self.tableView reloadData];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.buylist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PointDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary* dic=self.buylist[indexPath.section];
    cell.backgroundColor=[UIColor whiteColor];

    if (indexPath.row==0) {
        cell.imageView.image=[UIImage imageNamed:@"zhifu"];
        cell.backgroundColor=[UIColor redColor];
        cell.ttlab.text=@"积分";
        cell.ttlab.textColor=[UIColor whiteColor];
        cell.dlab.textColor=[UIColor whiteColor];
        cell.dlab.text=dic[@"description"];

    }else if (indexPath.row==1){
        cell.imageView.image=[UIImage imageNamed:@"zhifu"];
        cell.ttlab.text=@"类型";

        cell.dlab.text=dic[@"description"];
        cell.ttlab.textColor=[UIColor lightGrayColor];
        cell.dlab.textColor=[UIColor lightGrayColor];

    }else if (indexPath.row==2){
        cell.imageView.image=[UIImage imageNamed:@"zhifu"];
        cell.ttlab.text=@"数量";
        cell.ttlab.textColor=[UIColor lightGrayColor];
        cell.dlab.textColor=[UIColor lightGrayColor];
        cell.dlab.text=[dic[@"moeny"] stringValue];

    }else {
        cell.imageView.image=[UIImage imageNamed:@"zhifu"];
        cell.dlab.text=dic[@"payDate"];
        cell.ttlab.textColor=[UIColor lightGrayColor];
        cell.dlab.textColor=[UIColor lightGrayColor];
        cell.ttlab.text=@"时间";

    }
    
    
    return cell;
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
