//
//  ChoiceCell.h
//  beckV2
//
//  Created by yj on 15/6/2.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceItem.h"

typedef  void(^ItemSelectBlock)(BOOL right);

@interface ChoiceCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lab;
-(void)updateWithChoice:(ChoiceItem*)item;
@property(nonatomic,weak)IBOutlet UIImageView *mark;

@end
