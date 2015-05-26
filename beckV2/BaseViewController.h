//
//  BaseViewController.h
//  beckV2
//
//  Created by yj on 15/5/18.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BeckCompletionBlock)(id aResponseObject, NSError* anError);

@interface BaseViewController : UIViewController

@end
@interface UIViewController (Beck)

- (void)configNavibar;

- (IBAction)leftBtnClick:(UIButton *)sender;

- (IBAction)rightBtnClick:(UIButton *)sender;

- (void)setNavigationBarButtonName:(NSString *)aName width:(CGFloat)aWidth isLeft:(BOOL)left;

@end

@interface UIViewController (Net)

/**
 *  功能:显示loading
 */
- (void)showLoading;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message hideAfter:(NSTimeInterval)second;

/**
 *  功能:显示loading
 */
- (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second;

/**
 *  功能:隐藏loading
 */
- (void)hideLoading;

/**
 *  功能:隐藏loading
 */
- (void)hideLoadingOnView:(UIView *)aView;

- (void)getValueWithUrl:(NSString *)url params:(NSDictionary *)params CompleteBlock:(BeckCompletionBlock)block;

- (void)getValueWithBeckUrl:(NSString *)url params:(NSDictionary *)params CompleteBlock:(BeckCompletionBlock)block;

@end