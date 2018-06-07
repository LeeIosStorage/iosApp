//
//  LESegmentedView.h
//  XWAPP
//
//  Created by hys on 2018/6/5.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LESegmentedTitle @"title"
#define LESegmentedImage @"image"
#define LESegmentedHImage @"h_image"
#define LESegmentedCount @"count"

typedef void(^SegmentedSelectItem)(NSInteger index);

@interface LESegmentedView : UIView

@property (copy, nonatomic) SegmentedSelectItem segmentedSelectItem;

- (void)setSegmentedWithArray:(NSArray *)array;

- (void)updateRedCountWith:(int)count index:(NSInteger)index;

@end
