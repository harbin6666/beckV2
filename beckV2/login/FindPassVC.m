//
//  FindPassVC.m
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "FindPassVC.h"
#import "VerifyVC.h"
@interface FindPassVC ()
@property(nonatomic,weak)IBOutlet UITextField *phoneNum;
@property(nonatomic,strong)NSString *smsCode;
@end

@implementation FindPassVC

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
    vc.verifyPhone=self.phoneNum.text;
    vc.smsCode=self.smsCode;
    vc.findpw=YES;
}

-(IBAction)findPassPress:(id)sender{
    
    if (!self.phoneNum.text&&!self.phoneNum.text.length) {
        [[OTSAlertView alertWithMessage:@"请输入手机号" andCompleteBlock:nil] show];
        return;
    }
    
    [self getValueWithBeckUrl:@"/front/sendTemplateSmsAct.htm" params:@{@"loginName":self.phoneNum.text} CompleteBlock:^(id aResponseObject, NSError *anError) {
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"code"];
            if (errorcode.integerValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                self.smsCode = aResponseObject[@"value"];
                [self performSegueWithIdentifier:@"toverify" sender:self];
            }
        }
        [self hideLoading];
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
