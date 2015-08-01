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
#import "TabbarVC.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeVC ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property(nonatomic)IBOutlet UIButton* titleBtn ;
@property(nonatomic,weak) IBOutlet UIView *positionView;
@property(nonatomic,weak)IBOutlet UIImageView *hIV;
@property(nonatomic,weak)IBOutlet UIImageView *tIV;
@property(nonatomic,weak)IBOutlet UIImageView *cIV;
@property(nonatomic,weak)IBOutlet UIImageView *oldHome;
@property(nonatomic,weak)IBOutlet UIButton *trainbtn;
@property(nonatomic)BOOL showed;
@end
#define padding 10
@implementation HomeVC



-(void)viewWillAppear:(BOOL)animated{
    
    if (![[Global sharedSingle] logined]&&![[[Global sharedSingle] getUserWithkey:@"logined"] boolValue]) {
        [self performSegueWithIdentifier:@"nologin" sender:self];
        return;
    }
        if ([[[Global sharedSingle] getUserWithkey:@"logined"] boolValue]) {
            [Global sharedSingle].loginName=[[Global sharedSingle] getUserWithkey:@"loginName"];
            [Global sharedSingle].userBean=[[Global sharedSingle] getUserWithkey:@"userBean"];
        }
    
    

    self.positionView.hidden=YES;
    [self freshNav];
    self.titleBtn.titleLabel.numberOfLines=2;
    self.titleBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationController.navigationBarHidden=NO;
//    [self showLoading];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        //            dispatch_async(dispatch_get_main_queue(), ^{
    if (!self.showed) {
        self.showed=YES;
        [self updateDB];
    }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideLoading];
//        });
//    });

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getPositions];
}

-(void)configTabbar{
    UITabBarItem*item1= [self.tabbar.items objectAtIndex:0];
    [item1 setImage:[[UIImage imageNamed:@"tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
    UITabBarItem*item2= [self.tabbar.items objectAtIndex:1];
    [item2 setImage:[[UIImage imageNamed:@"tab2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"tab2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
    UITabBarItem*item3= [self.tabbar.items objectAtIndex:2];
    [item3 setImage:[[UIImage imageNamed:@"tab3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"tab3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
    UITabBarItem*item4= [self.tabbar.items objectAtIndex:3];
    [item4 setImage:[[UIImage imageNamed:@"tab4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"tab4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateSelected];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"首页";
    NSString * str=@"2015-7-1";
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate*d=[dateFormatter dateFromString: str];
    
    NSDate* current=[NSDate date];
    
//    if ([current compare:d]==NSOrderedDescending) {
//        self.oldHome.hidden=NO;
//        self.trainbtn.hidden=YES;
//    }else{
        self.oldHome.hidden=YES;
        self.trainbtn.hidden=NO;
//    }
    [self configTabbar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDB) name:@"updateDB" object:nil];

}

-(void)getPositions{

    NSArray *array=[SQLManager sharedSingle].getTitles;
    UIImageView*imgv=[[UIImageView alloc] initWithFrame:self.positionView.bounds];
    imgv.image=[[UIImage imageNamed:@"positionBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 5, 2)resizingMode:UIImageResizingModeStretch];
    imgv.userInteractionEnabled=YES;
    [self.positionView addSubview:imgv];
    CGFloat btnWidth=(self.view.frame.size.width-4*padding)/3;
    
    for (int i=0;i<array.count;i++) {
        Position*p=array[i];
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=CGRectMake(0, 0, btnWidth, 36);
//        b.layer.borderWidth=1;
//        b.layer.borderColor=[UIColor blackColor].CGColor;
        [b setTitle:p.titleName forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

        if ([p.titleName isEqualToString:[[Global sharedSingle] getUserWithkey:@"titleName"]]) {
            b.selected=YES;
        }else{
            b.selected=NO;
        }
        if (p.is_vaild.intValue==0) {
            b.enabled=NO;
        }else{
            b.enabled=YES;
        }
        b.titleLabel.numberOfLines=2;
        b.titleLabel.font=[UIFont systemFontOfSize:14];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"position_sel"] forState:UIControlStateSelected];
        [b setBackgroundImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"position_dis"] forState:UIControlStateDisabled];

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
    NSMutableString *str=[NSMutableString stringWithString:[[Global sharedSingle] getUserWithkey:@"titleName"]];
    if (self.positionView.hidden) {
        [str appendString:@" ▼"];
    }else{
        [str appendString:@" ▲"];
    }
    [self.titleBtn setTitle:str forState:UIControlStateNormal];
    NSInteger days=[[SQLManager sharedSingle] getExamDate:[[Global sharedSingle] getUserWithkey:@"titleid"]];
    int h = (int)days / 100;
    int t = (int)(days - h * 100) / 10;
    int c = (int)days - h * 100 - t * 10;
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
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected=NO;
        }
    }
    sender.selected=YES;
    UIButton *selB=(UIButton *)[self.positionView viewWithTag:sender.tag];
    selB.selected=YES;
    [self showPositionView:nil];
    [self freshNav];
}

-(IBAction)showPositionView:(id)sender{
    self.positionView.hidden=!self.positionView.hidden;
    [self.view bringSubviewToFront:self.positionView];
    NSMutableString *str=[NSMutableString stringWithString:[[Global sharedSingle] getUserWithkey:@"titleName"]];
    if (self.positionView.hidden) {
        [str appendString:@" ▼"];
    }else{
        [str appendString:@" ▲"];
    }
    [self.titleBtn setTitle:str forState:UIControlStateNormal];

}


-(void)updateDB{
    NSDictionary *addIn=[[SQLManager sharedSingle] getAddinParam];
    [self showLoadingWithMessage:@"数据加载中..."];
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
        [self hideLoading];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    UIStoryboard*   sb = [UIStoryboard storyboardWithName:@"Practis" bundle:nil];
    NSInteger tag=[tabBar.items indexOfObject:item];
    if (sb==nil) {
        return;
    }
    TabbarVC *vc = [sb instantiateInitialViewController];
    vc.navigationController.navigationBarHidden=YES;
    
    vc.selectedIndex=tag;
    [self.navigationController pushViewController:vc animated:NO];
}
-(IBAction)signInPress:(id)sender{
    WEAK_SELF;
    [self showLoading];

    [self getValueWithBeckUrl:@"/front/signInAct.htm" params:@{@"token":@"sign",@"loginName":[Global sharedSingle].loginName} CompleteBlock:^(id aResponseObject, NSError *anError) {
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
