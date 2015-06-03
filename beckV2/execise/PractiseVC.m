//
//  PractiseVC.m
//  beckV2
//
//  Created by yj on 15/6/1.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PractiseVC.h"
#import "ChoiceQuestion.h"
#import "CompatyQuestion.h"
#import "ChoiceCell.h"
#import "CompatyCell.h"
#import "QCollectionVC.h"
@interface PractiseVC ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,QCollectionVCDelegate>
@property(nonatomic,strong)NSArray *questionsAr;
@property(nonatomic,weak) IBOutlet UILabel *testLab;
@property(nonatomic,assign)NSInteger currentQIndex;
@property(nonatomic,weak) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *choiceArray;//选择题选项数组
@property(nonatomic,strong)NSArray *compatibilyArray;//配伍题数组
@property(nonatomic,weak) IBOutlet UIButton *questionBtn;
@property(nonatomic,weak)IBOutlet UITabBar* tabbar;
@property(nonatomic,weak)UITableViewCell *answerCell;
@end

@implementation PractiseVC

- (void)didSelectedItemIndexInAnswerCVC:(NSInteger)index{
    [self.navigationController popViewControllerAnimated:YES];

    self.currentQIndex=index;
    [self freshView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarButtonName:@"提交" width:40 isLeft:NO];
    [self setNavigationBarButtonName:@"返回" width:40 isLeft:YES];

    self.questionsAr=[[SQLManager sharedSingle] getQuestionByOutlineId:self.outletid];
    self.currentQIndex=0;
    [self freshView];
}

-(void)leftBtnClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)freshView{
    self.title=[NSString stringWithFormat:@"%zd/%zd",self.currentQIndex+1,self.questionsAr.count];
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
        if ([p isKindOfClass:[ChoiceQuestion class]]) {
            self.table.allowsSelection=YES;
            ChoiceQuestion* q=(ChoiceQuestion*)p;
            self.testLab.text= q.choice_content;
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
                NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id];
                q.items=comItem;
            }
            CompatyQuestion* q=self.compatibilyArray[0];
            NSMutableString *str=comp.title.mutableCopy;
            for (int i=0; i<q.items.count; i++) {
                CompatyItem* it=q.items[i];
                [str appendFormat:@"\n%@ %@",it.item_number,it.item_content];
            }
            self.testLab.text=str;

        }
    
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
    [self.view bringSubviewToFront:self.questionBtn];
}

-(void)rightBtnClick:(UIButton *)sender{
    [self showLoading];
    NSMutableDictionary *params = @{}.mutableCopy;
    params[@"token"] = @"add";
    
//    PractiseVO *vo = [PractiseVO createWithItemVOs:self.items];
    
    NSMutableDictionary *json = @{}.mutableCopy;
//    json[@"loginName"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginName"];
//    json[@"subjectId"] = self.subjectId;
//    json[@"outlineId"] = self.examOutlineId;
//    json[@"amount"] = vo.getAmount;
//    json[@"accurateRate"] = vo.getAccurateRate;
//    json[@"list"] = vo.getAnswerList;
//    json[@"score"] = vo.getScore;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    params[@"json"] = jsonString;
    
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/userExerciseAct.htm" params:params CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.boolValue) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"提交失败" andCompleteBlock:nil] show];
        }
    }];

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
    if ([[self.questionsAr objectAtIndex:self.currentQIndex] isKindOfClass:[CompatyInfo class]]) {
        if (indexPath.row<self.compatibilyArray.count) {
            return 88;
        }
    }
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        if (indexPath.row==self.choiceArray.count+1) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"answercell" forIndexPath:indexPath];
            self.answerCell=cell;
            cell.textLabel.text=[p choice_parse];
            cell.textLabel.hidden=YES;
            cell.textLabel.backgroundColor=[UIColor orangeColor];
        }else if (indexPath.row==self.choiceArray.count) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
        }else{
           ChoiceCell* cell=(ChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"choicecell" forIndexPath:indexPath];
            [cell updateWithChoice:self.choiceArray[indexPath.row]];
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
            cell.textLabel.backgroundColor=[UIColor orangeColor];

        }else if (indexPath.row==self.compatibilyArray.count) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
        }else{
           CompatyCell* cell=(CompatyCell* )[tableView dequeueReusableCellWithIdentifier:@"compatycell" forIndexPath:indexPath];
            cell.row=indexPath.row;
            CompatyQuestion *q=self.compatibilyArray[indexPath.row];
            [cell updateCompatyCell:q selectedBlock:^(BOOL right) {
                
            }];
            return cell;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]&&indexPath.row<self.choiceArray.count) {
        ChoiceQuestion *q=(ChoiceQuestion*)p;
        ChoiceItem *item=q.choiceItems[indexPath.row];
        if (item.is_answer.integerValue==0) {
            for (int i=0;i<q.choiceItems.count;i++) {
                ChoiceItem *item=q.choiceItems[i];
                ChoiceCell *cell=(ChoiceCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                if (item.is_answer.integerValue==1) {
                    cell.mark.image=[UIImage imageNamed:@"choiceRight"];
                    cell.contentView.layer.borderColor=[UIColor greenColor].CGColor;
                    cell.contentView.layer.borderWidth=1;
                }else{
                    cell.mark.image=nil;
                    cell.contentView.layer.borderColor=[UIColor clearColor].CGColor;
                }
            }
            ChoiceCell *cell=(ChoiceCell*)[tableView cellForRowAtIndexPath:indexPath];
            cell.mark.image=[UIImage imageNamed:@"choiceWrong"];
        }else {
            for (int i=0;i<q.choiceItems.count;i++) {
                ChoiceCell *cell=(ChoiceCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                cell.mark.image=nil;
                cell.contentView.layer.borderColor=[UIColor clearColor].CGColor;

            }
        }
    }
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
    
}

-(void)showAnswer:(UITabBarItem *)item{
    self.answerCell.textLabel.hidden=!self.answerCell.textLabel.hidden;
    if (self.answerCell.textLabel.hidden) {
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
}

-(void)addFaver:(UITabBarItem *)item{
    [self showLoading];
    
    NSMutableDictionary *param=@{}.mutableCopy;
    param[@"outlineid"]=self.outletid;
    param[@"loginName"]=[Global sharedSingle].loginName;
    Question *q=[self.questionsAr objectAtIndex:self.currentQIndex];
    param[@"typeid"]=[q custom_id];
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
            }else if ([aResponseObject[@"errorcode"] intValue]==2){
                [self showLoadingWithMessage:@"已经收藏" hideAfter:2];
            }else {
                [OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil];
            }
        }else{
            [OTSAlertView alertWithMessage:@"收藏失败" andCompleteBlock:nil];
        }
        
    }];
}

-(void)showSetting:(UITabBarItem *)item{
    
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


-(IBAction)progressPress:(id)sender{
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
