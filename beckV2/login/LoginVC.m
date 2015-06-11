//
//  LoginVC.m
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "LoginVC.h"
#import "FindPassVC.h"
#import <TencentOpenAPI/TencentOAuth.h>

#import "AppDelegate.h"
@interface LoginVC ()<TencentLoginDelegate,TencentSessionDelegate>
@property(nonatomic,weak)IBOutlet UITextField* usrName;
@property(nonatomic,weak)IBOutlet UITextField* passw;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property(nonatomic,strong)NSString*accessToken;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.loginVC = self;
    
    // Do any additional setup after loading the view.
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kOpenQQAppKey andDelegate:self];
    
    [WeiboSDK registerApp:kSinaAppKey];
    
    //        [RennClient initWithAppId:kRenRenAppId
    //                           apiKey:kRenRenAppKey
    //                        secretKey:kRenRenAppSecretKey];
    
    [self setNavigationBarButtonName:@"" width:0 isLeft:YES];
}

- (void)getUserInfoResponse:(APIResponse*) response{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <TencentLoginDelegate>
- (IBAction)onPressedQQ:(id)sender {
    if ([TencentOAuth iphoneQQSupportSSOLogin]) {
        NSArray *permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                 kOPEN_PERMISSION_GET_INFO];
        [self.tencentOAuth authorize:permissions];
    }
//    else {
//        [[OTSAlertView alertWithMessage:@"您没有安装QQ,不能登录" andCompleteBlock:nil] show];
//    }
}

- (IBAction)onPressedSina:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginVC",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

//- (IBAction)onPressedRenRen:(id)sender {
//    if ([RennClient isLogin]) {
//        [RennClient logoutWithDelegate:self];
//    }
//
//    [RennClient loginWithDelegate:self];
//}


-(void)unoinLogin{
    [self showLoading];
    
    
    [self showLoading];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"twoThreeLogin",@"loginName":self.accessToken,@"passWord":self.accessToken} CompleteBlock:^(id aResponseObject, NSError *anError) {
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
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"登录失败" andCompleteBlock:nil] show];
        }
    }];
}
- (void)tencentDidLogin
{
    NSLog(@"QQ 登录成功");
    NSLog(@"openid = %@, accessToken = %@", self.tencentOAuth.openId, self.tencentOAuth.accessToken);
    self.accessToken=self.tencentOAuth.openId;
    [self unoinLogin];

}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSLog(@"QQ 取消登录");
}

- (void)tencentDidNotNetWork {

}

#pragma mark - <WeiboSDKDelegate>

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //(int)response.statusCode = 0 is ok
        NSLog(@"Sina 登录成功");
        if ([(WBAuthorizeResponse *)response userID]) {
            [self unoinLogin];
        }
        NSLog(@"userID = %@, accessToken = %@", [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken]);
//        NSString *title = @"认证结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}

//#pragma mark - <RennLoginDelegate>
//- (void)rennLoginSuccess
//{
//    NSLog(@"Renren 登录成功");
//    NSLog(@"renren uid = %@, accessToken = %@", [RennClient uid], [RennClient accessToken]);
//}
//
//- (void)rennLogoutSuccess
//{
//    NSLog(@"Renren 注销成功");
//}


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
