//
//  SQLManager.h
//  beckV2
//
//  Created by yj on 15/5/30.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLManager : NSObject
singleton_interface(SQLManager);

-(NSArray*)getTitles;

-(NSDictionary*)getAddinParam;


-(NSInteger)getExamDate:(NSString*)titleid;

-(void)excuseSql:(NSString*)sql;




-(void)openDB;
@end
