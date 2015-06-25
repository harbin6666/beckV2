//
//  NoteDetailVC.m
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "NoteDetailVC.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
#import "ChoiceCell.h"
#import "CompatyCell.h"
#import "QCollectionVC.h"
#import "PractisAnswer.h"
#import "SettingPanVC.h"

@interface NoteDetailVC ()
@property(nonatomic,weak) IBOutlet UILabel *testLab;
@property(nonatomic,assign)NSInteger currentQIndex;
@property(nonatomic,weak) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *choiceArray;//选择题选项数组
@property(nonatomic,strong)NSArray *compatibilyArray;//配伍题数组
@property(nonatomic,weak)IBOutlet UITabBar* tabbar;
@property(nonatomic,weak)UITableViewCell *answerCell;
@property(nonatomic,strong)NSMutableArray *answerArray;
@property(nonatomic,strong)PractisAnswer* answer;
@property(nonatomic,assign)BOOL showAnswer;
@property(nonatomic,strong)NSString *currentNote;
@property (nonatomic, strong) SettingPanVC *settingPanVC;
@property(nonatomic,strong)NSString *questionDes;

@end

@implementation NoteDetailVC

- (void)didSelectedItemIndexInAnswerCVC:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];
    self.currentQIndex=index;
    [self freshView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showAnswer=NO;
    
    self.currentQIndex=0;
    
    if (self.answerArray==nil) {
        self.answerArray=[[NSMutableArray alloc] init];
    }else{
        __block PractisAnswer *temp=nil;
        [self.answerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PractisAnswer *an=(PractisAnswer *)obj;
            if (an.priority.integerValue>temp.priority.integerValue) {
                temp=an;
            }
        }];
        NSString *s=[NSString stringWithFormat:@"上次练习到%@题，是否继续",temp.priority];
        [[OTSAlertView alertWithTitle:@"" message:s leftBtn:@"取消" rightBtn:@"继续" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex==0) {
                
            }else{
                self.currentQIndex=temp.priority.integerValue-1;
                [self freshView];
            }
            
        }] show];
    }
    [self freshView];
    
}

-(void)freshView{
    self.title=[NSString stringWithFormat:@"%zd/%zd",self.currentQIndex+1,self.questionsAr.count];
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    BOOL containAnswer=NO;
    NSString *titid=nil;
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        titid=[(ChoiceQuestion*)p choice_id];
        
    }else{
        titid=[(CompatyInfo*)p info_id];
    }

    self.currentNote=[[SQLManager sharedSingle] findNoteByItemId:titid customId:p.custom_id];

    for (PractisAnswer* an in self.answerArray) {
        
        if (an.titleId.integerValue==titid.integerValue&&an.titleTypeId.integerValue==p.custom_id.integerValue) {
            self.answer=an;
            containAnswer=YES;
            break;
        }
    }
    
    if (containAnswer) {
    }else{
        self.answer=nil;
        self.answer=[PractisAnswer new];
        self.answer.priority=[NSString stringWithFormat:@"%zd", self.currentQIndex+1];
        self.answer.titleTypeId=p.custom_id;
        if ([p isKindOfClass:[ChoiceQuestion class]]) {
            self.answer.titleId=[(ChoiceQuestion*)p choice_id];
        }else{
            self.answer.titleId=[(CompatyInfo*)p info_id];
        }
        [self addAnswer:self.answer];
    }
    
    
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
        self.choiceArray=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];
        
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
        }
        if (comp.custom_id.intValue!=11) {
            for (int i=0; i<q.items.count; i++) {
                CompatyItem* it=q.items[i];
                [str appendFormat:@"\n%@ %@",it.item_number,it.item_content];
            }
            
        }
        self.questionDes=str;
    }
    self.testLab.text=[[SQLManager sharedSingle] getQuestionTypeWithCustomId:p.custom_id];
    self.testLab.textAlignment=NSTextAlignmentCenter;

    [self.table reloadData];
    
    UITabBarItem*item5= [self.tabbar.items lastObject];
    UITabBarItem*item1= [self.tabbar.items firstObject];
    
    UITabBarItem*item3= [self.tabbar.items objectAtIndex:2];
    UITabBarItem*item4= [self.tabbar.items objectAtIndex:3];
    
    
    [item4 setImage:[[UIImage imageNamed:@"favorate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"favorate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
}


-(void)addAnswer:(PractisAnswer*)pAnswer{
    PractisAnswer *dest=nil;
    for (PractisAnswer*a in self.answerArray) {
        if (a.titleId.integerValue==pAnswer.titleId.integerValue&&a.titleTypeId.integerValue==pAnswer.titleTypeId.integerValue) {
            dest=a;
            break;
        }
    }
    
    if (dest!=nil) {
        [self.answerArray removeObject:dest];
    }
    [self.answerArray addObject:pAnswer];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if (p.custom_id.integerValue==11) {
        return 0;
    }
    CGSize size =[self.questionDes sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 1000)];
    float h=0;
    if (size.height<50) {
        h=50;
    }else {
        h=size.height;
    }
    
    return h+15;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGSize size =[self.questionDes sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 1000)];
    float h=0;
    if (size.height<50) {
        h=50;
    }else {
        h=size.height;
    }
    UILabel *la=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, h)];

    la.textAlignment=NSTextAlignmentCenter;
    la.numberOfLines=0;
    la.font=[UIFont systemFontOfSize:14];
    la.text=self.questionDes;
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h+15)];
    v.backgroundColor=[UIColor lightGrayColor];
    [v addSubview:la];
    return v;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        return self.choiceArray.count+2;
    }else{
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
            cell.textLabel.hidden=YES;
            if (self.showAnswer) {
                cell.textLabel.hidden=NO;
            }
            cell.textLabel.backgroundColor=[UIColor orangeColor];
        }else if (indexPath.row==self.choiceArray.count) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
        }else{
            ChoiceCell* cell=(ChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"choicecell" forIndexPath:indexPath];
            cell.mark.image=nil;
            
            [cell updateWithChoice:self.choiceArray[indexPath.row] answer:self.answer showAnswer:self.showAnswer];
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
            cell.textLabel.hidden=YES;
            if (self.showAnswer) {
                cell.textLabel.hidden=NO;
            }
            
            cell.textLabel.backgroundColor=[UIColor orangeColor];
            
        }else if (indexPath.row==self.compatibilyArray.count) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
        }else{
            CompatyCell* cell=(CompatyCell* )[tableView dequeueReusableCellWithIdentifier:@"compatycell" forIndexPath:indexPath];
            cell.row=indexPath.row;
            CompatyQuestion *q=self.compatibilyArray[indexPath.row];
            [cell updateCompatyCell:q  customid:p.custom_id answer:self.answer showAnswer:self.showAnswer selectedBlock:^(BOOL right,CompatyItem *answer) {
                if (right) {
                    p.answerType=answeredRight;
                }else{
                    p.answerType=answeredwrong;
                }
                [tableView reloadData];
            }];
            
            
            return cell;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Question* p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]&&indexPath.row<self.choiceArray.count) {
        ChoiceQuestion *q=(ChoiceQuestion*)p;
        ChoiceItem *item=q.choiceItems[indexPath.row];
        //        self.answer.priority=@(self.currentQIndex+1).stringValue;
        
        //显示答案
        if (item.is_answer.integerValue==0) {
            self.answer.isRight=@"false";
            p.answerType=answeredwrong;
        }else {
            self.answer.isRight=@"true";
            p.answerType=answeredRight;
            
        }
        
        
        if ([p custom_id].intValue!=12) {
            [self.answer.userAnswer removeAllObjects];
            [self.answer.userAnswer addObject:item];
            
        }else{
            ChoiceItem *dest=nil;
            for (ChoiceItem*it in self.answer.userAnswer) {
                if (it.nid.integerValue==item.nid.integerValue) {
                    dest=it;
                }
            }
            if (dest) {
                [self.answer.userAnswer removeObject:dest];
            }else {
                [self.answer.userAnswer addObject:item];
            }
        }
    }
    [tableView reloadData];
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
            [self addFaver:item];
            break;
        case 4:
            [self forwardPress:item];
            break;
        default:
            break;
    }
}

