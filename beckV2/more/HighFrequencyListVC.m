//
//  HighFrequencyListVC.m
//  beckV2
//
//  Created by yj on 15/6/12.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "HighFrequencyListVC.h"

@interface HighFrequencyListVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)IBOutlet UITableView *table;
@end

@implementation HighFrequencyListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *high_id=[[SQLManager sharedSingle] getMaxidWithTableName:@"high_frequency_test" colName:@"high_id"];
    [self getValueWithBeckUrl:@"/front/highFrequencyTestAct.htm" params:@{@"token":@"outlinelist",@"highFrequencyId":high_id} CompleteBlock:^(id aResponseObject, NSError *anError) {
        if (anError==nil) {
            if (aResponseObject!=nil&&[aResponseObject[@"errorcode"] integerValue]==0) {
                NSArray *list=aResponseObject[@"list"];
                for (int i=0; i<list.count; i++) {
                    [[SQLManager sharedSingle] excuseSql:list[i]];
                }
            }else{
                [[OTSAlertView alertWithMessage:aResponseObject[@"msg"] andCompleteBlock:nil] show];
            }
        }else{
            [[OTSAlertView alertWithMessage:@"暂无数据" andCompleteBlock:nil] show];
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
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
