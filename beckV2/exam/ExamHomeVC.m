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
@property(nonatomic)NSInteger papertag;
@property(nonatomic) UIButton*k1,*k2,*k3,*k4;
@property(nonatomic,strong)UIView *bg;
@property(nonatomic,weak)IBOutlet UILabel *zLab;
@end

@implementation ExamHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bg=[[UIView alloc] initWithFrame:CGRectMake(0, self.zLab.frame.origin.y+self.zLab.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-(self.zLab.frame.origin.y+self.zLab.frame.size.height)-49)];
    self.bg.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.bg];
    

    CGFloat w=self.bg.frame.size.width;
    self.k1=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.k1 setBackgroundImage:[UIImage imageNamed:@"zhenti0"] forState:UIControlStateNormal];
    self.k1.tag=11;
    self.k1.frame=CGRectMake(0, 0, w/4, w/4);
    [self.k1 addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.k1.center=CGPointMake(self.bg.frame.size.width/4, self.bg.frame.size.height/4);
    [self.bg addSubview:self.k1];
    NSLog(@"%f",self.k1.center.x);
    
    self.k2=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.k2 setBackgroundImage:[UIImage imageNamed:@"zhenti1"] forState:UIControlStateNormal];
    self.k2.tag=12;
    self.k2.frame=CGRectMake(0, 0, w/4, w/4);
    [self.k2 addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.k2.center=CGPointMake(self.bg.frame.size.width*3/4, self.bg.frame.size.height/4);
    [self.bg addSubview:self.k2];
    NSLog(@"%f",self.k2.center.x);

    self.k3=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.k3 setBackgroundImage:[UIImage imageNamed:@"zhenti2"] forState:UIControlStateNormal];
    self.k3.tag=13;
    self.k3.frame=CGRectMake(0, 0, w/4, w/4);
    [self.k3 addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.k3.center=CGPointMake(self.bg.frame.size.width/4, self.bg.frame.size.height*3/4);
    [self.bg addSubview:self.k3];
    NSLog(@"%f",self.k3.center.x);

    self.k4=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.k4 setBackgroundImage:[UIImage imageNamed:@"zhenti3"] forState:UIControlStateNormal];
    self.k4.tag=14;
    self.k4.frame=CGRectMake(0, 0, w/4, w/4);
    [self.k4 addTarget:self action:@selector(BtnPress:) forControlEvents:UIControlEventTouchUpInside];
    self.k4.center=CGPointMake(self.bg.frame.size.width*3/4, self.bg.frame.size.height*3/4);
    [self.bg addSubview:self.k4];
    NSLog(@"%f",self.k4.center.x);

}


-(IBAction)BtnPress:(UIButton*)sender{
    //模拟从1开始，真题从11开始
    self.papertag=sender.tag;
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
    
    self.papers=[[SQLManager sharedSingle] getPapers:type screen:screen];
    
    if (self.papers.count==0) {
        [[OTSAlertView alertWithMessage:@"暂时没有内容" andCompleteBlock:nil] show];
    }else{
        [self performSegueWithIdentifier:@"examselect" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"examselect"]) {
        ExamScreenVC *vc=segue.destinationViewController;
        if (self.papertag>10) {
            vc.title=@"真题考试";
        }else{
            vc.title=@"模拟考试";
        }
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
