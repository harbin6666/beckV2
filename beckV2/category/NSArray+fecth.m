//
//  NSArray+fecth.m
//  beckV2
//
//  Created by yj on 15/5/28.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "NSArray+fecth.h"

@implementation NSArray (sql)

-(NSObject*)firstSqlObj{
   NSObject*obj= [self firstObject];
    if ([obj isKindOfClass:[NSNull class]]) {
        obj=@"0";
    }
    return obj;
}

@end