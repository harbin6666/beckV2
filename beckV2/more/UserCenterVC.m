//
//  UserCenterVC.m
//  beckV2
//
//  Created by yj on 15/6/13.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "UserCenterVC.h"
#import "PointDetailVC.h"
#import "AppDelegate.h"
@interface UserCenterVC ()

@end

@implementation UserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled=NO;
    self.title=@"个人档案";
    UIImageView *imv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UILabel *l=[[UILabel alloc] initWithFrame:imv.bounds];
    
    l.text=[NSString stringWithFormat:@"%@ 欢迎你，邀请码：%@",[[Global sharedSingle].userBean valueForKey:@"loginName"],[[Global sharedSingle].userBean valueForKey:@"verificationCode"]];
    l.textAlignment=NSTextAlignmentCenter;
    imv.image=[[UIImage imageNamed:@"personalbg"] stretchableImageWithLeftCapWidth:5 topCapHeight:2];
    
    [imv addSubview:l];
    self.tableView.tableHeaderView=imv;
    
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    
    UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
    bu.backgroundColor=[UIColor redColor];
    [bu setTitle:@"退出当前账号" forState:UIControlStateNormal] ;
    [bu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bu.frame=CGRectMake(0, 0, 280, 40);
    [bu addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    bu.center=v.center;
    [v addSubview:bu];
    self.tableView.tableFooterView=v;
}
-(void)logout{
    [Global sharedSingle].userBean=nil;
    [Global sharedSingle].logined=NO;
    [Global sharedSingle].loginName=nil;
    [[Global sharedSingle] setUserValue:@0 Key:@"logined"];
    [[Global sharedSingle] setUserValue:nil Key:@"loginName"];
        
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [(UINavigationController*)app.window.rootViewController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *str=@"";
    switch (indexPath.row) {
        case 0:
            str=@"我的积分";
            cell.detailTextLabel.text=[[Global sharedSingle].userBean valueForKey:@"totalPoints"];
            break;
        case 1:
            str=@"修改密码";
            cell.detailTextLabel.text=@"";
            break;
        case 2:
            str=@"支付信息";
            cell.detailTextLabel.text=@"";
            break;
        case 3:
            str=@"参加培训";
            cell.detailTextLabel.text=@"";
            break;
        default:
            break;
    }
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"personal%zd",indexPath.row]];
    cell.textLabel.text=str;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UIStoryboard*sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
        PointDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"pointdetail"];
        vc.type=0;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1){
        
    }else if (indexPath.row==2){
        UIStoryboard*sb=[UIStoryboard storyboardWithName:@"Practis" bundle:[NSBundle mainBundle]];
        PointDetailVC *vc=[sb instantiateViewControllerWithIdentifier:@"pointdetail"];
        vc.type=1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==3){
        
    }
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
