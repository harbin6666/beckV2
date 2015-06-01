//
//  OutlineCell.m
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "OutlineCell.h"
@implementation OutlineCell


- (void)awakeFromNib {
    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
    // Initialization code
    self.textLabel.numberOfLines=2;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
