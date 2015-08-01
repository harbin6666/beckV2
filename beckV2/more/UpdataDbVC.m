//
//  UpdataDbVC.m
//  beckV2
//
//  Created by yj on 15/6/5.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "UpdataDbVC.h"
#import "BaseViewController.h"
#import "Position.h"
@interface UpdataDbVC ()
@property(nonatomic,strong)NSArray*list;
@property(nonatomic,strong)NSString*maxChoiceQuestionsId,*maxCompatibilityInfoId;
@property(nonatomic,strong)NSMutableArray *updateBeans;
@end

@implementation UpdataDbVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoading];
    NSArray *positions=[[SQLManager sharedSingle] getTitles];
    self.updateBeans=[[NSMutableArray alloc] init];
    
    self.maxChoiceQuestionsId=[[SQLManager sharedSingle] getMaxidWithTableName:@"choice_questions" colName:@"choice_id"];
    
    self.maxCompatibilityInfoId=[[SQLManager sharedSingle] getMaxidWithTableName:@"compatibility_info" colName:@"id"];

    for (Position*p in positions) {
        if (p.is_vaild.integerValue) {
            NSMutableDictionary *dic=@{}.mutableCopy;
            dic[@"titleId"]=@(p.titleId.integerValue);
            dic[@"titleName"]=p.titleName;
            dic[@"dataSize"]=@0;
            dic[@"titleNumber"]=@0;
            dic[@"choiceQuestionsId"]=@(self.maxChoiceQuestionsId.integerValue);
            dic[@"compatibilityInfoId"]=@(self.maxCompatibilityInfoId.integerValue);
            [self.updateBeans addObject:dic];
        }
    }

    
    NSMutableDictionary* jsond=@{}.mutableCopy;
    jsond[@"list"]=self.updateBeans;
    NSData*data=[NSJSONSerialization dataWithJSONObject:jsond options:0 error:nil];
    NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    WEAK_SELF;
    [self getValueWithBeckUrl:@"/front/versionUpdateAct.htm" params:@{@"token":@"versionList",@"json":json} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        NSLog(@"%@",aResponseObject);
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                self.list=aResponseObject[@"list"];
                [self.tableView reloadData];
            }
        }
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBar ButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateSingleTable:(NSString*)titleid{
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/versionUpdateAct.htm" params:@{@"token":@"version",@"titleId":titleid,@"choice_questions_id":self.maxChoiceQuestionsId,@"compatibility_info_id":self.maxCompatibilityInfoId} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                NSArray *list=aResponseObject[@"list"];
                if (list.count==0) {
                    [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
                }else{
                    for (NSString *s in list) {
                        [[SQLManager sharedSingle] excuseSql:s];
                    }
                }
            }else{
                [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
            }
        }else{
            [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
        }
    }];
}


-(void)resetDB{
    WEAK_SELF;
    [self showLoading];
    [self getValueWithBeckUrl:@"/front/versionUpdateAct.htm" params:@{@"token":@"versionupdate"} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                NSNumber *count=aResponseObject[@"value"];
                int value=[[SQLManager sharedSingle] queryParam]+1;
                if (value-1==count.intValue) {
                    [self hideLoading];
                    return ;
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    for (int i=value; i<count.intValue+1; i++) {
                        NSString *fileStr=[NSString stringWithFormat:@"http://192.168.100.222:8080/beck2/upload/txt/%d.txt",i];
                        NSString *file=[NSString stringWithContentsOfURL:[NSURL URLWithString:fileStr] encoding:NSUTF8StringEncoding error:nil];
                        NSArray *ar=[file componentsSeparatedByString:@"\r"];
                        for (NSString *sql in ar) {
                            [[SQLManager sharedSingle] excuseSql:sql];
                        }
                    }
                    NSString *updateSql=[NSString stringWithFormat: @"UPDATE parameter SET param_value ==\'%@\' WHERE param_id ==1" ,count];
                    [[SQLManager sharedSingle] excuseSql:updateSql];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideLoading];
                        });
                });
            }else{
                [self hideLoading];
                [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
            }
        }else{
            [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
            [self hideLoading];
        }
    }];

}

-(IBAction)updateAllDB{
    WEAK_SELF;
    [self showLoading];
    
    NSMutableDictionary* jsond=@{}.mutableCopy;
    jsond[@"list"]=self.updateBeans;
    NSData*data=[NSJSONSerialization dataWithJSONObject:jsond options:0 error:nil];
    NSString *json=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    
    
    [self getValueWithBeckUrl:@"/front/versionUpdateAct.htm" params:@{@"token":@"versionFind",@"json":json} CompleteBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        [self hideLoading];
        if (anError==nil) {
            if ([aResponseObject[@"errorcode"] integerValue]==0) {
                NSArray *list=aResponseObject[@"list"];
                if (list.count==0) {
                    [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
                }else{
                    for (NSString *s in list) {
                        [[SQLManager sharedSingle] excuseSql:s];
                    }
                }
            }else{
                [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
            }
        }else{
            [[OTSAlertView alertWithMessage:@"当前无更新数据" andCompleteBlock:nil] show];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.list.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row==self.list.count) {
        cell.textLabel.text=@"全量更新";
    }else{
        NSDictionary *dic=self.list[indexPath.row];
        cell.textLabel.text=dic[@"titleName"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==self.list.count) {
        [self resetDB];
    }else{
        NSDictionary *dic=self.list[indexPath.row];
        [self updateSingleTable:dic[@"titleId"]];

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
