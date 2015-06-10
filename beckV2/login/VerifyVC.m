//
//  VerifyVC.m
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "VerifyVC.h"
#import "SetPasswordVC.h"
@interface VerifyVC ()
@property(nonatomic,weak)IBOutlet UILabel *textLab;
@property(nonatomic,weak)IBOutlet UITextField *verifyTf;
@end

@implementation VerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textLab.text=[NSString stringWithFormat: @"验证码已经发送到手机:%@",self.verifyPhone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SetPasswordVC*vc=segue.destinationViewController;
    vc.phoneNum=self.verifyPhone;
    vc.findpw=self.findpw;
    vc.couponCode=self.couponCode;
}

-(IBAction)freshPress:(id)sender{
    [self showLoading];

    [self getValueWithBeckUrl:@"/front/sendTemplateSmsAct.htm" params:@{@"loginName":self.verifyPhone} CompleteBlock:^(id aResponseObject, NSError *anError) {
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"code"];
            if (errorcode.integerValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                self.smsCode = aResponseObject[@"value"];
            }
        }
        [self hideLoading];
    }];

}
-(IBAction)btnPress:(id)sender{
    if (!self.verifyTf.text || !self.verifyTf.text.length) {
        [[OTSAlertView alertWithMessage:@"请输入验证码" andCompleteBlock:nil] show];
        return;
    }

    if ([self.smsCode isEqualToString:self.verifyTf.text]) {
        [self performSegueWithIdentifier:@"tosetpass" sender:self];
    }else{
        [[OTSAlertView alertWithMessage:@"验证码错误" andCompleteBlock:nil] show];
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
