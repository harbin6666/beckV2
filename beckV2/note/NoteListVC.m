//
//  NoteListVC.m
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "NoteListVC.h"
#import "SelectionPan.h"
#import "UserNote.h"
@interface NoteListVC ()
@property(nonatomic)NSInteger panIndex;
@property(nonatomic,strong)NSArray*notes;
@property(nonatomic,strong)NSSet*outlineSet,*timeSet;
@property(nonatomic,strong)SelectionPan *pan;
@end

@implementation NoteListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.notes=[[SQLManager sharedSingle] getUserNoteByOutlineId:self.outlineid];
    NSMutableArray * outlineids=[NSMutableArray array];
    NSMutableArray*times=[NSMutableArray array];

    for (UserNote*un in self.notes) {
        [outlineids addObject:un.outline_id];
        NSString*  time= un.update_time.length?un.update_time:un.add_time;
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate*d=[dateFormatter dateFromString: time];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter1 stringFromDate:d];
        [times addObject:strDate];
    }

    self.timeSet=[NSSet setWithArray:times];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *userArray = [self.timeSet sortedArrayUsingDescriptors:sortDescriptors];

    
    self.outlineSet=[NSSet setWithArray:outlineids];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (self.panIndex==0) {
        return self.timeSet.count;
    }else if (self.panIndex==1){
        return self.outlineSet.count;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.pan==nil) {
        self.pan=[[SelectionPan alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        [self.pan updatePanWithTitles:@[@"按时间",@"按章节"] selectBlock:^(NSInteger buttonIndex) {
            self.panIndex=buttonIndex;
            [self.tableView reloadData];
        }];

    }
    return self.pan;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.panIndex==0) {
        cell.textLabel.text=self.timeSet.allObjects[indexPath.row];
    }else{
        cell.textLabel.text=[[SQLManager sharedSingle] getcourseNameByOutlineId:self.outlineSet.allObjects[indexPath.row] ];
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
