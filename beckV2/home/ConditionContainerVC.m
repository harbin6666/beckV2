//
//  ConditionContainerVC.m
//  beckV2
//
//  Created by yj on 15/5/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "ConditionContainerVC.h"

@interface ConditionContainerVC ()
@property(nonatomic,assign)BOOL isLogin;
  @property (nonatomic, strong) UIViewController *lastViewController;
@end

@implementation ConditionContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isLogin) {
          [self performSegueWithIdentifier:@"logined" sender:self];
        }
    else {
          [self performSegueWithIdentifier:@"nologin" sender:self];
        }
}
- (void)loginStatus{
    NSArray *poppedViewcontrollers = [self.navigationController popToRootViewControllerAnimated:NO];
      // 但是如果是从上面那个图的Need Login这个界面返回，这个时候已经在RootViewController了
      // 因此需要手动调用viewWillAppear
      if (poppedViewcontrollers == nil) {
             [[self.navigationController.viewControllers firstObject] viewWillAppear:YES];
          }
}
   
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (segue.destinationViewController != self.lastViewController) {
          [self.lastViewController willMoveToParentViewController:nil];
          [self.lastViewController.view removeFromSuperview];
          [self.lastViewController removeFromParentViewController];
        }
    self.lastViewController = segue.destinationViewController;
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
