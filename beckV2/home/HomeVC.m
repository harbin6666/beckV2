//
//  HomeVC.m
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "HomeVC.h"
#import <UIKit/UIKit.h>
@interface HomeVC ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;

@end

@implementation HomeVC

-(void)viewWillAppear:(BOOL)animated{
    if (![[Global sharedSingle] logined]) {
        [self performSegueWithIdentifier:@"nologin" sender:self];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
