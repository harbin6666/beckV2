//
//  UIImage+tool.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-24.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (tool)

/**
 *  通过颜色创建image
 *
 *  @param color 颜色
 *
 *  @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)aColor;

/**
 *  等比例缩放
 *
 *  @param size 大小
 *
 *  @return image
 */
-(UIImage*)scaleToSize:(CGSize)size;

@end
