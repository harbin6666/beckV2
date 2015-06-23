//
//  ChengjiuVC.m
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ChengjiuVC.h"
#import "HonorTVCell.h"
#import "OTSAlertView.h"
@interface ChengjiuVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *sectionNames;
@property (nonatomic, strong) NSDictionary *infos;
@property(nonatomic,weak)IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@end

@implementation ChengjiuVC

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self showLoading];
//    WEAK_SELF;
//    [self getValueWithBeckUrl:@"/front/userAct.htm" params:@{@"token":@"personal",@"loginName":[Global sharedSingle].loginName} CompleteBlock:^(id aResponseObject, NSError *anError) {
//        STRONG_SELF;
//        [self hideLoading];
//        if (!anError) {
//            NSNumber *errorcode = aResponseObject[@"errorcode"];
//            if (errorcode.boolValue) {
//                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
//            }
//            else {
//                self.infos = aResponseObject;
//            }
//        }
//        else {
//            [[OTSAlertView alertWithMessage:@"获取成就失败" andCompleteBlock:nil] show];
//        }
//    }];

    self.sectionNames = @[@"    我的勋章", @"    我的积分"];
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
    b.frame=CGRectMake(10, 5, 100, 23);
    [b setBackgroundImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(rule) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:b];
    self.tableView.tableFooterView =v;
    self.tableView.allowsSelection=NO;
    [self.tableView reloadData];

}
-(void)rule{
    [self performSegueWithIdentifier:@"torule" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *lbl = [UILabel viewWithFrame:CGRectMake(10, 0, 300, 30)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.textColor = BeckRed;
    lbl.text = self.sectionNames[section];
    return lbl;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        HonorTVCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"HonorCell" forIndexPath:indexPath];
        [tempCell updateWithPoint:[Global sharedSingle].userBean[@"totalPoints"]];
        cell = tempCell;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PointCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"累计积分";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[Global sharedSingle].userBean[@"totalPoints"]];
        }else{
            cell.textLabel.text = @"当前积分";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[Global sharedSingle].userBean[@"currentPoints"]];

        }
    }
    
    return cell;
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
