//
//  OutlineCell.h
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OutlineCell;

@protocol OutlineCellDelegate
-(void)countDownDelegate:(OutlineCell*)cell result:(NSString*)result;
@end

@interface OutlineCell : UITableViewCell
@property(nonatomic,assign)id <OutlineCellDelegate>delegate;
@property(nonatomic,weak)IBOutlet UILabel *textlab;
@property(nonatomic,weak)IBOutlet UILabel *detailLab;
-(void)updateWithoutlineid:(NSString*)outlineid;
@end

