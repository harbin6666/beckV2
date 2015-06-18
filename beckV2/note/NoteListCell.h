//
//  NoteListCell.h
//  beckV2
//
//  Created by yj on 15/6/19.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteListCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel*timeLab;
@property(nonatomic,weak)IBOutlet UILabel*titLab;
@property(nonatomic,weak)IBOutlet UILabel*noteLab;
@end
