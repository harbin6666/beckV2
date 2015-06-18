//
//  SelectionPan.m
//  beckV2
//
//  Created by yj on 15/6/10.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "SelectionPan.h"
@interface SelectionPan()
@property(nonatomic,copy)PanSelectBlock block;
@property(nonatomic,strong)NSMutableArray *btnAr;
@end
@implementation SelectionPan

-(void)updatePanWithTitles:(NSArray *)title selectBlock:(PanSelectBlock)block{
    self.backgroundColor=[UIColor whiteColor];
    self.block=block;
    self.btnAr=[[NSMutableArray alloc] init];
    float width=self.frame.size.width/title.count;
    for (int i=0; i<title.count; i++) {
        
        UIButton *bu=[UIButton buttonWithType:UIButtonTypeCustom];
        if (i==0) {
            bu.selected=YES;
        }
        bu.frame=CGRectMake(width*i, 0, width, 50);
        [bu setTitle:title[i] forState:UIControlStateNormal];
        [bu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bu setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [bu addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        bu.tag=i;
        [self addSubview:bu];
        [self.btnAr addObject:bu];
    }
    
//    [self click:self.btnAr[0]];
}

-(void)click:(UIButton*)btn{

    for (UIButton*b in self.btnAr) {
        b.selected=NO;
    }
    btn.selected=YES;
    self.block(btn.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
