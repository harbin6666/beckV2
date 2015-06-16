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
@property (weak, nonatomic) IBOutlet UIImageView *xunzhang4;
@property(nonatomic)NSInteger progressInt;
@property(nonatomic)NSInteger point;

@end

@implementation HonorTVCell

- (void)updateWithPoint:(NSNumber *)point
{
    self.point=point.integerValue;
    if (point.integerValue>150000) {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = YES;
        self.xunzhang3.highlighted = YES;
        self.xunzhang4.highlighted = YES;
        self.progressInt=3;
    }else if (point.integerValue > 100000) {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = YES;
        self.xunzhang3.highlighted = YES;
        self.xunzhang4.highlighted = NO;
        self.progressInt=2;
    }
    else if (point.integerValue > 50000) {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = YES;
        self.xunzhang3.highlighted = NO;
        self.xunzhang4.highlighted = NO;
        self.progressInt=1;
    }
    else {
        self.xunzhang1.highlighted = YES;
        self.xunzhang2.highlighted = NO;
        self.xunzhang3.highlighted = NO;
        self.xunzhang4.highlighted = NO;
        self.progressInt=0;
    }
}
-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGContextFillRect(context, CGRectMake(self.center.x-120, rect.size.height-20, 240, 10));
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);

    CGContextFillRect(context, CGRectMake(self.center.x-120, rect.size.height-20, 240*self.point/150000, 10));
    CGContextRestoreGState(context);
    CGContextSaveGState(context);

    float x=0;
    for (int i = 0; i < 4; i++) {
        
        //Draw Selection Circles
        if (self.progressInt/150000<i) {
            CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        }else{
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        }
        if (i==0) {
            x=self.center.x-124-10;
        }else if (i==1){
            x=self.center.x-46-10;
        }else if (i==2){
            x=self.center.x+46-10;
        }else{
            x=self.center.x+124-10;
        }
        CGContextFillEllipseInRect(context, CGRectMake(x, rect.size.height-25, 20, 20));
    }
    

}
@end

