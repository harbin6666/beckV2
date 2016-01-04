//
//  ExamScreenVC.h
//  beckV2
//
//  Created by yj on 15/6/8.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamScreenVC : UITableViewController
@property(nonatomic,strong)NSArray *papers;
@property(nonatomic,strong)NSString *screenNo;
@property(nonatomic)BOOL exam;
@end
