//
//  ExamHomeVC.m
//  beckV2
//
//  Created by yj on 15/6/4.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ExamHomeVC.h"
#import "ExamScreenVC.h"
#import "ExamPaper.h"
@interface ExamHomeVC ()
@property(nonatomic,strong)NSArray *papers;
@end

@implementation ExamHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


-(IBAction)BtnPress:(UIButton*)sender{
    //模拟从1开始，真题从11开始
    NSString *screen=@"";
    NSString *type=@"1";
    switch (sender.tag) {
        case 1:
            screen=@"1";
            break;
        case 2:
            screen=@"2";
            break;
        case 3:
            screen=@"3";
            break;
        case 4:
            screen=@"4";
            break;
        case 11:
            screen=@"1";
            type=@"2";
            break;
        case 12:
            screen=@"2";
            type=@"2";
            break;
        case 13:
            screen=@"3";
            type=@"2";
            break;
        case 14:
            screen=@"4";
            type=@"2";
            break;
            
        default:
            break;
    }
    
    self.papers=[[SQLManager sharedSingle] getExamPaperType:type screen:screen];
    
    if (self.papers.count==0) {
        [[OTSAlertView alertWithMessage:@"暂时没有内容" andCompleteBlock:nil] show];
    }else{
        [self performSegueWithIdentifier:@"examselect" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"examselect"]) {
        ExamScreenVC *vc=segue.destinationViewController;
        vc.title=[NSString stringWithFormat:@"模拟场次%@",[(ExamPaper*)self.papers[0] screening]];
        vc.papers=self.papers;
        vc.hidesBottomBarWhenPushed=YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)homeClick:(UIButton *)sender{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:NO];
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
