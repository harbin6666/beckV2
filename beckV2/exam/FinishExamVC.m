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
#import "ExamVC.h"
@interface FinishExamVC ()
@property(nonatomic,weak)IBOutlet UIButton *wechat,*wechatF,*qqF;
@property(nonatomic,weak)IBOutlet UILabel *nameL,*pointlb,*examTimelb,*coslb,*rightlb,*wronglb,*ratelb;
@end

@implementation FinishExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.wechat addTarget:self action:@selector(sharing:) forControlEvents:UIControlEventTouchUpInside];
    [self.wechatF addTarget:self action:@selector(sharing:) forControlEvents:UIControlEventTouchUpInside];
    [self.qqF addTarget:self action:@selector(sharing:) forControlEvents:UIControlEventTouchUpInside];
    self.nameL.text=self.examTitle;
    self.pointlb.text=[NSString stringWithFormat:@"恭喜你赚取%@积分",self.point];
    self.examTimelb.text=[NSString stringWithFormat:@"考试时间    ：%@分钟",self.time];
    self.coslb.text=[NSString stringWithFormat:@"做题时间    ：%@分钟",self.cost];
    self.rightlb.text=[NSString stringWithFormat:@"答对题数    ：%@题",self.right];
    self.wronglb.text=[NSString stringWithFormat:@"答错题数    ：%@题",self.wrong];
    self.ratelb.text=[NSString stringWithFormat:@"   正确率    ：%.2f％",self.right.floatValue/(self.wrong.floatValue+self.right.floatValue)];
}
-(IBAction)dissmiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate *app=[UIApplication sharedApplication].delegate;
        [(UINavigationController*)app.window.rootViewController popToRootViewControllerAnimated:NO];
    }];
}

-(IBAction)seeExam{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
    ExamVC*vc =[sb instantiateViewControllerWithIdentifier:@"exam"];
    vc.fromDB=YES;
    vc.paperid=self.paperid;
    [self.navigationController pushViewController:vc animated:YES];

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
