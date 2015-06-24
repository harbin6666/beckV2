//
//  WechatObj.m
//  beckV2
//
//  Created by yj on 15/6/23.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "WechatObj.h"
#import "WXUtil.h"
#import "payRequsestHandler.h"
@interface WechatObj()
@property(nonatomic,copy)WechatCompletionBlock block;
@end
@implementation WechatObj
singleton_implementation(Global)

-(void)sendLoginBlock:(WechatCompletionBlock)block{
    self.block=block;
    SendAuthReq*req=[SendAuthReq new];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"beck" ;
    [WXApi sendReq:req];

}


-(void)sendPayProduct:(NSString*)orderName price:(NSString *)price orderNum:(NSString*)num Block:(WechatCompletionBlock)block{
    self.block=block;
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_OrderName:orderName price:price orderNum:num];
    
    if(dict == nil){
        //错误提示
        
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
//        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = [[NSDate date] timeIntervalSince1970]/1000;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        BOOL b=[WXApi safeSendReq:req];
    }

    return;
}
-(void) onReq:(BaseReq*)req{
    
}

-(void) onResp:(BaseResp*)resp{
    SendAuthResp*auth=(SendAuthResp*)resp;
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if(auth.errCode== 0) {
            NSString *code = auth.code;
            
            [self getAccess_token:code];
        }
    }else if ([resp isKindOfClass:[PayResp class]]){
        self.block(resp);
    }

}


-(void)getAccess_token:(NSString*)code
{
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [self getUserInfo:dic[@"access_token"] openid:dic[@"openid"]];
//                self.accessToken=dic[@"openid"];
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
//                [self. unoinLogin];
                self.block(@{@"wxopenid":openid});
                
            }
        });
        
    });
}

-(void)sendShare:(int)type Block:(WechatCompletionBlock)block{
    self.block=block;

    SendMessageToWXReq*req=[SendMessageToWXReq new];
    req.bText=NO;
    req.scene=type;
    req.message=[WXMediaMessage message];
    UIImage *img=[UIImage imageNamed:@"shareIcon"];
    req.message.thumbData=UIImagePNGRepresentation(img);
   WXWebpageObject*obj= [WXWebpageObject object];
    obj.webpageUrl=@"http://www.zhongxinlan.com/beck/front/shareAct.htm?operate=share";
    req.message.mediaObject=obj;
    req.message.title=@"医百分";
    [req.message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    [WXApi sendReq:req];
}

@end
