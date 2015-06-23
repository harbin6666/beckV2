//
//  PositionVC.m
//  beckV2
//
//  Created by yj on 15/6/20.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "PositionVC.h"
#import "Position.h"
#define padding 10
@interface PositionVC ()
@property(nonatomic,weak)IBOutlet UIView *positionView;

@end

@implementation PositionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPositions];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getPositions{
    
    NSArray *array=[SQLManager sharedSingle].getTitles;
    UIImageView*imgv=[[UIImageView alloc] initWithFrame:self.positionView.bounds];
    imgv.image=[[UIImage imageNamed:@"positionBg"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 5, 2)resizingMode:UIImageResizingModeStretch];
    imgv.userInteractionEnabled=YES;
    [self.positionView addSubview:imgv];
    CGFloat btnWidth=(self.view.frame.size.width-4*padding)/3;
    
    for (int i=0;i<array.count;i++) {
        Position*p=array[i];
        UIButton *b=[UIButton buttonWithType:UIButtonTypeCustom];
        b.frame=CGRectMake(0, 0, btnWidth, 36);
        //        b.layer.borderWidth=1;
        //        b.layer.borderColor=[UIColor blackColor].CGColor;
        [b setTitle:p.titleName forState:UIControlStateNormal];
        if ([p.titleName isEqualToString:[[Global sharedSingle] getUserWithkey:@"titleName"]]) {
            b.selected=YES;
        }else{
            b.selected=NO;
        }
        if (p.is_vaild.intValue==0) {
            b.enabled=NO;
        }else{
            b.enabled=YES;
        }
        b.titleLabel.numberOfLines=2;
        b.titleLabel.font=[UIFont systemFontOfSize:14];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setBackgroundImage:[UIImage imageNamed:@"position_sel"] forState:UIControlStateSelected];
        [b setBackgroundImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
        int y=(int)(i/3);
        int x=i%3;
        b.tag=i+10;
        [b addTarget:self action:@selector(positonClick:) forControlEvents:UIControlEventTouchUpInside];
        b.center=CGPointMake((btnWidth/2+padding)+x*(btnWidth+padding), 28+y*(36+padding));
        NSLog(@"%@",NSStringFromCGPoint(b.center));
        [self.positionView addSubview:b];
    }
}

-(void)positonClick:(UIButton*)sender
{
    NSArray *array=[SQLManager sharedSingle].getTitles;
    Position*p=array[sender.tag-10];
    [[Global sharedSingle] setUserValue:p.titleId Key:@"titleid"];
    [[Global sharedSingle] setUserValue:p.titleName Key:@"titleName"];
    for (UIButton *b in self.positionView.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected=NO;
        }
    }
    sender.selected=YES;
    UIButton *selB=(UIButton *)[self.positionView viewWithTag:sender.tag];
    selB.selected=YES;
    if (self.delegate) {
        [self.delegate selectedPostion];
    }
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
