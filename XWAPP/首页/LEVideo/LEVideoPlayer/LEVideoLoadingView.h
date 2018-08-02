//
//  LEVideoLoadingView.h
//  XWAPP
//
//  Created by hys on 2018/7/12.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESlider.h"

typedef void(^SliderValueChangedBlock) (float  value);
typedef void(^SliderValueChangingBlock) (float  value);
typedef void(^SliderValueTouchDownBlcok) (float  value);

@interface LEVideoLoadingView : UIView

@property (strong, nonatomic) LESlider                  *playSlider;

@property (strong, nonatomic) SliderValueTouchDownBlcok sliderValueTouchDownBlcok;
@property (strong, nonatomic) SliderValueChangedBlock   sliderValueChangedBlock;
@property (strong, nonatomic) SliderValueChangingBlock  sliderValueChangingBlock;

@end
