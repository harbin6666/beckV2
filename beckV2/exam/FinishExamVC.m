//
//  FinishExamVC.m
//  beckV2
//
//  Created by yj on 15/6/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "FinishExamVC.h"
#import "WechatObj.h"
#import "QQObj.h"
#import "AppDelegate.h"
@interface FinishExamVC ()
@property(nonatomic,weak)IBOutlet UIButton *wechat,*wechatF,*qqF;

@end

@implementation FinishExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wechat addTarget:self action:@selector(sharing:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)sharing:(id)sender{
    int type=0;//1微信好友 2微信朋友圈 3qq好友
    type=(int)((UIButton*)sender).tag;
    if (type==3) {
        [[QQObj sharedSingle] sharedQQWithBlock:^(id aResponseObject) {
            [self dismissViewControllerAnimated:NO completion:^{
                AppDelegate *app=[UIApplication sharedApplication].delegate;
                [(UINavigationController*)app.window.rootViewController popToRootViewControllerAnimated:YES];

            }];
        }];
    }else{
        [[WechatObj sharedSingle] sendShare:type Block:^(id aResponseObject) {
            [self dismissViewControllerAnimated:NO completion:^{
                AppDelegate *app=[UIApplication sharedApplication].delegate;
                [(UINavigationController*)app.window.rootViewController popToRootViewControllerAnimated:YES];

            }];
        }];
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
