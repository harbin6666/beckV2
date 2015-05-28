//
//  HomeVC.m
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "HomeVC.h"
#import <UIKit/UIKit.h>
#import "Position.h"
#import <QuartzCore/QuartzCore.h>
@interface HomeVC ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property(nonatomic)BOOL hasShowPickerView;
@property(nonatomic,weak) IBOutlet UIView *positionView;
@end
#define padding 10
@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated{
    if (![[Global sharedSingle] logined]) {
        [self performSegueWithIdentifier:@"nologin" sender:self];
    }
    
    [self getPositions];
    self.positionView.hidden=YES;
    if ([Global sharedSingle].logined) {
        [self updateDB];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        UITabBarItem *item1 = self.tabbar.items[0];
        [item1 setSelectedImage:[[UIImage imageNamed:@"tab1_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *item2 = self.tabbar.items[1];
        [item2 setSelectedImage:[[UIImage imageNamed:@"tab2_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *item3 = self.tabbar.items[2];
        [item3 setSelectedImage:[[UIImage imageNamed:@"tab3_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        UITabBarItem *item4 = self.tabbar.items[3];
        [item4 setSelectedImage:[[UIImage imageNamed:@"tab4_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    else {
//        UITabBarItem *item1 = self.tabbar.items[0];
//        [item1 setFinishedSelectedImage:[UIImage imageNamed:@"tab1_sel"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab1"]];
//        
//        UITabBarItem *item2 = self.tabbar.items[1];
//        [item2 setFinishedSelectedImage:[UIImage imageNamed:@"tab2_sel"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab2"]];
//        
//        UITabBarItem *item3 = self.tabbar.items[2];
//        [item3 setFinishedSelectedImage:[UIImage imageNamed:@"tab3_sel"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab3"]];
//        
//        UITabBarItem *item4 = self.tabbar.items[3];
//        [item4 setFinishedSelectedImage:[UIImage imageNamed:@"tab4_sel"] withFinishedUnselectedImage:[UIImage imageNamed:@"tab4"]];
    }
}

-(void)getPositions{
    __block NSMutableArray *array=@[].mutableCopy;
    NSString *sql=@"select title_id,title_name from position_title_info";
    [[AFSQLManager sharedManager] performQuery:sql withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }else{
            Position *postion=[Position new];
            postion.titleId=row[0];
            postion.titleName=row[1];
            [array addObject:postion];
        }
    }];
    CGFloat btnWidth=(self.view.frame.size.width-4*padding)/3;
    
    for (int i=0;i<array.count;i++) {
        Position*p=array[i];
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=CGRectMake(0, 0, btnWidth, 36);
        b.layer.borderWidth=1;
        b.layer.borderColor=[UIColor blackColor].CGColor;
        [b setTitle:p.titleName forState:UIControlStateNormal];
        b.titleLabel.numberOfLines=2;
        b.titleLabel.font=[UIFont systemFontOfSize:14];
        int y=(int)(i/3);
        int x=i%3;
        b.center=CGPointMake((btnWidth/2+padding)+x*(btnWidth+padding), 28+y*(36+padding));
        NSLog(@"%@",NSStringFromCGPoint(b.center));
        [self.positionView addSubview:b];
    }
}
-(IBAction)showPositionView:(id)sender{
    self.positionView.hidden=!self.positionView.hidden;
}
//-(void)replacePickerContainerViewTopConstraintWithConstant:(CGFloat)constant
//{
//    for(NSLayoutConstraint*constraint in self.positionView.superview.constraints){
//        if(constraint.firstItem==self.positionView&&constraint.firstAttribute==NSLayoutAttributeBottom){
//            constraint.constant=constant;
//            }
//        }
//}
//
//-(IBAction)showPositionView:(id)sender{
//    self.hasShowPickerView=!self.hasShowPickerView;
//    if(self.hasShowPickerView){
//        CGRect frame=self.positionView.frame;
//        frame=[self.view convertRect:frame fromView:self.positionView];
//        CGFloat offset=frame.origin.y+frame.size.height;
//        CGFloat gap=offset-(self.view.frame.size.height-self.positionView.frame.size.height);
//        CGRect bounds=self.view.bounds;
//        if(gap>0){
//            bounds.origin.y=gap;
//            }else{
//                gap=0;
//                }
//        [self replacePickerContainerViewTopConstraintWithConstant:offset];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.view.bounds=bounds;
//            [self.view layoutIfNeeded];
//            }];
//        }else{
//            [self replacePickerContainerViewTopConstraintWithConstant:self.view.frame.size.height];
//            CGRect bounds=self.view.bounds;
//            bounds.origin.y=0;
//            [UIView animateWithDuration:0.25 animations:^{
//                self.view.bounds=bounds;
//                [self.view layoutIfNeeded];
//                }];
//            }
//}
-(void)updateDB{
    /**
     * @param token=” addIn”(固定值)
     * @param loginName  string
     * @param pointId string 表point_transaction最大ID 默认为0
     * @param exchangerId string表exchange_paper最大ID
     * @param userNoteId string表user_note最大ID
     
     * @param userCollectionId string表user_collection最大ID
     * @param userExamId string表user_exam最大ID
     
     * @param userExerciseId string表user_exam_subject最大ID
     * @param examPaperId  string表exam_paper最大ID
     
     * @param titlePaperId string表subject_position_paper最大ID
     */
    
    NSMutableDictionary*addIn=@{@"token":@"addIn",@"loginName":[Global sharedSingle].loginName}.mutableCopy;
    NSString *sql1 = @"select max(id) from point_transaction";
    [[AFSQLManager sharedManager] performQuery:sql1 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"pointId"] = row.firstSqlObj;
        }
    }];
    NSString *sql2 = @"select max(id) from exchange_paper";
    [[AFSQLManager sharedManager] performQuery:sql2 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"exchangerId"] = row.firstSqlObj;
        }
    }];
    
    NSString *sql3 = @"select max(id) from user_note";
    [[AFSQLManager sharedManager] performQuery:sql3 withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userNoteId"] = row.firstSqlObj;
        }
    }];

    NSString *userCollectionId = @"select max(id) from user_collection";
    [[AFSQLManager sharedManager] performQuery:userCollectionId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userCollectionId"] = row.firstSqlObj;
        }
    }];

    NSString *userExamId = @"select max(id) from user_exam";
    [[AFSQLManager sharedManager] performQuery:userExamId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userExamId"] = row.firstSqlObj;
        }
    }];

    NSString *userExerciseId = @"select max(id) from user_exam_subject";
    [[AFSQLManager sharedManager] performQuery:userExerciseId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"userExerciseId"] = row.firstSqlObj;
        }
    }];

    NSString *examPaperId = @"select max(id) from exam_paper";
    [[AFSQLManager sharedManager] performQuery:examPaperId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"examPaperId"] = row.firstSqlObj;
        }
    }];
    
    NSString *titlePaperId = @"select max(id) from subject_position_paper";
    [[AFSQLManager sharedManager] performQuery:titlePaperId withBlock:^(NSArray *row, NSError *error, BOOL finished) {
        if (finished) {
            
        }
        else {
            addIn[@"titlePaperId"] = row.firstSqlObj;
        }
    }];

    
    //查询配置
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:addIn CompleteBlock:^(id aResponseObject, NSError *anError) {
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] intValue]==0) {
                NSArray *sqlAr=aResponseObject[@"list"];
                if (sqlAr.count>0) {
                    for (int i=0; i<sqlAr.count; i++) {
                        [self excuseSql:sqlAr[i]];
                    }
                }
            }
       }else{
           [[OTSAlertView alertWithMessage:@"获取更新失败" andCompleteBlock:nil] show];
        }
    }];

}

