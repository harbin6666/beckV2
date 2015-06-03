//
//  TabbarVC.m
//  beckV2
//
//  Created by yj on 15/5/31.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "TabbarVC.h"
#import "PractisHomeVC.h"
@interface TabbarVC ()

@end

@implementation TabbarVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITabBarItem*item1= [self.tabBar.items objectAtIndex:0];
    [item1 setImage:[[UIImage imageNamed:@"tab1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"tab1_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];

    UITabBarItem*item2= [self.tabBar.items objectAtIndex:1];
    [item2 setImage:[[UIImage imageNamed:@"tab2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"tab2_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    UITabBarItem*item3= [self.tabBar.items objectAtIndex:2];
    [item3 setImage:[[UIImage imageNamed:@"tab3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"tab3_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    
    UITabBarItem*item4= [self.tabBar.items objectAtIndex:3];
    [item4 setImage:[[UIImage imageNamed:@"tab4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"tab4_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];

    
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