-(IBAction)notePress{
    OTSAlertView*alert=[OTSAlertView alertWithTitle:@"添加笔记" message:nil leftBtn:@"取消" rightBtn:@"添加" extraData:nil andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex==1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            if (tf.text.length==0) {
                return ;
            }
            NSMutableDictionary *json = @{}.mutableCopy;
            
            Question *q=[self.questionsAr objectAtIndex:self.currentQIndex];
            //尼玛的又成了题目id，晕菜
            NSString*titid=nil;

            if ([q isKindOfClass:[ChoiceQuestion class]]) {
                ChoiceQuestion *p=(ChoiceQuestion*)q;
                titid=p.choice_id;
                json[@"titleId"]=@([p choice_id].intValue);
            }else{
                CompatyQuestion *c=(CompatyQuestion*)q;
                json[@"titleId"]=@(c.compatibility_id.intValue);
                titid=c.compatibility_id;
            }
            json[@"typeId"]=@([q custom_id].intValue);
            json[@"loginName"] = [Global sharedSingle].loginName;
            json[@"subjectId"] = @([[self.questionsAr objectAtIndex:self.currentQIndex] subject_id].intValue);
            json[@"outlineId"] =@( self.outletid.intValue);
            json[@"note"]=tf.text;
            if (self.currentNote!=nil&&self.currentNote.length) {
                json[@"type"]=@1;//0：添加 1：更新
            }else{
                json[@"type"]=@0;//0：添加 1：更新
            }
            
            NSData*d=[NSJSONSerialization dataWithJSONObject:json options:0 error:nil];
            NSString *s=[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
            WEAK_SELF;
            [self getValueWithBeckUrl:@"/front/userNoteAct.htm" params:@{@"token":@"addUpdate",@"json":s} CompleteBlock:^(id aResponseObject, NSError *anError) {
                STRONG_SELF;
                if (anError==nil) {
                    if ([aResponseObject[@"errorcode"] integerValue]==0) {
                        [self showLoadingWithMessage:@"添加成功" hideAfter:2];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDB" object:nil];
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
    if (self.currentNote!=nil&&self.currentNote.length>0) {
        UITextField *tf=[alert textFieldAtIndex:0];
        tf.text=self.currentNote;
    }
}

-(void)showAnswer:(UITabBarItem *)item{
    //    self.answerCell.textLabel.hidden=!self.answerCell.textLabel.hidden;
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
    [self.table reloadData];
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
        CompatyQuestion *c=(CompatyQuestion*)q;
        param[@"titleId"]=c.compatibility_id;
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
}

-(void)forwardPress:(UITabBarItem *)item{
    if (self.currentQIndex==self.questionsAr.count-1) {
        return;
    }
    
    if (self.currentQIndex<self.questionsAr.count) {
        self.currentQIndex++;
    }
    [self freshView];
}
@end
