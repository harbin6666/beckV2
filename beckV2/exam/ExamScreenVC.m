//
//  ExamScreenVC.m
//  beckV2
//
//  Created by yj on 15/6/8.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamScreenVC.h"
#import "ExamPaper.h"
#import "Question.h"
#import "ExamVC.h"
@interface ExamScreenVC ()
@property(nonatomic,strong)NSMutableArray *qAr;
@property(nonatomic,strong)ExamPaper*currentPaper;
@end

@implementation ExamScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.papers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ExamPaper*p=[self.papers objectAtIndex:indexPath.row];
    cell.textLabel.text=p.paper_name;
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   self.currentPaper=self.papers[indexPath.row];
    NSArray *examcompose=[[SQLManager sharedSingle] getExamPaperCompositonByPaperId:self.currentPaper.paper_id];
    NSMutableArray *quest=[[NSMutableArray alloc] init];
    for (int i=0; i<examcompose.count; i++) {
        ExamPaperComposition*comp=examcompose[i];
        NSArray* questions=[[SQLManager sharedSingle] getExamPaperContentByPaperid:comp.paper_id compid:comp.comp_id];
        [quest addObjectsFromArray:questions];
    }
    
    self.qAr=[[NSMutableArray alloc] init];
    for (int i=0; i<quest.count; i++) {
        ExamPaper_Content *con=quest[i];
        Question* q=[[SQLManager sharedSingle] getExamQuestionByItemId:con.item_id customid:con.custom_id];
        [self.qAr addObject:q];
    }
    ExamVC* vc=[[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"exam"];
    vc.questionsAr=self.qAr;
    vc.examComp=self.currentPaper;
    [self.navigationController pushViewController:vc animated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toexamvc"]) {
        
        NSArray *examcompose=[[SQLManager sharedSingle] getExamPaperCompositonByPaperId:self.currentPaper.paper_id];
        NSMutableArray *quest=[[NSMutableArray alloc] init];
        for (int i=0; i<examcompose.count; i++) {
            ExamPaperComposition*comp=examcompose[i];
            NSArray* questions=[[SQLManager sharedSingle] getExamPaperContentByPaperid:comp.paper_id compid:comp.comp_id];
            [quest addObjectsFromArray:questions];
        }
        
        self.qAr=[[NSMutableArray alloc] init];
        for (int i=0; i<quest.count; i++) {
            ExamPaper_Content *con=quest[i];
            Question* q=[[SQLManager sharedSingle] getExamQuestionByItemId:con.item_id customid:con.custom_id];
            [self.qAr addObject:q];
        }

        
        ExamVC*dest=segue.destinationViewController;
        dest.questionsAr=self.qAr;
        dest.examTime=self.currentPaper.answer_time.integerValue;
    }
}
*/

@end
