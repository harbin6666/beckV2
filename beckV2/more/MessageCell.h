//
//  MessageCell.h
//  beckV2
//
//  Created by yj on 15/6/13.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *titleLab;
@property(nonatomic,weak)IBOutlet UILabel *content;
@property(nonatomic,weak)IBOutlet UILabel *timeLab;

@end
