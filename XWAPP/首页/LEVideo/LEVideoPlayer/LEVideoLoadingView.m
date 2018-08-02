//
//  LEVideoLoadingView.m
//  XWAPP
//
//  Created by hys on 2018/7/12.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoLoadingView.h"

@implementation LEVideoLoadingView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self addSubview:self.playSlider];
    __weak LEVideoLoadingView *weakSelf = self;
    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@0);
        make.centerY.equalTo(weakSelf);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(@3.f);
    }];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark --- Slider Touch Method
-(void)sliderValueChangedEnd:(LESlider *)sender
{
    if (self.sliderValueChangedBlock)
    {
        self.sliderValueChangedBlock(sender.value);
    }
}

-(void)sliderValueChanged:(LESlider *)sender
{
    if (self.sliderValueChangingBlock)
    {
        self.sliderValueChangingBlock(sender.value);
    }
}

- (void)sliderValueTouchDown:(LESlider *)sender
{
    if (self.sliderValueTouchDownBlcok) {
        self.sliderValueTouchDownBlcok(sender.value);
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (LESlider *)playSlider{
    if (!_playSlider) {
        _playSlider = [[LESlider alloc] init];
        [_playSlider setThumbImage:[UIImage imageNamed:@"le_icmpv_thumb_light"] forState:(UIControlStateNormal)];
        [_playSlider setThumbImage:[UIImage imageNamed:@"le_icmpv_thumb_light"] forState:UIControlStateDisabled];
        [_playSlider setMinimumTrackImage:[self imageWithColor:kAppThemeColor] forState:UIControlStateNormal];
        [_playSlider setMinimumTrackImage:[self imageWithColor:kAppThemeColor] forState:UIControlStateDisabled];
        [_playSlider setMaximumTrackImage:[self imageWithColor:[UIColor grayColor]]  forState:UIControlStateNormal];
        [_playSlider setMaximumTrackImage:[self imageWithColor:[UIColor grayColor]]  forState:UIControlStateDisabled];
        _playSlider.minimumValue = 0.0f;
        _playSlider.maximumValue = 100.0f;
        [_playSlider addTarget:self action:@selector(sliderValueChangedEnd:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel];
        [_playSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_playSlider addTarget:self action:@selector(sliderValueTouchDown:) forControlEvents:UIControlEventTouchDown];
        _playSlider.enabled = NO;
    }
    return _playSlider;
}

@end
