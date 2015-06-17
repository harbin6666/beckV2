//
//  UpdatePassVC.m
//  beckV2
//
//  Created by yj on 15/6/18.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "UpdatePassVC.h"

@interface UpdatePassVC ()<UITextFieldDelegate>
@property(nonatomic,weak)IBOutlet UITextField *tf1,*tf2,*tf3;
@end

@implementation UpdatePassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(IBAction)pressed:(id)sender{
    if ([self.tf2.text isEqualToString:self.tf3.text]&&self.tf3.text.length>0) {
        [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"updtePassWord",@"loginName":[Global sharedSingle].loginName,@"passWord":self.tf1.text,@"newPassWord":self.tf2.text} CompleteBlock:^(id aResponseObject, NSError *anError) {
            if (anError==nil) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"token"] andCompleteBlock:^(OTSAlertView *alertView, NSInteger buttonIndex) {
                    if ([aResponseObject[@"errorcode"] integerValue]==0) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }] show];
                
            }else{
                [[OTSAlertView alertWithMessage:@"设置失败" andCompleteBlock:nil] show];
            }
        }];
    }else{
        [[OTSAlertView alertWithMessage:@"2次设置的密码不同" andCompleteBlock:nil] show];
    }
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