-(void)excuseSql:(NSString*)sql{
    [[AFSQLManager sharedManager] performQuery:sql withBlock:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch ([tabBar.items indexOfObject:item]) {
        case 0:
            [self performSegueWithIdentifier:@"Practise" sender:self];

//            sb = [UIStoryboard storyboardWithName:@"Practise" bundle:nil];
            break;
        case 1:
            [self performSegueWithIdentifier:@"Exam" sender:self];

//            sb = [UIStoryboard storyboardWithName:@"Exam" bundle:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"MyAccount" sender:self];

//            sb = [UIStoryboard storyboardWithName:@"MyAccount" bundle:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"More" sender:self];

//            sb = [UIStoryboard storyboardWithName:@"More" bundle:nil];
            break;
        default:
            break;
    }
    
//    UIViewController *vc = [sb instantiateInitialViewController];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)signInPress:(id)sender{
    WEAK_SELF;
    [self showLoading];
#warning 接口bug
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"signInAct",@"loginName":[Global sharedSingle].loginName} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (!anError) {
            NSString *msg = aResponseObject[@"msg"];
            [[OTSAlertView alertWithMessage:msg andCompleteBlock:nil] show];
        }
        else {
            [[OTSAlertView alertWithMessage:@"签到失败" andCompleteBlock:nil] show];
        }
    }];

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
