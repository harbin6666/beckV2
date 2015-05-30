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
@property(nonatomic)IBOutlet UIButton* titleBtn ;
@property(nonatomic,weak) IBOutlet UIView *positionView;
@property(nonatomic,weak)IBOutlet UIImageView *hIV;
@property(nonatomic,weak)IBOutlet UIImageView *tIV;
@property(nonatomic,weak)IBOutlet UIImageView *cIV;
@end
#define padding 10
@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated{
    if (![[Global sharedSingle] logined]) {
        [self performSegueWithIdentifier:@"nologin" sender:self];
    }
    
    self.positionView.hidden=YES;
    if ([Global sharedSingle].logined) {
        [self updateDB];
    }
    [self freshNav];
    self.titleBtn.titleLabel.numberOfLines=2;
    self.titleBtn.titleLabel.textAlignment=NSTextAlignmentCenter;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPositions];

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
    }
}

-(void)getPositions{

    NSArray *array=[SQLManager sharedSingle].getTitles;
    CGFloat btnWidth=(self.view.frame.size.width-4*padding)/3;
    
    for (int i=0;i<array.count;i++) {
        Position*p=array[i];
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=CGRectMake(0, 0, btnWidth, 36);
        b.layer.borderWidth=1;
        b.layer.borderColor=[UIColor blackColor].CGColor;
        [b setTitle:p.titleName forState:UIControlStateNormal];
        if ([p.titleName isEqualToString:[[Global sharedSingle] getUserWithkey:@"titleName"]]) {
            b.selected=YES;
        }else{
            b.selected=NO;
        }
        b.titleLabel.numberOfLines=2;
        b.titleLabel.font=[UIFont systemFontOfSize:14];
        [b setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        int y=(int)(i/3);
        int x=i%3;
        b.tag=i+10;
        [b addTarget:self action:@selector(positonClick:) forControlEvents:UIControlEventTouchUpInside];
        b.center=CGPointMake((btnWidth/2+padding)+x*(btnWidth+padding), 28+y*(36+padding));
        NSLog(@"%@",NSStringFromCGPoint(b.center));
        [self.positionView addSubview:b];
    }
}

-(void)freshNav{
    [self.titleBtn setTitle:[[Global sharedSingle] getUserWithkey:@"titleName"] forState:UIControlStateNormal];
    NSInteger days=[[SQLManager sharedSingle] getExamDate:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    int h = days / 100;
    int t = (days - h * 100) / 10;
    int c = days - h * 100 - t * 10;
    self.hIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"num%d",h]];
    self.tIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"num%d",t]];
    self.cIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"num%d",c]];
}

-(void)positonClick:(UIButton*)sender
{
    NSArray *array=[SQLManager sharedSingle].getTitles;
    Position*p=array[sender.tag-10];
    [[Global sharedSingle] setUserValue:p.titleId Key:@"titleid"];
    [[Global sharedSingle] setUserValue:p.titleName Key:@"titleName"];
    for (UIButton *b in self.positionView.subviews) {
        b.selected=NO;
    }
    UIButton *selB=(UIButton *)[self.positionView viewWithTag:sender.tag];
    selB.selected=YES;

    [self freshNav];
    [self showPositionView:nil];
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
    NSDictionary *addIn=[[SQLManager sharedSingle] getAddinParam];
    
    //查询配置
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:addIn CompleteBlock:^(id aResponseObject, NSError *anError) {
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] intValue]==0) {
                NSArray *sqlAr=aResponseObject[@"list"];
                if (sqlAr.count>0) {
                    for (int i=0; i<sqlAr.count; i++) {
                        [[SQLManager sharedSingle] excuseSql:sqlAr[i]];
                    }
                }
            }
       }else{
           [[OTSAlertView alertWithMessage:@"获取更新失败" andCompleteBlock:nil] show];
        }
    }];

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
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"sign",@"loginName":[Global sharedSingle].loginName} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (!anError&&aResponseObject[@"msg"]) {
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
