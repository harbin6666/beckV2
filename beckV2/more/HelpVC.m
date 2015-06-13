//
//  HelpVC.m
//  beckV2
//
//  Created by yj on 15/6/13.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()
@property(nonatomic,strong) UIScrollView *scroll;
@end

@implementation HelpVC
//-(void)viewDidAppear:(BOOL)animated{
//    CGFloat w=self.view.frame.size.width;
//    CGFloat h=self.view.frame.size.height;
//    self.scroll.contentSize=CGSizeMake(w*4, h);
//    for (int i=0; i<4; i++) {
//        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(w*i, 0, w, h)];
//        image.image=[UIImage imageNamed:[NSString stringWithFormat:@"help%zd",i]];
//        [self.scroll addSubview:image];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat w=self.view.frame.size.width;
    CGFloat h=self.view.frame.size.height;
    self.scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.scroll.contentSize=CGSizeMake(w*4, h);
    self.scroll.pagingEnabled=YES;
    for (int i=0; i<4; i++) {
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(w*i, 64, w, h-64)];
        image.image=[UIImage imageNamed:[NSString stringWithFormat:@"help%zd",i]];
        [self.scroll addSubview:image];
    }
    [self.view addSubview:self.scroll];
    // Do any additional setup after loading the view.
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
