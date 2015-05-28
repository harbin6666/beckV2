//
//  LoginVC.m
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "LoginVC.h"
#import "FindPassVC.h"

@interface LoginVC ()
@property(nonatomic,weak)IBOutlet UITextField* usrName;
@property(nonatomic,weak)IBOutlet UITextField* passw;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarButtonName:@"" width:0 isLeft:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"dismisssegue"]) {
        [Global sharedSingle].logined=YES;
    }    
}

-(IBAction)forgetPassPress:(id)sender{
    [self performSegueWithIdentifier:@"tofindpass" sender:self];
}

-(IBAction)loginPress:(id)sender{
    
    NSMutableDictionary*param=@{@"token":@"twoLogin",@"loginName":self.usrName.text,@"passWord":self.passw.text}.mutableCopy;
    [self showLoading];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:param CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (!anError) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.intValue!=0) {
                [[OTSAlertView alertWithMessage:aResponseObject[@"token"] andCompleteBlock:nil] show];
            }
            else {
                NSDictionary *user=aResponseObject[@"userBean"];
                [Global sharedSingle].loginName=user[@"loginName"];
                [Global sharedSingle].userBean=user;
                [Global sharedSingle].logined=YES;
                [self performSegueWithIdentifier:@"tohome" sender:self];
                
                
//                if (titleId) {
//                    [[NSUserDefaults standardUserDefaults] setObject:titleId forKey:@"subjectId"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    [self performSegueWithIdentifier:@"tohome" sender:self];
//                }
//                else {
//                    [self performSegueWithIdentifier:@"toCus" sender:self];
//                }
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"登录失败" andCompleteBlock:nil] show];
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
