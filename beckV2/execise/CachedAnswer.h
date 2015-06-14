//
//  CachedAnswer.h
//  beckV2
//
//  Created by yj on 15/6/15.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CachedAnswer : NSObject
-(void)saveCache:(id)answer outlineid:(NSString*)outlineid;
-(NSMutableArray*)getCacheByOutlineid:(NSString *)outlineid;
@end
