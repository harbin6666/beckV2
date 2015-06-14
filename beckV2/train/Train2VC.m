//
//  Train2VC.m
//  beckV2
//
//  Created by yj on 15/6/14.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "Train2VC.h"
#import "Train3VC.h"
@interface Train2VC ()

@end

@implementation Train2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"招生简章";
    // Do any additional setup after loading the view.
    UIScrollView *scroll=[[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scroll];
    scroll.contentSize=CGSizeMake(self.view.frame.size.width, 1070);
    UIImageView *im=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroll.frame.size.width, 1070)];
    im.image=[UIImage imageNamed:@"train2"];
    im.userInteractionEnabled=YES;
    [scroll addSubview:im];

    UIButton *next=[UIButton buttonWithType:UIButtonTypeCustom];
    next.frame=CGRectMake(self.view.frame.size.width/2, 1070-90, self.view.frame.size.width/2, 90);

    next.backgroundColor=[UIColor clearColor];
    [next addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [im addSubview:next];
    
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 1070-90, self.view.frame.size.width/2, 90);

    back.backgroundColor=[UIColor clearColor];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [im addSubview:back];

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)click{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    Train3VC*v3=[sb instantiateViewControllerWithIdentifier:@"train3"];
    [self.navigationController pushViewController:v3 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
