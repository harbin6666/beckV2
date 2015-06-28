//
//  QCollectionVC.h
//  beckV2
//
//  Created by yj on 15/6/3.
//  Copyright (c) 2015年 yj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QCollectionVCDelegate <NSObject>

- (void)didSelectedItemIndexInAnswerCVC:(NSInteger)index;

@end

@interface QCollectionVC : UICollectionViewController
@property (nonatomic, strong) NSArray *questions;//<questions>
@property (nonatomic, weak) id <QCollectionVCDelegate> vcDelegate;

@property (nonatomic)BOOL fromExam;
@end
