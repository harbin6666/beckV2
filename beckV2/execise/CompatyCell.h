//
//  CompatyCell.h
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompatyQuestion.h"
#import "PractisAnswer.h"
typedef  void(^ItemSelectBlock)(BOOL right,CompatyItem *answer);
@interface CompatyCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lab;
@property(nonatomic)NSInteger row;
-(void)updateCompatyCell:(CompatyQuestion*)compatyQ customid:(NSString *)qCustomid answer:(PractisAnswer*)answer showAnswer:(BOOL)show selectedBlock:(ItemSelectBlock)block;
@end
