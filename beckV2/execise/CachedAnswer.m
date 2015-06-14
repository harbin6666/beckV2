//
//  CachedAnswer.m
//  beckV2
//
//  Created by yj on 15/6/15.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import "CachedAnswer.h"

@implementation CachedAnswer
-(void)saveCache:(id)answer outlineid:(NSString*)outlineid{
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:answer];
    [[NSUserDefaults standardUserDefaults] setObject:udObject forKey:outlineid];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray*)getCacheByOutlineid:(NSString *)outlineid{
    NSData *data=[[NSUserDefaults standardUserDefaults] valueForKey:outlineid];
    NSMutableArray *ar= [NSKeyedUnarchiver unarchiveObjectWithData:data];
   return ar;
}
@end
