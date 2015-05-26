//
//  HonorTVCell.m
//  beckV2
//
//  Created by yj on 15/5/26.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "HonorTVCell.h"

@interface HonorTVCell ()

@property (weak, nonatomic) IBOutlet UIImageView *xunzhang1;
@property (weak, nonatomic) IBOutlet UIImageView *xunzhang2;
@property (weak, nonatomic) IBOutlet UIImageView *xunzhang3;


@end

@implementation HonorTVCell

- (void)updateWithPoint:(NSNumber *)point
{
    if (point.integerValue > 1000) {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = YES;
        self.xunzhang3.highlighted = YES;
    }
    else if (point.integerValue > 500) {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = YES;
        self.xunzhang3.highlighted = NO;
    }
    else {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = NO;
        self.xunzhang3.highlighted = NO;
    }
}

@end

