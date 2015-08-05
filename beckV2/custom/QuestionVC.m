//
//  QuestionVC.m
//  beckV2
//
//  Created by yj on 15/6/28.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "QuestionVC.h"
#import "SettingPanVC.h"
#import "UserNote.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
#import "ChoiceCell.h"
#import "CompatyCell.h"
#import "QCollectionVC.h"
#import "CachedAnswer.h"
#import "ExamPaper.h"
#import "FinishExamVC.h"
#import "AnswerObj.h"
#import "NoteCell.h"
#import "CXAlertView.h"
#import "CALayer+Transition.h"
@interface QuestionVC ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,QCollectionVCDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (nonatomic, strong) SettingPanVC *settingPanVC;
@property(nonatomic,strong) UserNote*currentNote;
@property(nonatomic,strong)NSString *questionDes;
@property(nonatomic,strong)NSArray *choiceArray;//选择题选项数组
@property(nonatomic,strong)NSArray *compatibilyArray;//配伍题数组
@property(nonatomic,weak) IBOutlet UIButton *questionBtn;
@property(nonatomic,weak)IBOutlet UITabBar* tabbar;
@property(nonatomic,weak)UITableViewCell *answerCell;
@property(nonatomic,weak) IBOutlet UILabel *testLab;
@property(nonatomic,assign)NSInteger currentQIndex;
@property(nonatomic,weak) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *questionsAr;
@property(nonatomic,strong)NSDate *beginTime;
@property(nonatomic,strong) UILabel *timeLab;
@property(nonatomic,strong)NSTimer* timer;
@property(nonatomic,assign)NSInteger seconds;
@property(nonatomic)NSInteger font;
@property(nonatomic,strong)NoteCell*notecell;
@end

@implementation QuestionVC

- (void)didSelectedItemIndexInAnswerCVC:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
    self.currentQIndex=index;
    [self freshView];
}


-(void)findQuestions{
    if (self.outletid) {//练习
        self.questionsAr=[[SQLManager sharedSingle] getQuestionByOutlineId:self.outletid];
        NSArray *cachedAr=[[CachedAnswer new] getCacheByOutlineid:self.outletid];
        if (cachedAr!=nil) {
            
        }
    }else{//考试
        NSArray *examcompose=[[SQLManager sharedSingle] getExamPaperCompositonByPaperId:self.paperid];
        NSMutableArray *quest=[[NSMutableArray alloc] init];
        for (int i=0; i<examcompose.count; i++) {
            ExamPaperComposition*comp=examcompose[i];
            NSArray* questions=[[SQLManager sharedSingle] getExamPaperContentByPaperid:comp.paper_id compid:comp.comp_id];
            [quest addObjectsFromArray:questions];
        }        
        NSMutableArray *temp=[[NSMutableArray alloc] init];
        for (int i=0; i<quest.count; i++) {
            ExamPaper_Content *con=quest[i];
            Question* q=[[SQLManager sharedSingle] getExamQuestionByItemId:con.item_id customid:con.custom_id];
            q.examScore=con.score;
            [temp addObject:q];
        }
        self.questionsAr=temp;
        if (self.fromDetail) {
            UserExam *ue=[[[SQLManager sharedSingle] getUserExamByPaperId:self.paperid]lastObject];
            
            NSArray * ar=[NSJSONSerialization JSONObjectWithData:[ue.user_answer dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];

            for (NSDictionary *anDic in ar) {
                switch ([anDic[@"customId"] integerValue]) {
                    case 10:{
                        QuestionAnswerB* ab=[[QuestionAnswerB alloc] initWithDictionary:anDic error:nil];
                        [self.answerArray addObject:ab];
                    }
                        break;
                    case 11:{
                        QuestionAnswerC* ab=[[QuestionAnswerC alloc] initWithDictionary:anDic error:nil];
                        [self.answerArray addObject:ab];
                    }
                        break;
 
                    default:{
                        QuestionAnswerA* ab=[[QuestionAnswerA alloc] initWithDictionary:anDic error:nil];
                        [self.answerArray addObject:ab];
                    }
                        break;
                }
            }
        }
    }
    
}

-(void)updateTime{
    self.seconds--;
    NSInteger h=(NSInteger)self.seconds/60;
    NSInteger s=self.seconds%60;
    self.timeLab.text=[NSString stringWithFormat:@"%zd:%zd",h,s];
}

-(void)updateFont{
    self.font=[[NSUserDefaults standardUserDefaults] integerForKey:@"fontValue"];
    [self.table reloadData];
}

-(void)swipe:(UISwipeGestureRecognizer*)gesture{
    if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
        if (gesture.direction==UISwipeGestureRecognizerDirectionLeft) {
            [self forwardPress:nil];
        }else if(gesture.direction==UISwipeGestureRecognizerDirectionRight){
            [self backwardPress:nil];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFont) name:@"updatefont" object:nil];
    self.font=[[NSUserDefaults standardUserDefaults] integerForKey:@"fontValue"];
    
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.table addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipe1=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe1.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.table addGestureRecognizer:swipe1];

    swipe.delegate=self;
    if (self.answerArray==nil) {
        self.answerArray=[[NSMutableArray alloc] init];
    }
    self.navigationController.navigationBarHidden=NO;
    if (self.showTimer) {
        self.timeLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        self.timeLab.textColor=[UIColor whiteColor];
        self.timeLab.textAlignment=NSTextAlignmentCenter;
        UIBarButtonItem*bitem=[[UIBarButtonItem alloc] initWithCustomView:self.timeLab];
        self.navigationItem.rightBarButtonItem=bitem;

        self.beginTime=[NSDate date];
        self.seconds=self.examComp.answer_time.integerValue*60;
        NSInteger h=(NSInteger)self.seconds/60;
        NSInteger s=self.seconds%60;
        self.timeLab.text=[NSString stringWithFormat:@"%zd:%zd",h,s];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    UITabBarItem*item4= [self.tabbar.items objectAtIndex:3];
    if (self.outletid) {
        [item4 setTitle:@"收藏"];
        [self setNavigationBarButtonName:@"提交" width:40 isLeft:NO];
        [self setNavigationBarButtonName:@"返回" width:40 isLeft:YES];

    }
    if (self.paperid) {
        if (self.fromDetail) {
            [self setNavigationBarButtonName:@"返回" width:40 isLeft:YES];
        }
        [item4 setTitle:@"提交"];
        self.questionBtn.hidden=YES;
    }else{
        if (self.fromDetail) {
            self.questionBtn.hidden=YES;
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    
    [self findQuestions];
    
    self.currentQIndex=0;
    
    
    
    if (self.practisMode) {
        if (self.fromDetail) {
//            self.answerArray=[[CachedAnswer new] getCacheByOutlineid:self.outletid];
        }else{
            NSArray *cachedAr=[[CachedAnswer new] getCacheByOutlineid:self.outletid];
            if (cachedAr!=nil) {
                __block AnswerObj *temp=nil;
                [cachedAr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AnswerObj *an=(AnswerObj *)obj;
                    if (an.priority.integerValue>temp.priority.integerValue) {
                        temp=an;
                    }
                    
                }];
                NSString *s=[NSString stringWithFormat:@"上次练习到%@题，是否继续",temp.priority];
                [[OTSAlertView alertWithTitle:@"" message:s leftBtn:@"取消" rightBtn:@"继续" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex==1) {
                        self.currentQIndex=temp.priority.integerValue-1;
                        self.answerArray=[NSMutableArray arrayWithArray:cachedAr];
                        for (AnswerObj*an in self.answerArray) {
                            Question* question=self.questionsAr[an.priority.integerValue-1];
                            if (an.AnswerState.integerValue==1) {
                                question.answerType=answeredRight;
                            }else if (an.AnswerState.integerValue==0){
                                question.answerType=answeredwrong;
                            }else{
                                question.answerType=answeredNone;
                            }
                        }
                    }
                    [self freshView];
                }] show];

            }
            
        }
    }
    [self freshView];
    
}

