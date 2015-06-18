//
//  QuestionCollectionVC.m
//  beckV2
//
//  Created by yj on 15/6/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "QuestionCollectionVC.h"
#import "Subject.h"
#import "Outline.h"
#import "NoteListVC.h"
#import "SelectionPan.h"
#import "Collection.h"
#import "NoteListCell.h"
#import "ChoiceQuestion.h"
#import "NoteDetailVC.h"
#import "CompatyQuestion.h"
@interface QuestionCollectionVC ()
@property(nonatomic,strong)NSArray *subjectIdList;
@property(nonatomic,strong)NSArray *subjectList;
@property(nonatomic,strong)NSArray *dataAr;;
@property(nonatomic,strong) SelectionPan* pan;
@property(nonatomic,assign)NSInteger panIndex;
@property(nonatomic,strong)NSSet*outlineSet;
@end

@implementation QuestionCollectionVC


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem*bar= self.navigationItem.rightBarButtonItem;
    [bar setTitle:[[Global sharedSingle] getUserWithkey:@"titleName"]];
    
    
    
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];
//        [self.dataAr addObject:sbAr];
    }

    if (self.type==0) {
        self.title=@"题目收藏";
        self.dataAr=[[SQLManager sharedSingle] findUserCollectByUserid:nil];
    }else{
        self.title=@"错题重做";
        self.dataAr=[[SQLManager sharedSingle] findUserWrongByUserId:nil];
    }

    NSMutableArray * outlineids=[NSMutableArray array];

    for (Collection*un in self.dataAr) {
        [outlineids addObject:un.outline_id];
        un.add_time=[self transferTime:un.add_time];
    }
    self.outlineSet=[NSSet setWithArray:outlineids];

    [self.tableView reloadData];
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.panIndex==1) {
        return self.outlineSet.count;
    }
    return self.dataAr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.pan==nil) {
        self.pan=[[SelectionPan alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        NSArray *ar=@[];
        if (self.type==0) {
            ar=@[@"收藏时间",@"考试科目"];
        }else{
            ar=@[@"错题时间",@"考试科目"];
        }
        [self.pan updatePanWithTitles:ar selectBlock:^(NSInteger buttonIndex) {
            self.panIndex=buttonIndex;
            [self.tableView reloadData];
        }];
    }
    return self.pan;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.panIndex==0) {
        Collection *note=self.dataAr[indexPath.row];
        NoteListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"timecell" forIndexPath:indexPath];
        cell.timeLab.text=note.add_time;
        Question* q=[[SQLManager sharedSingle]getExamQuestionByItemId:note.item_id customid:note.type_id];
        if (q==nil) {
            NSLog(@"capcap");
        }
        if (note.type_id.integerValue==10||note.type_id.integerValue==11) {
            cell.titLab.text=[(CompatyInfo*)q title];
        }else{
            cell.titLab.text=[(ChoiceQuestion*)q choice_content];
        }
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.textLabel.text=[[SQLManager sharedSingle] getcourseNameByOutlineId:self.outlineSet.allObjects[indexPath.row] ];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Collection *note=self.dataAr[indexPath.row];
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"pan" bundle:[NSBundle mainBundle]];
    NoteDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"notedetail"];
    vc.outletid=note.outline_id;

    if (self.panIndex==0) {
        Question *q=[[SQLManager sharedSingle] getExamQuestionByItemId:note.item_id customid:note.type_id];
        vc.questionsAr=@[q];
    }else{
        NSMutableArray *ar=[[NSMutableArray alloc] init];
        for (Collection *n in self.dataAr) {
            if (n.item_id.integerValue==note.item_id.integerValue&&n.type_id.integerValue==note.type_id.integerValue) {
                Question *q=[[SQLManager sharedSingle] getExamQuestionByItemId:note.item_id customid:note.type_id];
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
@end
