//
//  PointRuleVC.m
//  beckV2
//
//  Created by yj on 15/6/17.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PointRuleVC.h"

@interface PointRuleVC ()
@property(nonatomic,weak)IBOutlet UIWebView *web;
@end

@implementation PointRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url=[[NSBundle mainBundle] URLForResource:@"rule" withExtension:@"html"];
    [self.web loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view.
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
