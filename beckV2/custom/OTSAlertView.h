//
//  OTSAlertView.h
//
//  Created by Aimy
//  Copyright (c) 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSAlertView;
/**
 *  alertview点击按钮之后的回调block
 *
 *  @param alertView   对象
 *  @param buttonIndex 点击的button的序号，从0开始
 */
typedef void(^OTSAlertViewBlock)(OTSAlertView *alertView, NSInteger buttonIndex);

@interface OTSAlertView : UIAlertView

@property (nonatomic, strong) id data;
/**
 *  弹框AlertView（默认有一个标题为确定的按钮）
 *
 *  @param aMessage 内容
 *  @param aBlock   回调block
 *
 *  @return OTSAlertView
 */
+ (instancetype)alertWithMessage:(NSString *)aMessage andCompleteBlock:(OTSAlertViewBlock)aBlock;
/**
 *  弹框AlertView（默认有一个标题为确定的按钮）
 *
 *  @param aTitle   标题
 *  @param aMessage 内容
 *  @param aBlock   回调block
 *
 *  @return OTSAlertView
 */
+ (instancetype)alertWithTitle:(NSString *)aTitle message:(NSString *)aMessage andCompleteBlock:(OTSAlertViewBlock)aBlock;
/**
 *  弹框AlertView
 *
 *  @param aTitle       标题
 *  @param aMessage     内容
 *  @param leftBtnName  左按钮标题
 *  @param rightBtnName 右按钮标题
 *  @param aData        保存的数据
 *  @param aBlock       回调block
 *
 *  @return OTSAlertView
 */
+ (instancetype)alertWithTitle:(NSString *)aTitle message:(NSString *)aMessage leftBtn:(NSString *)leftBtnName rightBtn:(NSString *)rightBtnName extraData:(id)aData andCompleteBlock:(OTSAlertViewBlock)aBlock;

@end
