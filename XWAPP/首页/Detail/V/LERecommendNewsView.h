//
//  LERecommendNewsView.h
//  XWAPP
//
//  Created by hys on 2018/6/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectRowAtIndex) (NSInteger index);

@interface LERecommendNewsView : UIView

@property (strong, nonatomic) NSMutableArray *recommendNewsArray;

@property (strong, nonatomic) DidSelectRowAtIndex didSelectRowAtIndex;

@end
