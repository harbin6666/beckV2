//
//  SelectionPan.h
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PanSelectBlock)(NSInteger buttonIndex);
@interface SelectionPan : UIView
-(void)updatePanWithTitles:(NSArray*)title selectBlock:(PanSelectBlock)block;
@end
