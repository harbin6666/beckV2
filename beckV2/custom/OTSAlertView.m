//
//  OTSAlertView.m
//
//  Created by Aimy
//  Copyright (c) 2014年. All rights reserved.
//

#import "OTSAlertView.h"

@interface OTSAlertView () <UIAlertViewDelegate>

@property (nonatomic, copy) OTSAlertViewBlock block;

@end

@implementation OTSAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (instancetype)alertWithMessage:(NSString *)aMessage andCompleteBlock:(OTSAlertViewBlock)aBlock
{
    return [self alertWithTitle:nil message:aMessage andCompleteBlock:aBlock];
}

+ (instancetype)alertWithTitle:(NSString *)aTitle message:(NSString *)aMessage andCompleteBlock:(OTSAlertViewBlock)aBlock
{
    return [self alertWithTitle:aTitle message:aMessage leftBtn:@"确定" rightBtn:nil extraData:nil andCompleteBlock:aBlock];
}

+ (instancetype)alertWithTitle:(NSString *)aTitle message:(NSString *)aMessage leftBtn:(NSString *)leftBtnName rightBtn:(NSString *)rightBtnName extraData:(id)aData andCompleteBlock:(OTSAlertViewBlock)aBlock
{
    if (!leftBtnName) {
        leftBtnName = @"确定";
    }
    
    if (!aTitle) {
        aTitle = @"";
    }
    
    OTSAlertView *alertView = [[self alloc] initWithTitle:aTitle message:aMessage delegate:nil cancelButtonTitle:leftBtnName otherButtonTitles:nil];
    
    alertView.delegate = alertView;
    
    if (rightBtnName) {
        [alertView addButtonWithTitle:rightBtnName];
    }
    
    alertView.data = aData;
    alertView.block = aBlock;
    alertView.delegate = alertView;
    
    return alertView;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(OTSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.block) {
        self.block(alertView,buttonIndex);
    }
    
    self.block = nil;
}


@end
