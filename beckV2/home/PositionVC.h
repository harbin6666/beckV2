//
//  PositionVC.h
//  beckV2
//
//  Created by yj on 15/6/20.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "BaseViewController.h"
@class Position;
@protocol PositionVCDelegate;
@interface PositionVC : UIViewController
@property(nonatomic)id<PositionVCDelegate>delegate;
@end
@protocol PositionVCDelegate <NSObject>

-(void)selectedPostion;

@end