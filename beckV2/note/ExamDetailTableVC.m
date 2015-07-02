//
//  ExamDetailTableVC.m
//  beckV2
//
//  Created by yj on 15/7/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamDetailTableVC.h"
#import "ExamDetailCell.h"
#import "QuestionVC.h"
@interface ExamDetailTableVC ()

@end

@implementation ExamDetailTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"考试详情";
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

    return self.examAr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamDetailCell" forIndexPath:indexPath];
    [cell updateWithExamAr:self.examAr[indexPath.row] block:^{
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"question" bundle:[NSBundle mainBundle]];
        QuestionVC*vc =[sb instantiateViewControllerWithIdentifier:@"QuestionVC"];
        vc.showTimer=NO;
        vc.fromDetail=YES;
        UserExam *ue=[self.examAr lastObject];
        vc.paperid=ue.paper_id;
        vc.showAnswer=YES;
        [self.navigationController pushViewController:vc animated:YES];

    }];

    
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
