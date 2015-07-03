//
//  QQObj.m
//  beckV2
//
//  Created by yj on 15/6/24.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "QQObj.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface QQObj()
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property(nonatomic,copy)QQCompletionBlock block;
@property(nonatomic,strong)NSString *accessToken;

@end
@implementation QQObj
singleton_implementation(QQObj)

-(void)loginWithBlock:(QQCompletionBlock)block{
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kOpenQQAppKey andDelegate:self];
    self.block=block;
    if ([TencentOAuth iphoneQQSupportSSOLogin]) {
        NSArray *permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                                 kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                 kOPEN_PERMISSION_GET_INFO];
        [self.tencentOAuth authorize:permissions];
    }

    
}
- (void)onReq:(QQBaseReq *)req{
    
}


- (void)onResp:(QQBaseResp *)resp{
    self.block(@"ok");
}

-(void)sharedQQWithBlock:(QQCompletionBlock)block{
    UIImage *img=[UIImage imageNamed:@"shareIcon"];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kOpenQQAppKey andDelegate:self];

//    QQApiURLObject*url=[QQApiURLObject objectWithURL:[NSURL URLWithString:@"http://www.zhongxinlan.com/beck/front/shareAct.htm?operate=share"] title:@"医百分" description:@"执业医师考试大全" previewImageData:UIImagePNGRepresentation(img) targetContentType:QQApiURLTargetTypeNotSpecified];
    
    QQApiNewsObject* mes=[QQApiNewsObject objectWithURL:[NSURL URLWithString:@"http://www.ybf100.net:8080/beck2/front/shareAct.htm?operate=share"] title:@"医百分" description:@"权威的执业药师、执业医师考试辅导软件，软件题库紧扣考试大纲，并保持实时更新，设置的错题重做、统计分析、模拟考试、个人成就等多个功能模块全方位满足考生的需求。" previewImageData:UIImagePNGRepresentation(img)];
    SendMessageToQQReq *req=[SendMessageToQQReq reqWithContent:mes];
   QQApiSendResultCode code= [QQApiInterface sendReq:req];
    //qqzone
//    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];

}
- (void)tencentDidLogin
{
    NSLog(@"QQ 登录成功");
    NSLog(@"openid = %@, accessToken = %@", self.tencentOAuth.openId, self.tencentOAuth.accessToken);
    self.accessToken=self.tencentOAuth.openId;

    [self.tencentOAuth getUserInfo];
    
}

- (void)tencentDidLogout{
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSLog(@"QQ 取消登录");
}

- (void)tencentDidNotNetWork {
    
}
- (void)getUserInfoResponse:(APIResponse*) response{
    [Global sharedSingle].nickName=response.jsonResponse[@"nickname"];
    self.block(@{@"qqopenid":self.accessToken});
//    [self unoinLogin];
}

@end
