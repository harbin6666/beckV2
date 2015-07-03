//
//  AlipayObj.m
//  beckV2
//
//  Created by yj on 15/6/24.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "AlipayObj.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
@interface AlipayObj()
@end

@implementation AlipayObj
singleton_implementation(AlipayObj)

-(void)sendPayProduct:(NSString*)orderName price:(NSString *)price orderNum:(NSString*)num Block:(alipayCompletionBlock)block{
    self.block=block;
    NSString *partner = @"2088811668420352";
    NSString *seller = @"whbyxxjs@126.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALgAvOnODGVfBT7rk7xcpLLnpJaMJjuxbVuuplFdje8c5MYbsyiic/6HCuXiPi185X6kLdNrhn4qTjkY6BagvzxzV+31oJyy+92OnkQEG7qqCJZZjvcHr2FYocQXK9N6U02PYw5/SGHRdMnVqEwDar8IMiv956W89oLO7rR84CcLAgMBAAECgYBj99KrXE0Tzjo1YxwS3GqG4J9lQ6OKDu2RQCQQVLnGTXZlw6rkys4mXQwotXB+mjq9QUm8cdDSPv3cu5Fsqcz7iNtMwwrsqxVwWBJeLJ1QVY5iRdHff0epQJaJRFnUf2e18Teg2Cupp9v/uyss+ovvLS4zFT6VrbGSy1EylsycoQJBAODrm1OmSBQ1RBoO1LShQ3nd55pcKWIMl4nrrWX1QSFqfKR9SMnwCm23c/QSXTdgp7bt4MBhF5x6cdupItY85vkCQQDRbbS6VtJ8GxVs5A6WEk6ssFtJRTMhQ2tCgv+8a97o574HzbqqkjTEWB7T48hrfPxvGDREBw8cIgvh262iNusjAkEAq2G7lEyipYtE3hoo543tjWGRxWOuQMDZg0UqdgMf4qdyXB/+o6idOabM2tBXaQfkI5Y0aEJTLG98bGT/X4E+eQJANTJfsOFy79FVXOaFCfu2fkkBtxfbx/w/F5L88NiZs6GB9Kt+WetvedxEYGBAvYTu/i0wwYLlhKjlScaqUUUP7wJAJBI74DxPsJDl+A1E6xE1+c8kVP+Y62P20fIiDfETIVD3HT3rkYW2tl9MM1N3V8LJviTqafGP2rVRJFcbCeBueQ==";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = num; //订单ID（由商家自行制定）
    order.productName = @"医百分"; //商品标题
    order.productDescription = orderName; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price.floatValue]; //商品价格
    order.notifyURL =  @"http://www.ybf100.net:8080/beck2/front/notifyUrlAct.htm"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"beck";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            self.block(resultDic);
        }];
        
    }

}
@end
