//
//  RegisterVC.m
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "RegisterVC.h"
#import "VerifyVC.h"
@interface RegisterVC ()
@property(nonatomic,weak)IBOutlet UITextField *numberTF;
@property (nonatomic, strong) NSNumber *smsCode;
@property(nonatomic,weak)IBOutlet UITextField *couponTF;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    VerifyVC *vc=segue.destinationViewController;
    vc.verifyPhone=self.numberTF.text;
    vc.smsCode=[NSString stringWithFormat:@"%@",self.smsCode];
    vc.couponCode=self.couponTF.text;
}

- (IBAction)onPressedBtn:(id)sender {
    
    if (!self.numberTF.text.length) {
        [[OTSAlertView alertWithMessage:@"请输入手机号" andCompleteBlock:nil] show];
        return;
    }
    
    [self showLoading];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"OnlyPhone", @"loginName":self.numberTF.text} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.boolValue) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
                [self hideLoading];
            }
            else {
                [self getValueWithBeckUrl:@"/front/sendsmsAct.htm" params:@{@"loginName":self.numberTF.text} CompleteBlock:^(id aResponseObject, NSError *anError) {
                    [self hideLoading];
                    if (!anError) {
                        NSNumber *errorcode = aResponseObject[@"errorcode"];
                        if (errorcode.integerValue!=0) {
                            [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
                        }
                        else {
                            self.smsCode = aResponseObject[@"value"];
                            [self performSegueWithIdentifier:@"toverify" sender:self];
                        }
                    }
                }];
            }
        }
        else {
            [self hideLoading];
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
