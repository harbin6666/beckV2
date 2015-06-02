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
@interface PractiseVC ()<UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSArray *questionsAr;
@property(nonatomic,weak) IBOutlet UILabel *testLab;
@property(nonatomic,assign)NSInteger currentQIndex;
@property(nonatomic,weak) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray *choiceArray;//选择题选项数组
@property(nonatomic,strong)NSArray *compatibilyArray;//配伍题数组
@property(nonatomic,weak) IBOutlet UIButton *questionBtn;
@property(nonatomic,weak)IBOutlet UITabBar* tabbar;
@end

@implementation PractiseVC

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
            ChoiceQuestion* q=(ChoiceQuestion*)p;
            self.testLab.text= q.choice_content;
            q.choiceItems=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];
            self.choiceArray=[[SQLManager sharedSingle] getChoiceItemByChoiceId:q.choice_id];

        }else{
            self.table.allowsSelection=NO;
            CompatyInfo *comp=(CompatyInfo*)p;
            self.testLab.text=comp.title;
            
            self.compatibilyArray=[[SQLManager sharedSingle] getCompatyQuestionsByinfoId:comp.info_id];
            //子题目
            for (int i=0; i<self.compatibilyArray.count; i++) {
                CompatyQuestion* q=self.compatibilyArray[i];
                //选项
                NSArray *comItem=[[SQLManager sharedSingle] getCompatyItemByCompid:q.compatibility_id];
                q.items=comItem;
            }

        }
    
    [self.table reloadData];
    
  UITabBarItem*item5= [self.tabbar.items lastObject];
    UITabBarItem*item1= [self.tabbar.items firstObject];
    if (self.currentQIndex==self.questionsAr.count-1) {
        [item1 setImage:[UIImage imageNamed:@"back_sel"]];
        [item1 setSelectedImage:[UIImage imageNamed:@"back_sel"]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [item5 setImage:[UIImage imageNamed:@"next"]];
        [item5 setSelectedImage:[UIImage imageNamed:@"next"]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];

    }else if (self.currentQIndex==0) {
        [item1 setImage:[UIImage imageNamed:@"back"]];
        [item1 setSelectedImage:[UIImage imageNamed:@"back"]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
        [item5 setImage:[UIImage imageNamed:@"next_sel"]];
        [item5 setSelectedImage:[UIImage imageNamed:@"next_sel"]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];

    }else{
        [item5 setImage:[UIImage imageNamed:@"next_sel"]];
        [item5 setSelectedImage:[UIImage imageNamed:@"next_sel"]];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item5 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
        
        [item1 setImage:[UIImage imageNamed:@"back_sel"]];
        [item1 setSelectedImage:[UIImage imageNamed:@"back_sel"]];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateNormal];
        [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];

    }
    [self.view bringSubviewToFront:self.questionBtn];
}

-(void)rightBtnClick:(UIButton *)sender{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        return self.choiceArray.count+2;
    }else{
        return self.compatibilyArray.count+2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    id p=[self.questionsAr objectAtIndex:self.currentQIndex];
    if ([p isKindOfClass:[ChoiceQuestion class]]) {
        if (indexPath.row==self.choiceArray.count+1) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"answercell" forIndexPath:indexPath];
        }else if (indexPath.row==self.choiceArray.count) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
        }else{
           ChoiceCell* cell=(ChoiceCell*)[tableView dequeueReusableCellWithIdentifier:@"choicecell" forIndexPath:indexPath];
            [cell updateWithChoice:self.choiceArray[indexPath.row]];
            return cell;

        }
    }else{
        if (indexPath.row==self.choiceArray.count+1) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"answercell" forIndexPath:indexPath];
        }else if (indexPath.row==self.compatibilyArray.count) {
            cell=[tableView dequeueReusableCellWithIdentifier:@"notecell" forIndexPath:indexPath];
        }else{
           CompatyCell* cell=(CompatyCell* )[tableView dequeueReusableCellWithIdentifier:@"compatycell" forIndexPath:indexPath];
            [cell updateCompatyCell:p selectedBlock:^(BOOL right) {
                
            }];
            return cell;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
}

-(void)showSetting:(UITabBarItem *)item{
    
}

-(void)backwardPress:(UITabBarItem *)item{
    if (self.currentQIndex>0) {
        self.currentQIndex--;
    }

    if (self.currentQIndex==0) {
        item.image=[UIImage imageNamed:@"back"];
    }else{
        item.image=[UIImage imageNamed:@"back_sel"];
    }
    [self freshView];
}

-(void)forwardPress:(UITabBarItem *)item{
    if (self.currentQIndex<self.questionsAr.count) {
        self.currentQIndex++;
    }
    if (self.currentQIndex==self.questionsAr.count-1) {
        item.image=[UIImage imageNamed:@"next"];
    }else{
        item.image=[UIImage imageNamed:@"next_sel"];
    }
    [self freshView];
}

-(void)addFaver:(UITabBarItem *)item{
    
}

-(IBAction)progressPress:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
