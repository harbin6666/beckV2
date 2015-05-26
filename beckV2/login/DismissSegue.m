//
//  DismissSegue.m
//  beckV2
//
//  Created by yj on 15/5/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue
-(void)perform{
    [self.sourceViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