-(void)leftBtnClick:(UIButton *)sender{
    if (self.fromDetail) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.practisMode) {
        [[OTSAlertView alertWithTitle:@"提示" message:@"是否保存练习" leftBtn:@"取消" rightBtn:@"保存" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
                [[CachedAnswer new] saveCache:self.answerArray outlineid:self.outletid];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }] show];
    }
    
}

-(void)freshView{
    self.title=[NSString stringWithFormat:@"%zd/%zd",self.currentQIndex+1,self.questionsAr.count];
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    

    NSString *titid=nil;
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        titid=[(ChoiceQuestion*)p choice_id];
    }else{
        titid=[(CompatyInfo*)p info_id];
    }
    self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:p.custom_id];
    
    
    
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        self.table.allowsSelection=YES;
        ChoiceQuestion* q=(ChoiceQuestion*)p;
        self.questionDes= q.choice_content;
        if (q.custom_id.intValue==12) {
            self.table.allowsMultipleSelection=YES;
        }else{
            self.table.allowsMultipleSelection=NO;
        }
        q.choiceItems=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];
        NSMutableArray *rightItems=[NSMutableArray array];
        for (ChoiceItem *item in q.choiceItems) {
            if (item.is_answer.integerValue==1) {
                [rightItems addObject:item.nid];
            }
        }
        q.rightChoiceItems=rightItems;
        self.choiceArray=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];
        if (![self findDoneAnswerWithid:q.choice_id]) {
            QuestionAnswerA *a=[QuestionAnswerA new];
            a.customId=p.custom_id;
            a.subjectId=p.subject_id;
            a.nid=q.choice_id;
            a.outletId=q.outlet_id;
            a.priority=@(self.currentQIndex+1).stringValue;
            [self addAnswer:a];
        }
        
    }else{
        self.table.allowsSelection=NO;
        CompatyInfo *comp=(CompatyInfo*)p;

        
        self.compatibilyArray=[[SQLManager sharedSingle] getCompatyQuestionsByinfoId:comp.info_id];
        //子题目
        for (int i=0; i<self.compatibilyArray.count; i++) {
            CompatyQuestion* q=self.compatibilyArray[i];
            //选项
            if (comp.custom_id.intValue==11) {
                NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id memo:@(i+1).stringValue];
                q.items=comItem;
            }else{
                NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id];
                q.items=comItem;
            }
        }
        CompatyQuestion* q=self.compatibilyArray[0];
        NSMutableString *str=comp.title.mutableCopy;
        if (comp.custom_id.integerValue==11) {
            str=@"".mutableCopy;
            if (![self findDoneAnswerWithid:comp.info_id]) {
                QuestionAnswerC *a=[QuestionAnswerC new];
                a.customId=p.custom_id;
                a.subjectId=p.subject_id;
                a.nid=comp.info_id;
                a.outletId=comp.outlet_id;
                a.priority=@(self.currentQIndex+1).stringValue;
                [self addAnswer:a];
            }
        }
        if (comp.custom_id.intValue==10) {
            str=@"".mutableCopy;
            for (int i=0; i<q.items.count; i++) {
                CompatyItem* it=q.items[i];
                [str appendFormat:@"\n%@ %@",it.item_number,it.item_content];
            }
            if (![self findDoneAnswerWithid:comp.info_id]) {
                QuestionAnswerB *a=[QuestionAnswerB new];
                a.customId=p.custom_id;
                a.subjectId=p.subject_id;
                a.nid=comp.info_id;
                a.outletId=comp.outlet_id;
                a.priority=@(self.currentQIndex+1).stringValue;
                [self addAnswer:a];
            }

        }
        self.questionDes=str;
        
    }
    self.testLab.text=[[SQLManager sharedSingle] getQuestionTypeWithCustomId:p.custom_id];
    self.testLab.textAlignment=NSTextAlignmentCenter;
    
    [self.table reloadData];
    
    UITabBarItem*item5= [self.tabbar.items lastObject];
    UITabBarItem*item1= [self.tabbar.items firstObject];
    UITabBarItem*item2= [self.tabbar.items objectAtIndex:1];
    UITabBarItem*item3= [self.tabbar.items objectAtIndex:2];
    UITabBarItem*item4= [self.tabbar.items objectAtIndex:3];
    
    if (self.showAnswer) {
        [self showAnswer:item2];
    }
    
    [item4 setImage:[[UIImage imageNamed:@"favorate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"favorate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    if (self.paperid&&self.fromDetail==NO) {
        [item4 setImage:[[UIImage imageNamed:@"submit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item4 setSelectedImage:[[UIImage imageNamed:@"submit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item2 setImage:[[UIImage imageNamed:@"weizuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item2 setSelectedImage:[[UIImage imageNamed:@"weizuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        item2.title=@"查看未作";
        [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];

    }

    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
    
    [item3 setImage:[[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"setting"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    
    if (self.currentQIndex==self.questionsAr.count-1) {
        [item1 setImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [item5 setImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setSelectedImage:[[UIImage imageNamed:@"next"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        
    }else if (self.currentQIndex==0) {
        [item1 setImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        [item5 setImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setSelectedImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
    }else{
        [item5 setImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setSelectedImage:[[UIImage imageNamed:@"next_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [item1 setImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setSelectedImage:[[UIImage imageNamed:@"back_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
    }
    [self.view bringSubviewToFront:self.questionBtn];
    [self.table performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];

}

-(AnswerObj*)findDoneAnswerWithid:(NSString*)nid{
    AnswerObj *dest=nil;
    for (AnswerObj*ao in self.answerArray) {
        if (ao.nid.integerValue==nid.integerValue) {
            dest=ao;
            break;
        }
    }
    return dest;
}

-(void)addAnswer:(AnswerObj*)pAnswer{
//    AnswerObj *dest=nil;
//    for (AnswerObj*a in self.answerArray) {
//        if (a.nid.integerValue==pAnswer.nid.integerValue&&a.customId.integerValue==pAnswer.customId.integerValue) {
//            dest=a;
//            break;
//        }
//    }
//    
//    if (dest!=nil) {
//        [self.answerArray removeObject:dest];
//    }
    [self.answerArray addObject:pAnswer];
    
}

-(NSDictionary *)formatSubmitArg{
    Question* q=[self.questionsAr objectAtIndex:self.currentQIndex];
    
    NSMutableDictionary *json = @{}.mutableCopy;
    json[@"loginName"] = [Global sharedSingle].loginName;
    json[@"subjectId"] = q.subject_id;
    json[@"outlineId"] = self.outletid;
    json[@"amount"] = @(self.answerArray.count).stringValue;
    
    return [self addAccurateRateList:json];
}

-(NSDictionary*)addAccurateRateList:(NSMutableDictionary *)olderDic{
    
    NSInteger count=0;
    NSMutableArray *ar=[NSMutableArray array];
    for (AnswerObj*an in self.answerArray) {
        if (an.AnswerState.integerValue==1) {
            count++;
        }
        [ar addObject:[an toPracitsJson]];
    }
    float rate=(float)count/self.questionsAr.count;
    olderDic[@"accurateRate"]=[NSString stringWithFormat:@"%.2f",rate];
    olderDic[@"list"]=ar;
    return olderDic;
    
}

-(void)rightBtnClick:(UIButton *)sender{
    
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"token"] = @"add";
    
    //    PractiseVO *vo = [PractiseVO createWithItemVOs:self.items];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self formatSubmitArg] options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    params[@"json"] = jsonString;
    
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/userExerciseAct.htm" params:params CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.integerValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                if (aResponseObject[@"sql"]) {
                    [[SQLManager sharedSingle] excuseSql:aResponseObject[@"sql"]];
                }
                
                [[CachedAnswer new] deleteCacheOutlineid:self.outletid];//清缓存
                
                if ([aResponseObject[@"num"] integerValue]==0) {
                    [[OTSAlertView alertWithMessage:@"提交成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }] show];
                }else{
                    NSString *pointmsg=[NSString stringWithFormat:@"恭喜您获取了%@积分",aResponseObject[@"num"]];
                    [[OTSAlertView alertWithMessage:pointmsg andCompleteBlock:^(OTSAlertView *alert,NSInteger buttonindex){
                        [self.navigationController popViewControllerAnimated:YES];
                    }] show];
                }
                NSArray *sqlAr=aResponseObject[@"list"];
                if (sqlAr.count>0) {
                    for (int i=0; i<sqlAr.count; i++) {
                        [[SQLManager sharedSingle] excuseSql:sqlAr[i]];
                    }
                }
                NSString *maxid=[[SQLManager sharedSingle] getMaxidWithTableName:@"user_wrong_item" colName:@"id"];
                for (int i=maxid.intValue ;i<self.answerArray.count;i++) {
                    AnswerObj*an = self.answerArray[i];
                    if (an.AnswerState.integerValue==0) {
                        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
                        NSString *strDate = [dateFormatter1 stringFromDate:[NSDate date]];

                        NSString *wrongSql=[NSString stringWithFormat:@"INSERT INTO \'user_wrong_item\'(\'id\',\'item_id\',\'type_id\',\'user_id\',\'product_id\',\'add_time\',\'update_time\',\'cancel_time\',\'outline_id\',\'subject_id\',\'count\',\'is_valid\',\'description\',\'memo\') VALUES (%@,%@,%@,%@,%@,\'%@\',%@,%@,%@,%@,%@,%@,%@,%@);",@(i+1),an.nid,an.customId,[Global sharedSingle].userId,@1,strDate,@"NULL",@"NULL",an.outletId,an.subjectId,@1,@1,@"NULL",@"NULL"];
                        [[SQLManager sharedSingle] excuseSql:wrongSql];
                    }
                }
                [self getValueWithBeckUrl:@"/front/pointTransAct.htm" params:@{@"token":@"list",@"loginName":[Global sharedSingle].loginName} CompleteBlock:^(id aResponseObject, NSError *anError) {
                    STRONG_SELF;
                    [self hideLoading];
                    if (anError==nil) {
                        if ([aResponseObject[@"errorcode"] integerValue]==0) {
                                NSArray *ar=aResponseObject[@"list"];
                                for (NSString *sql in ar) {
                                    [[SQLManager sharedSingle] excuseSql:sql];
                                }
                        }
                    }
                }];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"提交失败" andCompleteBlock:nil] show];
        }
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    CompatyInfo *info;
    if (p.custom_id.integerValue==10||p.custom_id.integerValue==11) {
        info=(CompatyInfo*)p;
        if (info.memo!=nil&&info.memo.length>0) {
            return 30;
        }
        if (p.custom_id.integerValue==11) {
            return 0;
        }
    }
    
    CGSize size =[self.questionDes sizeWithFont:[UIFont systemFontOfSize:self.font] constrainedToSize:CGSizeMake(self.view.frame.size.width-100, 1000)];
    float h=0;
    if (size.height<50) {
        h=50;
    }else {
        h=size.height;
    }
    if (info.memo!=nil&&info.memo.length>0) {
        return h+45;
    }
    return h+15;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGSize size =[self.questionDes sizeWithFont:[UIFont systemFontOfSize:self.font] constrainedToSize:CGSizeMake(self.view.frame.size.width-100, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    float h=0;
    if (size.height<60) {
        h=60;
    }else {
        h=size.height;
    }
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-10, h)];
    
    la.textAlignment=NSTextAlignmentLeft;
    la.numberOfLines=0;
    la.font=[UIFont systemFontOfSize:self.font];
    la.text=self.questionDes;
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h+15)];
    v.backgroundColor=[UIColor lightGrayColor];
    [v addSubview:la];
    
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if (p.custom_id.integerValue==10||p.custom_id.integerValue==11) {
        CompatyInfo *info=(CompatyInfo*)p;
        if (info.memo!=nil&&info.memo.length>0) {
            UILabel *melb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
            melb.text=info.memo;
            [v addSubview:melb];
        }
    }
    return v;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        if (self.paperid&&self.fromDetail==NO) {
            return self.choiceArray.count;
        }
        return self.choiceArray.count+2;
    }else{
        if (self.paperid&&self.fromDetail==NO) {
            return self.compatibilyArray.count;
        }
        return self.compatibilyArray.count+2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Question *q=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([[self.questionsAr objectAtIndex:self.currentQIndex] isKindOfClass:[CompatyInfo class]]) {
        if (indexPath.row<self.compatibilyArray.count) {
            if (q.custom_id.intValue==11) {
                CompatyQuestion* comp=[self.compatibilyArray objectAtIndex:indexPath.row];
                return  48+40*comp.items.count;
            }
            return 88;
        }
    }
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        if (indexPath.row==self.choiceArray.count+1) {
            ChoiceQuestion* c=(ChoiceQuestion*)p;
            
            NSString *text=[c choice_parse];
            CGSize size =[text sizeWithFont:[UIFont systemFontOfSize:self.font] constrainedToSize:CGSizeMake(self.view.frame.size.width-100, 1000)];
            float h=0;
            if (size.height<60) {
                h=60;
            }else {
                h=size.height;
            }
            return h;
        }else if(indexPath.row==self.choiceArray.count){
            CGSize size =[self.currentNote.note sizeWithFont:[UIFont systemFontOfSize:self.font] constrainedToSize:CGSizeMake(self.view.frame.size.width-100, 1000)];
            
            return 44 +size.height+10;
        }
        
    }else if ([p isKindOfClass:[CompatyInfo class]]){
        if (indexPath.row==self.compatibilyArray.count+1) {
            NSMutableString *answer=@"".mutableCopy;
            for (int i=0; i<self.compatibilyArray.count; i++) {
                CompatyQuestion *q=self.compatibilyArray[i];
                [answer appendFormat:@"%d.%@",i+1,q.choice_parse];
            }
            CGSize size =[answer sizeWithFont:[UIFont systemFontOfSize:self.font] constrainedToSize:CGSizeMake(self.view.frame.size.width-100, 1000)];
            float h=0;
            if (size.height<60) {
                h=60;
            }else {
                h=size.height;
            }
            return h;
        }else if(indexPath.row==self.compatibilyArray.count){
            CGSize size =[self.currentNote.note sizeWithFont:[UIFont systemFontOfSize:self.font] constrainedToSize:CGSizeMake(self.view.frame.size.width-100, 1000)];

            return 44 +size.height+10;
        }
    }
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        ChoiceQuestion* c=(ChoiceQuestion*)p;
        if (indexPath.row==self.choiceArray.count+1) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"answercell" forIndexPath:indexPath];
            self.answerCell=cell;
            cell.textLabel.text=[c choice_parse];
            cell.textLabel.font=[UIFont systemFontOfSize:self.font];
            cell.textLabel.hidden=YES;
            cell.textLabel.numberOfLines=0;
            if (self.showAnswer) {
                cell.textLabel.hidden=NO;
            }
            cell.textLabel.backgroundColor=[UIColor orangeColor];
        }else if (indexPath.row==self.choiceArray.count) {
            self.notecell=(NoteCell*)[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
            if (self.fromDetail) {
                [self.notecell.noteBtn setTitle:@"查看笔记" forState:UIControlStateNormal];
            }else{
                [self.notecell.noteBtn setTitle:@"添加笔记" forState:UIControlStateNormal];
            }

            self.notecell.noteLab.text=self.currentNote.note;
            self.notecell.noteLab.hidden=YES;
            return self.notecell;
        }else{
            ChoiceCell* cell=(ChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"choicecell" forIndexPath:indexPath];
            cell.mark.image=nil;
            cell.lab.font=[UIFont systemFontOfSize:self.font];
            QuestionAnswerA*a =(QuestionAnswerA*)[self findDoneAnswerWithid:c.choice_id];
            [cell updateWithChoice:self.choiceArray[indexPath.row] questionAnswerA:a showAnswer:self.showAnswer];
            return cell;
            
        }
    }else{
        if (indexPath.row==self.compatibilyArray.count+1) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"answercell" forIndexPath:indexPath];
            self.answerCell=cell;
            NSMutableString *answer=@"".mutableCopy;
            for (int i=0; i<self.compatibilyArray.count; i++) {
                CompatyQuestion *q=self.compatibilyArray[i];
                [answer appendFormat:@"%d.%@",i+1,q.choice_parse];
            }
            cell.textLabel.text=answer;
            cell.textLabel.font=[UIFont systemFontOfSize:self.font];
            cell.textLabel.hidden=YES;
            if (self.showAnswer) {
                cell.textLabel.hidden=NO;
            }
            cell.textLabel.numberOfLines=0;
            cell.textLabel.backgroundColor=[UIColor orangeColor];
            
        }else if (indexPath.row==self.compatibilyArray.count) {
            self.notecell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
            if (self.fromDetail) {
                [self.notecell.noteBtn setTitle:@"查看笔记" forState:UIControlStateNormal];
            }else{
                [self.notecell.noteBtn setTitle:@"添加笔记" forState:UIControlStateNormal];
            }
            self.notecell.noteLab.text=self.currentNote.note;

            self.notecell.noteLab.hidden=YES;
            return self.notecell;
        }else{
            CompatyCell* cell=(CompatyCell* )[tableView dequeueReusableCellWithIdentifier:@"compatycell" forIndexPath:indexPath];
            cell.row=indexPath.row;

            CompatyInfo * info=(CompatyInfo*)p;
            cell.customid=info.custom_id.integerValue;
            CompatyQuestion *q=self.compatibilyArray[indexPath.row];
            AnswerObj*a =(QuestionAnswerA*)[self findDoneAnswerWithid:[info info_id]];
            cell.lab.font=[UIFont systemFontOfSize:self.font];
            cell.lab.text=[NSString stringWithFormat:@"%zd.%@",indexPath.row+1,q.choice_content];
            [cell updateCompatyCell:q customid:p.custom_id AnswerObj:a showAnswer:self.showAnswer selectedBlock:^(BOOL right, CompatyItem *answer) {
                if (self.fromDetail) {
                    return;
                }

                a.priority=@(self.currentQIndex+1).stringValue;
                if (right) {
                    p.answerType=answeredRight;
                    if (p.custom_id.integerValue==10) {
                        QuestionAnswerB *anb=(QuestionAnswerB*)a;
                        anb.AnswerState=@"1";

                    }else{
                        QuestionAnswerC *anb=(QuestionAnswerC*)a;
                        anb.AnswerState=@"1";

                    }
                }
                else{
                    p.answerType=answeredwrong;
                    if (p.custom_id.integerValue==10) {
                        QuestionAnswerB *anb=(QuestionAnswerB*)a;
                        anb.AnswerState=@"0";
                    }else{
                        QuestionAnswerC *anb=(QuestionAnswerC*)a;
                        anb.AnswerState=@"0";
                    }
                }
                
                [tableView reloadData];
                int cout=0;
                int r=0;
                if (p.custom_id.integerValue==10) {
                    QuestionAnswerB *anb=(QuestionAnswerB*)a;
                    for (QuestionItemB* b in anb.questionItemBs) {
                        if (b.AnswerState.integerValue==1) {
                            r++;
                        }
                        if (b.myAnswer!=nil) {
                            cout++;
                        }
                    }
                }else{
                    QuestionAnswerC *anb=(QuestionAnswerC*)a;
                    for (QuestionItemC* b in anb.questionCItems) {
                        if (b.AnswerState.integerValue==1) {
                            r++;
                        }
                        if (b.myAnswer!=nil) {
                            cout++;
                        }
                    }
                }
                if (self.practisMode&&!self.fromDetail) {
                    if (cout==self.compatibilyArray.count) {
                        if (r==self.compatibilyArray.count) {
                            [self showAnswer:self.tabbar.items[2]];
                            [self performSelector:@selector(forwardPress:) withObject:nil afterDelay:1];
                        }else{
                            if (self.showAnswer==NO&&self.practisMode&&answer) {
                                [self showAnswer:self.tabbar.items[2]];
                            }
                        }
                    }
                }
                if (self.paperid!=nil&&cout==self.compatibilyArray.count) {
//                    [self performSelector:@selector(forwardPress:) withObject:nil];
                }

            }];
            
//            [cell updateCompatyCell:q  customid:p.custom_id answer:self.answerArray[indexPath.row] showAnswer:self.showAnswer selectedBlock:^(BOOL right,CompatyItem *answer) {
//                if (right) {
//                    p.answerType=answeredRight;
//                }else{
//                    p.answerType=answeredwrong;
//                }
//                [tableView reloadData];
//            }];
            
            
            return cell;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.fromDetail) {
        return;
    }
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]&&indexPath.row<self.choiceArray.count) {
        ChoiceQuestion *q=(ChoiceQuestion*)p;
        ChoiceItem *item=q.choiceItems[indexPath.row];
        QuestionAnswerA*choiceAnswer=(QuestionAnswerA*)[self findDoneAnswerWithid:q.choice_id];
        choiceAnswer.priority=@(self.currentQIndex+1).stringValue;
        

      
//
//        
        if ([p custom_id].intValue!=12) {
            [choiceAnswer.myAnswer removeAllObjects];
            [choiceAnswer.myAnswer addObject:item.nid];
        }else{
            NSString *dest=nil;
            for (NSString *it in choiceAnswer.myAnswer) {
                if (it.integerValue==item.nid.integerValue) {
                    dest=it;
                }
            }
            if (dest) {
                [choiceAnswer.myAnswer removeObject:dest];
            }else{
                [choiceAnswer.myAnswer addObject:item.nid];
            }
        }
        
        
        if (self.paperid==nil) {//练习模式
            if (![q.rightChoiceItems containsObject:item.nid]) {
                choiceAnswer.AnswerState=@"0";
                p.answerType=answeredwrong;
                if (self.showAnswer==NO&&self.practisMode) {
                    [self showAnswer:self.tabbar.items[2]];
                }
            }else{
                choiceAnswer.AnswerState=@"1";
                p.answerType=answeredRight;
                if (q.rightChoiceItems.count==1) {
                    [self showAnswer:self.tabbar.items[2]];
                    [self performSelector:@selector(forwardPress:) withObject:nil afterDelay:1];
                    return;
                }
                if (choiceAnswer.myAnswer.count==q.rightChoiceItems.count) {
                    int cout=0;
                    for (NSString *a in choiceAnswer.myAnswer) {
                        if ([q.rightChoiceItems containsObject:a]) {
                            cout++;
                        }
                    }
                    if (cout==q.rightChoiceItems.count) {
                        [self showAnswer:self.tabbar.items[2]];
//                        [self performSelector:@selector(forwardPress:) withObject:nil afterDelay:1];
                    }
                }
            }
        }
        else{//考试模式
            if ([p custom_id].intValue!=12) {
                [self performSelector:@selector(forwardPress:) withObject:nil];
            }else{
                if (choiceAnswer.myAnswer.count==q.rightChoiceItems.count) {
                    [self showAnswer:self.tabbar.items[2]];
//                    [self performSelector:@selector(forwardPress:) withObject:nil];
                }
            }
        }
        
        
        
    }
    [self.table reloadData];
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            [self backwardPress:item];
            break;
        case 1:
            [self showAnswer:item];
            break;
        case 2:
            [self showSetting:item];
            break;
        case 3:
            if (self.paperid) {
                if (!self.fromDetail) {
                    [self submit:item];
                }
            }
            if (self.outletid) {
                if (!self.fromDetail) {
                    [self addFaver:item];
                }
            }
            break;
        case 4:
            [self forwardPress:item];
            break;
        default:
            break;
    }
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
}
-(IBAction)notePress{
   __block NSString *titid=nil;
   __block Question *q=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([q isKindOfClass:[ChoiceQuestion class]]) {
        titid=[(ChoiceQuestion*)q choice_id];
    }else{
        titid=[(CompatyInfo*)q info_id];
    }
    
    CXAlertView *av=[[CXAlertView alloc] initWithTitle:@"添加笔记" message:@"" cancelButtonTitle:@"取消"];
    UITextView*textView_onAlertView = [[UITextView alloc]initWithFrame:CGRectMake(12, 0, 260, 100)];
    
    textView_onAlertView.delegate = self ;
    textView_onAlertView.layer.borderWidth = 1.0f;
    textView_onAlertView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    textView_onAlertView.layer.cornerRadius = 2;
    textView_onAlertView.clipsToBounds = YES ;
    textView_onAlertView.returnKeyType=UIReturnKeyDone;
    textView_onAlertView.autocorrectionType = UITextAutocorrectionTypeNo ;
    textView_onAlertView.autocapitalizationType = UITextAutocapitalizationTypeSentences ;
    textView_onAlertView.font = [UIFont systemFontOfSize:14];
    av.contentView=textView_onAlertView;
    self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:q.custom_id];
    if (self.currentNote!=nil&&self.currentNote.note.length>0) {
        textView_onAlertView.text=self.currentNote.note;
    }
    [av show];
    [av addButtonWithTitle:@"添加" type:CXAlertViewButtonTypeDefault handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
        if (textView_onAlertView.text==nil||textView_onAlertView.text.length==0) {
            return ;
        }
        
        [alertView dismiss];
        NSMutableDictionary *json = @{}.mutableCopy;
        
        //尼玛的又成了题目id，晕菜
        
        if ([q isKindOfClass:[ChoiceQuestion class]]) {
            ChoiceQuestion *p=(ChoiceQuestion*)q;
            json[@"titleId"]=@([p choice_id].intValue);
        }else{
            CompatyInfo *c=(CompatyInfo*)q;
            json[@"titleId"]=@(c.info_id.intValue);
        }
        json[@"typeId"]=@([q custom_id].intValue);
        json[@"loginName"] = [Global sharedSingle].loginName;
        json[@"subjectId"] = @([[self.questionsAr objectAtIndex:self.currentQIndex] subject_id].intValue);
        json[@"outlineId"] =@( self.outletid.intValue);
        json[@"note"]=textView_onAlertView.text;
        
        
        self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:q.custom_id];
        
        if (self.currentNote!=nil&&self.currentNote.note.length) {
            json[@"type"]=@1;//0：添加 1：更新
        }else{
            json[@"type"]=@0;//0：添加 1：更新
        }
        
        NSData*d=[NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
        NSString *s=[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        WEAK_SELF;
        [self showLoading];
        [self getValueWithBeckUrl:@"/front/userNoteAct.htm" params:@{@"token":@"addUpdate",@"json":s} CompleteBlock:^(id aResponseObject, NSError *anError) {
            STRONG_SELF;
            [self hideLoading];
            if (anError==nil) {
                if ([aResponseObject[@"errorcode"] integerValue]==0) {
                    for (NSString *sql in aResponseObject[@"list"]) {
                        [[SQLManager sharedSingle] excuseSql:sql];
                    }
                    [self showLoadingWithMessage:@"添加成功" hideAfter:2];
                    if ([json[@"type"] integerValue]==0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDB" object:nil];
                    }else{
                        NSString *sql=[NSString stringWithFormat:@"UPDATE user_note SET note ==\'%@\' WHERE item_id ==%@ and user_id==%@",textView_onAlertView.text,self.currentNote.item_id,[Global sharedSingle].userBean[@"userId"]];
                        [[SQLManager sharedSingle] excuseSql:sql];
                    }
                    self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:q.custom_id];
                    
                }else{
                    [self showLoadingWithMessage:@"添加失败" hideAfter:2];
                    
                }
            }else{
                [self showLoadingWithMessage:@"添加失败" hideAfter:2];
                
            }
        }];
    }
    ];
    /*
    OTSAlertView*alert=[OTSAlertView alertWithTitle:@"添加笔记" message:nil leftBtn:@"取消" rightBtn:@"添加" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length==0) {
                return ;
            }
            NSMutableDictionary *json = @{}.mutableCopy;
            
            //尼玛的又成了题目id，晕菜
            
            if ([q isKindOfClass:[ChoiceQuestion class]]) {
                ChoiceQuestion *p=(ChoiceQuestion*)q;
                json[@"titleId"]=@([p choice_id].intValue);
            }else{
                CompatyInfo *c=(CompatyInfo*)q;
                json[@"titleId"]=@(c.info_id.intValue);
            }
            json[@"typeId"]=@([q custom_id].intValue);
            json[@"loginName"] = [Global sharedSingle].loginName;
            json[@"subjectId"] = @([[self.questionsAr objectAtIndex:self.currentQIndex] subject_id].intValue);
            json[@"outlineId"] =@( self.outletid.intValue);
            json[@"note"]=tf.text;
            
            
            self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:q.custom_id];
            
            if (self.currentNote!=nil&&self.currentNote.note.length) {
                json[@"type"]=@1;//0：添加 1：更新
            }else{
                json[@"type"]=@0;//0：添加 1：更新
            }
            
            NSData*d=[NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString *s=[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            WEAK_SELF;
            [self showLoading];
            [self getValueWithBeckUrl:@"/front/userNoteAct.htm" params:@{@"token":@"addUpdate",@"json":s} CompleteBlock:^(id aResponseObject, NSError *anError) {
                STRONG_SELF;
                [self hideLoading];
                if (anError==nil) {
                    if ([aResponseObject[@"errorcode"] integerValue]==0) {
                        for (NSString *sql in aResponseObject[@"list"]) {
                            [[SQLManager sharedSingle] excuseSql:sql];
                        }
                        [self showLoadingWithMessage:@"添加成功" hideAfter:2];
                        if ([json[@"type"] integerValue]==0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDB" object:nil];
                        }else{
                            NSString *sql=[NSString stringWithFormat:@"UPDATE user_note SET note ==\'%@\' WHERE item_id ==%@ and user_id==%@",tf.text,self.currentNote.item_id,[Global sharedSingle].userBean[@"userId"]];
                            [[SQLManager sharedSingle] excuseSql:sql];
                        }
                        self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:q.custom_id];
                        
                    }else{
                        [self showLoadingWithMessage:@"添加失败" hideAfter:2];
                        
                    }
                }else{
                    [self showLoadingWithMessage:@"添加失败" hideAfter:2];
                    
                }
            }];
        }
    }] ;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];
    
    self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:q.custom_id];
    if (self.currentNote!=nil&&self.currentNote.note.length>0) {
        UITextField *tf=[alert textFieldAtIndex:0];
        tf.text=self.currentNote.note;
    }*/
}

-(void)showAnswer:(UITabBarItem *)item{
    //    self.answerCell.textLabel.hidden=!self.answerCell.textLabel.hidden;
    if (self.practisMode) {
        self.showAnswer=!self.showAnswer;
        if (!self.showAnswer) {
            [item setImage:[[UIImage imageNamed:@"answer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setSelectedImage:[[UIImage imageNamed:@"answer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        }else{
            [item setImage:[[UIImage imageNamed:@"answer_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setSelectedImage:[[UIImage imageNamed:@"answer_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        }
    }else{
        if (!self.fromDetail) {
            [self progressPress:nil];
        }else{
            self.showAnswer=!self.showAnswer;
        }
    }
    [self.table reloadData];
}
-(void)submit:(UITabBarItem *)item{
    if (self.showAnswer) {
        return;
    }
    
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"token"] = @"add";
    
    NSMutableDictionary *dic=@{}.mutableCopy;
    dic[@"loginName"] = [Global sharedSingle].loginName;
    dic[@"paperId"] = self.paperid;

    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter1 setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *strDate1 = [dateFormatter1 stringFromDate:self.beginTime];
    dic[@"beginTime"] = strDate1;
    
    NSDate *finishDate=[NSDate date];
    NSString *strDate = [dateFormatter1 stringFromDate:finishDate];
    dic[@"endTime"]=strDate;

    
    NSInteger count=0;
    NSInteger wrongCount=0;
    NSInteger score=0;
    NSMutableArray *ar=[NSMutableArray array];
    for (Question*q in self.questionsAr) {
        if (q.answerType==answeredRight) {
            count++;
            score+=q.examScore.integerValue;
        }else{
            wrongCount++;
        }
        AnswerObj*an=nil;
        if (q.custom_id.integerValue==10||q.custom_id.integerValue==11) {
            CompatyInfo *c=(CompatyInfo*)q;
            an=[self findDoneAnswerWithid:c.info_id];
        }else{
            ChoiceQuestion *c=(ChoiceQuestion*)q;
            an=[self findDoneAnswerWithid:c.choice_id];
        }
        if (an) {
            [ar addObject:[an toDictionary]];
        }
    }
    dic[@"rightAmount"]=[NSString stringWithFormat:@"%zd",count];
    ExamPaper*paper= [[SQLManager sharedSingle] getExamPaperByPaperid:self.paperid];
    dic[@"wrongAmount"]=[NSString stringWithFormat:@"%zd",paper.total_amount.integerValue-count];
    dic[@"score"]=[NSString stringWithFormat:@"%zd",score];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ar options:kNilOptions error:&error];
    NSString *answerString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    dic[@"userAnswer"]=answerString;
    
    NSData *jsonData1 = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData1 encoding:NSUTF8StringEncoding];
    
    params[@"json"] = jsonString;
    
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/userExamAct.htm" params:params CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.integerValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                if (aResponseObject[@"examSql"]) {
                    [[SQLManager sharedSingle] excuseSql:aResponseObject[@"examSql"]];
                }
                if (aResponseObject[@"sql"]) {
                    [[SQLManager sharedSingle] excuseSql:aResponseObject[@"sql"]];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDB" object:nil];
                [[OTSAlertView alertWithMessage:@"提交成功" andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"pan" bundle:[NSBundle mainBundle]];
                    FinishExamVC*vc=[sb instantiateViewControllerWithIdentifier:@"FinishExamVC"];
                    vc.paper=self.examComp;
                    vc.examTitle=self.examComp.paper_name;
                    vc.wrong=[NSString stringWithFormat:@"%zd",self.examComp.total_amount.integerValue-score];
                    vc.right=[NSString stringWithFormat:@"%zd",score];
                    vc.time=self.examComp.answer_time;
                    
                    int t=(int)ceil([finishDate timeIntervalSinceDate:self.beginTime]/60);
                    vc.cost=[NSString stringWithFormat:@"%d",t];
                    vc.point=[NSString stringWithFormat:@"%@",aResponseObject[@"num"]];
                    vc.paperid=self.paperid;
                    UINavigationController *nv=[[UINavigationController alloc] initWithRootViewController:vc];
                    nv.navigationBar.tintColor=BeckRed;
                    [self presentViewController:nv animated:YES completion:nil];
                    //                    [self.navigationController popViewControllerAnimated:YES];
                }] show];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"提交失败" andCompleteBlock:nil] show];
        }
        [self hideLoading];
    }];
    
}

-(void)addFaver:(UITabBarItem *)item{
    [self showLoading];
    
    NSMutableDictionary *param=@{}.mutableCopy;
    Question *q=[self.questionsAr objectAtIndex:self.currentQIndex];
    //尼玛的又成了题目id，晕菜
    if ([q isKindOfClass:[ChoiceQuestion class]]) {
        ChoiceQuestion *p=(ChoiceQuestion*)q;
        param[@"titleId"]=[p choice_id];
    }else{
        CompatyInfo *c=(CompatyInfo*)q;
        param[@"titleId"]=c.info_id;
    }
    param[@"outlineId"]=self.outletid;
    param[@"loginName"]=[Global sharedSingle].loginName;
    param[@"typeId"]=[q custom_id];
    param[@"subjectId"]=[q subject_id];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:param options:0 error:nil];
    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/userCollectionAct.htm" params:@{@"token":@"add",@"json":str} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] intValue]==0) {
                [item setImage:[[UIImage imageNamed:@"favorate_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [item setSelectedImage:[[UIImage imageNamed:@"favorate_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
                
                [self showLoadingWithMessage:@"收藏成功" hideAfter:2];
                [[SQLManager sharedSingle] excuseSql:aResponseObject[@"sql"]];
                
            }else if ([aResponseObject[@"errorcode"] intValue]==2){
                [item setImage:[[UIImage imageNamed:@"favorate_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [item setSelectedImage:[[UIImage imageNamed:@"favorate_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
                [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
                [self showLoadingWithMessage:@"已经收藏" hideAfter:2];
            }else {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
        }else{
            [[OTSAlertView alertWithMessage:@"收藏失败" andCompleteBlock:nil] show];
        }
        
    }];
}

-(void)showSetting:(UITabBarItem *)item{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"pan" bundle:[NSBundle mainBundle]];
    self.settingPanVC = [sb instantiateViewControllerWithIdentifier:@"settingPanVC"];
    [self.view addSubview:self.settingPanVC.view];
    
}

-(void)backwardPress:(UITabBarItem *)item{
    if (self.currentQIndex==0) {
        
        return;
    }
    
    
    if (self.currentQIndex>0) {
        self.currentQIndex--;
    }
    
    [self freshView];
    [self.table.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromLeft curve:TransitionCurveEaseInEaseOut duration:1.0f];

}

-(void)forwardPress:(UITabBarItem *)item{
    if (self.currentQIndex==self.questionsAr.count-1) {
        return;
    }
    
    if (self.currentQIndex<self.questionsAr.count) {
        self.currentQIndex++;
    }
    [self freshView];
    [self.table.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseInEaseOut duration:1.0f];

}


-(IBAction)progressPress:(id)sender{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
    QCollectionVC *vc=[sb instantiateViewControllerWithIdentifier:@"QCollectionVC"];
    vc.vcDelegate=self;
    vc.questions=self.questionsAr;
    if (!self.practisMode) {
        vc.fromExam=YES;
    }
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toprogress"]) {
        QCollectionVC *vc=segue.destinationViewController;
        vc.vcDelegate=self;
        vc.questions=self.questionsAr;
        
    }
}

@end
