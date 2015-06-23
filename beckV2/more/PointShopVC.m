//
//  PointShopVC.m
//  beckV2
//
//  Created by yj on 15/6/13.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PointShopVC.h"
#import "BaseViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WechatObj.h"
@interface PointShopVC ()
@property(nonatomic,strong)NSArray *pointAr;
@property(nonatomic,strong)NSDictionary *selectP;
@property(nonatomic,assign)NSInteger currentIndex;
@end
static NSString *partid=@"2088811668420352";
static NSString *seller=@"whbyxxjs@126.com";
static NSString *privatekey=@"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALgAvOnODGVfBT7rk7xcpLLnpJaMJjuxbVuuplFdje8c5MYbsyiic/6HCuXiPi185X6kLdNrhn4qTjkY6BagvzxzV+31oJyy+92OnkQEG7qqCJZZjvcHr2FYocQXK9N6U02PYw5/SGHRdMnVqEwDar8IMiv956W89oLO7rR84CcLAgMBAAECgYBj99KrXE0Tzjo1YxwS3GqG4J9lQ6OKDu2RQCQQVLnGTXZlw6rkys4mXQwotXB+mjq9QUm8cdDSPv3cu5Fsqcz7iNtMwwrsqxVwWBJeLJ1QVY5iRdHff0epQJaJRFnUf2e18Teg2Cupp9v/uyss+ovvLS4zFT6VrbGSy1EylsycoQJBAODrm1OmSBQ1RBoO1LShQ3nd55pcKWIMl4nrrWX1QSFqfKR9SMnwCm23c/QSXTdgp7bt4MBhF5x6cdupItY85vkCQQDRbbS6VtJ8GxVs5A6WEk6ssFtJRTMhQ2tCgv+8a97o574HzbqqkjTEWB7T48hrfPxvGDREBw8cIgvh262iNusjAkEAq2G7lEyipYtE3hoo543tjWGRxWOuQMDZg0UqdgMf4qdyXB/+o6idOabM2tBXaQfkI5Y0aEJTLG98bGT/X4E+eQJANTJfsOFy79FVXOaFCfu2fkkBtxfbx/w/F5L88NiZs6GB9Kt+WetvedxEYGBAvYTu/i0wwYLlhKjlScaqUUUP7wJAJBI74DxPsJDl+A1E6xE1+c8kVP+Y62P20fIiDfETIVD3HT3rkYW2tl9MM1N3V8LJviTqafGP2rVRJFcbCeBueQ==";

static NSString *publicKey=@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4ALzpzgxlXwU+65O8XKSy56SWjCY7sW1brqZRXY3vHOTGG7MoonP+hwrl4j4tfOV+pC3Ta4Z+Kk45GOgWoL88c1ft9aCcsvvdjp5EBBu6qgiWWY73B69hWKHEFyvTelNNj2MOf0hh0XTJ1ahMA2q/CDIr/eelvPaCzu60fOAnCwIDAQAB";

@implementation PointShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/pointGoogsAct.htm" params:@{@"token":@"list"} CompleteBlock:^(id aResponseObject, NSError *anError) {
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                self.pointAr=aResponseObject[@"list"];
                [self.tableView reloadData];
            }
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.pointAr.count;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *str=@"";
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    if (section==0) {
        str=@"选择购买类型";
        img.image=[UIImage imageNamed:@"goumai"];
    }else{
        str=@"选择支付方式";
        img.image=[UIImage imageNamed:@"zhifu"];
    }
    [v addSubview:img];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 30)];
    lab.text=@"选择购买类型";
    lab.textColor=[UIColor whiteColor];
    [v addSubview:lab];
    v.backgroundColor=[UIColor redColor];
    return v;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    if (indexPath.section==0) {
        NSDictionary* dic=self.pointAr[indexPath.row];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@元购买%@积分",dic[@"money"],dic[@"point"]];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buymark"]];
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text=@"支付宝充值";
            cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alipay"]];
        }else{
            cell.textLabel.text=@"微信充值";
            cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weixinpay"]];

        }
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        self.currentIndex=indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        self.selectP=self.pointAr[indexPath.row];
     UITableViewCell*cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buymark_sel"]];

    }else{
        if (self.selectP==nil) {
            [[OTSAlertView alertWithMessage:@"请选择购买类型" andCompleteBlock:nil] show];
        }else{
            
            [self topay:indexPath.row];
        }
    }
}

-(void)topay:(NSInteger)index{
    [self showLoading];
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/orderAct.htm" params:@{@"token":@"add",@"loginName":[Global sharedSingle].loginName,@"pointGoodsId":self.selectP[@"id"]} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                NSString *code=aResponseObject[@"orderSn"];//orderSn值传给支付宝 out_trade_no这个字段  支付宝异步url：/front/notifyUrlAct.htm
                NSString *product=[NSString stringWithFormat:@"%@积分",self.selectP[@"point"]];
                NSNumber *money=self.selectP[@"money"];
                if (index==1) {
                    NSString *price=[NSString stringWithFormat:@"%zd",[money integerValue]*100];
                    [[WechatObj sharedSingle] sendPayProduct:product price:price orderNum:aResponseObject[@"orderSn"] Block:^(BaseResp* aResponseObject) {
                        if ([aResponseObject isKindOfClass:[PayResp class]]) {
                            PayResp *re=(PayResp*)aResponseObject;
                            if (re.errCode==0) {
                                [[OTSAlertView alertWithMessage:@"支付成功" andCompleteBlock:nil] show];
                            }
                        }
                    }];

                }else{
                    NSString *paystr=[NSString stringWithFormat:@"partner=\"%@\"&seller_id=\"%@\"&out_trade_no=\"%@\"&subject=\"%@\"&body=\"%@\"&total_fee=\"%@\"&notify_url=\"%@\"&service=\"mobile.securitypay.pay\"&payment_type=\"1\"&_input_charset=\"utf-8\"&it_b_pay=\"30m\"&show_url=\"m.alipay.com\"&sign=\"%@\"&sign_type=RSA",partid,seller,code,@"医百分",product,money,@"http://www.zhongxinlan.com/beck/front/notifyUrlAct.htm",privatekey];
                    [[AlipaySDK defaultService] payOrder:paystr fromScheme:@"beck" callback:^(NSDictionary *resultDic) {
                        
                        NSNumber *paystatus=resultDic[@"resultStatus"];
                        if (paystatus.integerValue==9000) {
                            [[OTSAlertView alertWithMessage:@"支付成功" andCompleteBlock:nil] show];
                        }else if (paystatus.integerValue==6001){
                            
                        }else{
                            [[OTSAlertView alertWithMessage:resultDic[@"memo"] andCompleteBlock:nil] show];
                        }
                    }];

                }
            }else{
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
        }else{
            [[OTSAlertView alertWithMessage:@"支付失败" andCompleteBlock:nil] show];
        }
    }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
