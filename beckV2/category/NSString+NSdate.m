//
//  NSString+NSdate.m
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "NSString+NSdate.h"

@implementation NSString (date)
-(NSInteger)string2Date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat : @"MM/dd/yyyy"];
    
    
    NSDate *dateTime = [formatter dateFromString:self];
    
    NSDate* current=[NSDate date];
    NSTimeInterval t=[dateTime timeIntervalSinceDate:current]/(60*60*24);
    NSInteger r=ceil(t);
    return r;
}
@end
