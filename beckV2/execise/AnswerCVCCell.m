//
//  AnswerCVCCell.m
//  Beck
//
//  Created by Aimy on 14/12/27.
//  Copyright (c) 2014年 Aimy. All rights reserved.
//

#import "AnswerCVCCell.h"

@interface AnswerCVCCell ()

@property (weak, nonatomic) IBOutlet UILabel *countLbl;


@end

@implementation AnswerCVCCell

- (void)updateWithIndex:(NSInteger)aIndex
{
    self.countLbl.text = @(aIndex + 1).stringValue;
}

@end
