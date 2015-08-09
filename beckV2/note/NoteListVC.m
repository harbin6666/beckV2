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
#import "Question.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
#import "NoteListCell.h"
#import "NoteDetailVC.h"
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
        if (un.update_time==nil||un.update_time.length==0) {
            un.update_time=un.add_time;
        }

        NSString *strDate = [self transferTime:un.update_time];
        [times addObject:strDate];
        un.update_time=strDate;
    }

    self.timeSet=[NSSet setWithArray:times];
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    NSArray *userArray = [self.timeSet sortedArrayUsingDescriptors:sortDescriptors];

    
    self.outlineSet=[NSSet setWithArray:outlineids];
    
}

-(NSString*)transferTime:(NSString*)time{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*d=[dateFormatter dateFromString: time];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter1 stringFromDate:d];
    return strDate;
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (self.panIndex==0) {
        return self.notes.count;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.panIndex==0) {
        return 50;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.panIndex==0) {
        UserNote *note=self.notes[indexPath.row];
        NoteListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"timecell" forIndexPath:indexPath];
        cell.timeLab.text=note.update_time;
        Question* q=[[SQLManager sharedSingle]getExamQuestionByItemId:note.item_id customid:note.type_id];
        if (note.type_id.integerValue==10||note.type_id.integerValue==11||note.type_id.integerValue==8||note.type_id.integerValue==9) {
            cell.titLab.text=[(CompatyInfo*)q title];
        }else{
            cell.titLab.text=[(ChoiceQuestion*)q choice_content];
        }
        cell.noteLab.text=note.note;
        return cell;

    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        cell.textLabel.text=[[SQLManager sharedSingle] getcourseNameByOutlineId:self.outlineSet.allObjects[indexPath.row] ];
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserNote *note=self.notes[indexPath.row];
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"pan" bundle:[NSBundle mainBundle]];
    NoteDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"notedetail"];
    vc.outletid=note.outline_id;

    if (self.panIndex==0) {
        Question *q=[[SQLManager sharedSingle] getExamQuestionByItemId:note.item_id customid:note.type_id];
        vc.questionsAr=@[q];
    }else{
        NSMutableArray *ar=[[NSMutableArray alloc] init];
        NSString *outlineid=self.outlineSet.allObjects[indexPath.row];
        for (UserNote *n in self.notes) {
            if (n.outline_id.integerValue==outlineid.integerValue) {
                Question *q=[[SQLManager sharedSingle] getExamQuestionByItemId:n.item_id customid:n.type_id];
                if (q!=nil) {
                    [ar addObject:q];
                }
            }
        }
        vc.questionsAr=ar;
        if (ar.count==0) {
            return;
        }

    }
    [self.navigationController pushViewController:vc animated:YES];
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
