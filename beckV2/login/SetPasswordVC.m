//
//  SetPasswordVC.m
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "SetPasswordVC.h"
#import "InviteVC.h"
@interface SetPasswordVC ()
@property(nonatomic,weak)IBOutlet UITextField* pass;
@property(nonatomic,weak)IBOutlet UITextField* verifyPass;
@end

@implementation SetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.findpw) {
        self.navigationItem.rightBarButtonItem=nil;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindVC:(UIStoryboardSegue *)unwindSegue
{
    InviteVC *vc=unwindSegue.sourceViewController;
    self.couponCode=vc.tf.text;
}

-(IBAction)confirmPassPress:(id)sender{
    if (!self.pass.text || !self.verifyPass.text) {
        [[OTSAlertView alertWithMessage:@"请输入密码" andCompleteBlock:nil] show];
        return;
    }
    
    if (![self.pass.text isEqualToString:self.verifyPass.text]) {
        [[OTSAlertView alertWithMessage:@"密码不匹配" andCompleteBlock:nil] show];
        return;
    }

    [self showLoading];
    if ([self.pass.text isEqualToString:self.verifyPass.text]) {
        NSMutableDictionary *param = @{@"token":@"Makepassword",@"loginName":self.phoneNum,@"passWord":self.pass.text}.mutableCopy;
        if (self.findpw) {
            param[@"token"] = @"RetrievePassWord";
        }else{
            if (self.couponCode&&self.couponCode.length) {
                param[@"verificationCode"]=self.couponCode;//优惠码
            }            
        }
        WEAK_SELF;
        [self getValueWithBeckUrl:@"/front/userAct.htm" params:param CompleteBlock:^(id aResponseObject, NSError *anError) {
            STRONG_SELF;
            [self hideLoading];
            if (!anError) {
                NSNumber *errorcode = aResponseObject[@"errorcode"];
                if (errorcode.boolValue) {
                    [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
                }
                else {
                    NSMutableDictionary *loginParam=@{@"token":@"twoLogin",@"loginName":self.phoneNum,@"passWord":self.pass.text}.mutableCopy;
                    [self getValueWithBeckUrl:@"/front/userAct.htm" params:loginParam CompleteBlock:^(id aResponseObject, NSError *anError) {
                        if ([aResponseObject[@"errorcode"] intValue]==0) {
                            [Global sharedSingle].loginName=self.phoneNum;
                            [Global sharedSingle].passWord=self.pass.text;
                            [self performSegueWithIdentifier:@"tohome" sender:self];
                        }else{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                    }];
                }
            }

        }];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Pass the selected object to the new view controller.
}


@end
