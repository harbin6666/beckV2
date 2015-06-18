//
//  InviteVC.m
//  beckV2
//
//  Created by yj on 15/6/16.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "InviteVC.h"
#import "VerifyVC.h"
@interface InviteVC ()
@end

@implementation InviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)invite:(id)sender{
    if (self.tf.text==nil||self.tf.text.length==0) {
        [[OTSAlertView alertWithMessage:@"请输入邀请码" andCompleteBlock:nil] show];
    }else{
        
        [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"verification",@"verificationCode":self.tf.text} CompleteBlock:^(id aResponseObject, NSError *anError) {
            if (anError==nil&&[aResponseObject[@"errorcode"] integerValue]==0) {
                [self performSegueWithIdentifier:@"useinvite" sender:self];
            }else{
                [[OTSAlertView alertWithMessage:@"邀请码错误" andCompleteBlock:nil] show];
            }
        }];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"useinvite"]) {

    }
}

//- (IBAction)unwindToRed:(UIStoryboardSegue *)unwindSegue
//{
//    VerifyVC *vc=unwindSegue.destinationViewController;
////    vc.couponCode=self.tf.text;
//    [self.navigationController popViewControllerAnimated:YES];
//}
//-(BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender{
//    return YES;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
