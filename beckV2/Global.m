//
//  Global.m
//  beckV2
//
//  Created by yj on 15/5/25.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "Global.h"

@implementation Global
singleton_implementation(Global)
-(void)setUserValue:(id)value Key:(NSString*)key{
    if (value==nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(id)getUserWithkey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
@end
