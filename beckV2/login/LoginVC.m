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
#import "Global.h"
#import "WechatObj.h"
#import "QQObj.h"
@interface LoginVC ()<TencentLoginDelegate,TencentSessionDelegate,UITextFieldDelegate,WBHttpRequestDelegate>
@property(nonatomic,weak)IBOutlet UITextField* usrName;
@property(nonatomic,weak)IBOutlet UITextField* passw;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property(nonatomic,strong)NSString*accessToken;
@property(nonatomic,weak) IBOutlet UIButton* remenber;
@property(nonatomic,strong)NSString *nickName;
@property(nonatomic)IBOutlet UIButton *wxBtn,*sinaBtn,*qqBtn;

@end


@implementation LoginVC

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    if ([Global sharedSingle].passWord) {
        self.usrName.text=[Global sharedSingle].loginName;
        self.passw.text=[Global sharedSingle].passWord;
        if (self.usrName.text.length&&self.passw.text.length) {
            [self loginPress:nil];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    delegate.loginVC = self;
    self.title=@"登录";
    if ([[[Global sharedSingle] getUserWithkey:@"logined"] integerValue]) {
        self.remenber.selected=YES;
    }
    // Do any additional setup after loading the view.
//    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kOpenQQAppKey andDelegate:self];
    
    self.usrName.returnKeyType=UIReturnKeyDone;
    self.passw.returnKeyType=UIReturnKeyDone;
//    [self setNavigationBarButtonName:@"" width:0 isLeft:YES];
    if (![WXApi isWXAppInstalled]) {
        self.wxBtn.hidden=YES;
    }
    if (![TencentOAuth iphoneQQInstalled]) {
        self.qqBtn.hidden=YES;
    }
}

- (IBAction)onPressedQQ:(id)sender {
    [[QQObj sharedSingle] loginWithBlock:^(id aResponseObject) {
        NSString *openid=aResponseObject[@"qqopenid"];
        
        self.accessToken=[NSString stringWithFormat:@"qq%@",openid];
    
        [self unoinLogin];
    }];
    return;
//    if ([TencentOAuth iphoneQQSupportSSOLogin]) {
//        NSArray *permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
//                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                                 kOPEN_PERMISSION_GET_INFO];
//        [self.tencentOAuth authorize:permissions];
//    }
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

- (IBAction)onPressedwechat:(id)sender {
    [[WechatObj sharedSingle] sendLoginBlock:^(id aResponseObject) {
        if ([aResponseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=(NSDictionary*)aResponseObject;
            NSString *openid=aResponseObject[@"wxopenid"];

            self.accessToken=[NSString stringWithFormat:@"wx%@",openid];
        }
        [self unoinLogin];
    }];
}


-(void)unoinLogin{
    
    
    [self showLoading];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"twoThreeLogin",@"loginName":self.accessToken,@"passWord":self.accessToken} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (anError==nil) {
            NSNumber *errorcode = aResponseObject[@"errorcode"];
            if (errorcode.intValue!=0) {
                [[OTSAlertView alertWithMessage:@"登录失败" andCompleteBlock:nil] show];
            }
            else {
                NSDictionary *user=aResponseObject[@"userBean"];
                [Global sharedSingle].loginName=user[@"loginName"];
                if (user!=nil) {
                    [Global sharedSingle].userBean=user;
                }
                [Global sharedSingle].logined=YES;
                [self performSegueWithIdentifier:@"tohome" sender:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDB" object:nil];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"登录失败" andCompleteBlock:nil] show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark -wechat
-(void) onResp:(BaseResp*)resp{
    SendAuthResp*auth=(SendAuthResp*)resp;
    if(auth.errCode== 0) {
        NSString *code = auth.code;
        [self showLoading];
        [self getAccess_token:code];
    }

}

-(void)getAccess_token:(NSString*)code
{
        //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
             
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
             
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *zoneUrl = [NSURL URLWithString:url];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            [self getUserInfo:dic[@"access_token"] openid:dic[@"openid"]];
                            self.accessToken=dic[@"openid"];
                            }
                    });    
            });    
}

-(void)getUserInfo:(NSString*)accessToken openid:(NSString*)openid
{
       // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
             
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
             
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *zoneUrl = [NSURL URLWithString:url];
                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                [Global sharedSingle].nickName=dic[@"nickname"];
                                [self unoinLogin];

                     
                            }
                    });    
             
            });    
}



#pragma mark - <TencentLoginDelegate>
- (void)tencentDidLogin
{
    NSLog(@"QQ 登录成功");
    NSLog(@"openid = %@, accessToken = %@", self.tencentOAuth.openId, self.tencentOAuth.accessToken);
    self.accessToken=self.tencentOAuth.openId;
    [self showLoading];
    [self.tencentOAuth getUserInfo];

}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSLog(@"QQ 取消登录");
}

- (void)tencentDidNotNetWork {

}
- (void)getUserInfoResponse:(APIResponse*) response{
    [Global sharedSingle].nickName=response.jsonResponse[@"nickname"];
    [self unoinLogin];
}
  */
#pragma mark - <WeiboSDKDelegate>

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{

    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [Global sharedSingle].nickName=dic[@"screen_name"];
    NSString *openid=dic[@"idstr"];
    self.accessToken=[NSString stringWithFormat:@"sina%@",openid];

    [self unoinLogin];
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //(int)response.statusCode = 0 is ok
        if ([(WBAuthorizeResponse *)response userID]) {
            NSLog(@"Sina 登录成功");
            NSString *uid=[(WBAuthorizeResponse *)response userID];
            NSString *accesstoken=[(WBAuthorizeResponse *)response accessToken];
            
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setObject:uid forKey:@"uid"];
            [dic setObject:accesstoken forKey:@"access_token"];
            [WBHttpRequest requestWithURL:@"https://api.weibo.com/2/users/show.json" httpMethod:@"GET" params:dic  delegate:self withTag:@"1"];
        
        
        }else{
            [[OTSAlertView alertWithMessage:@"登录失败" andCompleteBlock:nil] show];
        }
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
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
            else {
                NSDictionary *user=aResponseObject[@"userBean"];
                [Global sharedSingle].loginName=user[@"loginName"];
                [Global sharedSingle].userBean=(NSMutableDictionary*)user;
                [Global sharedSingle].logined=YES;
                if (self.remenber.selected) {
                    [[Global sharedSingle] setUserValue:@1 Key:@"logined"];
                    [[Global sharedSingle] setUserValue:[Global sharedSingle].loginName Key:@"loginName"];
                    [[Global sharedSingle] setUserValue:user Key:@"userBean"];
                }
                [self performSegueWithIdentifier:@"tohome" sender:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDB" object:nil];
            }
        }
        else {
            [[OTSAlertView alertWithMessage:@"登录失败" andCompleteBlock:nil] show];
        }
    }];
}

-(IBAction)remenberclick:(UIButton*)b{
    b.selected=!b.selected;
    if (b.selected==NO) {
        [[Global sharedSingle] setUserValue:@0 Key:@"logined"];
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
