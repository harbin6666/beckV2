//
//  BaseViewController.m
//  beckV2
//
//  Created by yj on 15/5/18.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIViewController (Beck)
- (void)configNavibar
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)setNavigationBarButtonName:(NSString *)aName width:(CGFloat)aWidth isLeft:(BOOL)left
{
    UIButton *btn = [UIButton viewWithFrame:CGRectMake(0, 0, aWidth, 44)];
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn setTitle:aName forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (left) {
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = btnItem;
    }
    else {
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = btnItem;
    }
}

- (void)leftBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick:(UIButton *)sender
{
    
}

@end

#import <AFNetworking/AFNetworking.h>
#import "LoginVC.h"
@implementation BaseViewController
-(void)showlogin{
    if ([[Global sharedSingle] loginName]==nil&&![[[Global sharedSingle] getUserWithkey:@"logined"] boolValue]) {
        UIStoryboard*sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *vc=[sb instantiateViewControllerWithIdentifier:@"loginNav"];

        [self presentViewController:vc animated:YES completion:^{
            
        }];
//        [self performSegueWithIdentifier:@"nologin" sender:self];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavibar];
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;
//    self.view.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
}
//- (void)showPositionPan{
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    self.postionPan=[sb instantiateViewControllerWithIdentifier:@"PositionVC"];
//    self.postionPan.delegate=self;
//    [self.view addSubview:self.postionPan.view];
//}

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

@implementation UIViewController (Net)

- (void)showLoading
{
    [self showLoadingWithMessage:nil];
}

- (void)showLoadingWithMessage:(NSString *)message
{
    [self showLoadingWithMessage:message hideAfter:0];
}

- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second
{
    [self showLoadingWithMessage:message onView:self.view hideAfter:second];
}

- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    
    if (message) {
        hud.labelText = message;
        hud.mode = MBProgressHUDModeText;
    }
    else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    if (second > 0) {
        [hud hide:YES afterDelay:second];
    }
}

- (void)hideLoading
{
    [self hideLoadingOnView:self.view];
}

- (void)hideLoadingOnView:(UIView *)aView
{
    [MBProgressHUD hideAllHUDsForView:aView animated:YES];
}

- (void)getValueWithUrl:(NSString *)url params:(NSDictionary *)params CompleteBlock:(BeckCompletionBlock)block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json", @"application/json", @"text/javascript", @"text/html",@"text/plain", nil];
    
    AFHTTPRequestOperation *operation = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\n\nabsoluteString = %@",[operation.request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        NSLog(@"\n\nurl = %@\n\nparams = %@\n\nresponseObject = %@",url,params,responseObject);
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\n\nurl = %@\n\nparams = %@\n\nerror = %@",url,params,error);
        if (block) {
            block(operation, error);
        }
    }];
    
    [operation start];
}

- (void)getValueWithBeckUrl:(NSString *)url params:(NSDictionary *)params CompleteBlock:(BeckCompletionBlock)block
{
        NSString *beckUrl = [@"http://www.zhongxinlan.com/beck2" stringByAppendingString:url];
    
//    NSString *beckUrl = [@"http://www.ybf100.net:8080/beck2" stringByAppendingString:url];
    [self getValueWithUrl:beckUrl params:params CompleteBlock:block];
}

@end
