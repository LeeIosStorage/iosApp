//
//  LEVideoCustomViewController.h
//  XWAPP
//
//  Created by hys on 2018/7/11.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEVideoPlayerView.h"

#define VideoHeight HitoActureHeight(210)
//[UIScreen mainScreen].bounds.size.width / 1.777777777

@interface LEVideoCustomViewController : UIViewController

@property (copy, nonatomic) void (^playerBackBlock)(void);
@property (copy, nonatomic) void (^toFullBlock)(BOOL );

@property (nonatomic, copy) VideoShareClickedBlock videoShareClickedBlock;

@property (strong, nonatomic) LEVideoPlayerView *videoPlayerView;

@property (strong, nonatomic) NSString          *titleString;

- (id)initWithUrl:(NSString *)playUrl;

- (void)showViewInView:(UIView *)view;

- (void)showFullAnimation;
- (void)showNormalAnimation;

- (void)play;

- (void)pause;

- (void)resetPlayerWithURL:(NSString *)videoUrl;

@end
