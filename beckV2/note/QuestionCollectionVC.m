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
@property(nonatomic,strong)NSArray *dataAr;
@property(nonatomic,strong)NSMutableArray *tempSubs,*tempSubNames;
@property(nonatomic,strong) SelectionPan* pan;
@property(nonatomic,assign)NSInteger panIndex;
@property(nonatomic,strong)NSSet*outlineSet;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@end

@implementation QuestionCollectionVC


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
        [self.view addSubview:self.pan];
    }

    UIBarButtonItem*bar= self.navigationItem.rightBarButtonItem;
    [bar setTitle:[[Global sharedSingle] getUserWithkey:@"titleName"]];
    
    self.dataAr=[NSMutableArray array];
    self.subjectIdList=[[SQLManager sharedSingle] getSubjectIdArrayByid:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    self.subjectList=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    self.tempSubs=[NSMutableArray array];
    self.tempSubNames=[NSMutableArray array];
    for (int i=0; i<self.subjectList.count; i++) {
        Subject*sb=self.subjectList[i];
        NSMutableArray *tempZh=[NSMutableArray array];
        NSMutableArray *zhName=[NSMutableArray array];
        NSArray *sbAr=[[SQLManager sharedSingle] getoutLineByid:sb.subjectid];//章
        for (int j=0; j<sbAr.count; j++) {
            Outline*zhang=sbAr[j];
            NSArray * jieAr=[[SQLManager sharedSingle] getOutLineByParentId:zhang.outlineid];//节
            NSMutableArray *jied=[NSMutableArray array];
            NSMutableArray *jieName=[NSMutableArray array];
            for (int k=0;k<jieAr.count;k++) {
                Outline*jie=jieAr[k];
                if (self.type==0) {
                   NSArray *collects =[[SQLManager sharedSingle] findUserCollectByOutlineid:jie.outlineid];
                    if (collects.count>0) {
                        [jied addObject:collects];
                        [jieName addObject:jie];
                    }
                }else{
                    NSArray *wrongs =[[SQLManager sharedSingle] findUserWrongByOutlineid:jie.outlineid];
                    if (wrongs.count>0) {
                        [jied addObject:wrongs];
                        [jieName addObject:jie];
                    }
                }
            }
            if (jied.count>0) {
                [tempZh addObject:jied];
                [zhName addObject:zhang];
            }
        }
        if (tempZh.count>0) {
            [self.tempSubs addObject:tempZh];
            [self.tempSubNames addObject:sb];
        }
    }
    if (self.type==0) {
        self.title=@"题目收藏";
        self.dataAr=[[SQLManager sharedSingle] findUserCollectByOutlineid:nil];
    }else{
        self.title=@"错题重做";
        self.dataAr=[[SQLManager sharedSingle] findUserWrongByOutlineid:nil];
    }

    NSMutableArray * outlineids=[NSMutableArray array];

    for (Collection*un in self.dataAr) {
        [outlineids addObject:un.subject_id];
        if (self.type==0) {
            un.add_time=[self transferTime:un.add_time];
        }
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
        NSArray *t=self.tempSubs[section];
        return t.count;
    }
    return self.dataAr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.panIndex==1) {
        return self.tempSubNames.count;
    }
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"headerview"];
    cell.backgroundColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:@"flag"];
    //    NSArray *ar=[[SQLManager sharedSingle] getSubjectByid:self.subjectIdList];
    Subject *sb=self.tempSubNames[section];
    cell.textLabel.text=sb.subjectName;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.panIndex==0) {
        return 0;
    }
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
        NSArray *sb=self.tempSubs[indexPath.section];
//        Outline *ot=sb[indexPath.row];
//        cell.textLabel.text=[[SQLManager sharedSingle] getcourseNameByOutlineId:ot.outlineid];
        NSString *table=@"user_collection";
        if (self.type==1) {
            table=@"user_wrong_item";
        }
        NSInteger c=sb.count;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%zd",c];
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
        NSString *sbjid=self.outlineSet.allObjects[indexPath.row];
        NSMutableArray *ar=[[NSMutableArray alloc] init];
        for (Collection *n in self.dataAr) {
            if (n.subject_id.integerValue==sbjid.integerValue) {
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
@end
