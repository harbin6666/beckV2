//
//  PointShopVC.m
//  beckV2
//
//  Created by yj on 15/6/13.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PointShopVC.h"
#import "BaseViewController.h"
@interface PointShopVC ()
@property(nonatomic,strong)NSArray *pointAr;
@property(nonatomic,strong)NSDictionary *selectP;
@property(nonatomic,assign)NSInteger currentIndex;
@end

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
