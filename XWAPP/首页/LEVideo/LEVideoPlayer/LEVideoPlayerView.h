//
//  LEVideoPlayerView.h
//  XWAPP
//
//  Created by hys on 2018/7/11.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LEPlayControlBar.h"
#import "LEPlayerTitleView.h"
#import "LEPlayerStatusView.h"
#import "LEVideoShareView.h"

typedef void(^PlayerChangeOrientationToFull) (BOOL );
typedef void(^PlayerErrorHandleBlock) (NSError *);

typedef NS_ENUM(NSInteger, PlayerStatus) {
    PlayerItemStatus_UnKnown= 0,
    PlayerItemStatus_ReadyToPlay ,
    PlayerItemStatus_Failed,
};

@interface PlayerStatusModel : NSObject

@property (assign, nonatomic) PlayerStatus status;
@property (strong, nonatomic) id           message;

@end

@interface LEVideoPlayerView : UIView

@property (strong, nonatomic) PlayerStatusModel                 *statusModel;

@property (strong, nonatomic) LEPlayControlBar                  *playControlBar;//底部Bar
@property (strong, nonatomic) LEPlayerTitleView                 *playerTitleView;//头部Bar
@property (strong, nonatomic) LEPlayerStatusView                *playerStatusView;//播放状态View

@property (strong, nonatomic) LEVideoShareView                  *videoShareView;//结束之后分享view

//所有错误经过可选择经过此处回调
@property (copy, nonatomic) PlayerErrorHandleBlock              playerErrorHandleBlock;
@property (copy, nonatomic) PlayerChangeOrientationToFull       playerChangeOrientationToFull;

@property (assign, nonatomic) BOOL                              isFromBackgroundCallBack;

@property (assign, nonatomic) BOOL                              isFullScreen;

- (void)setupPlayerWith:(NSURL *)videoURL;

- (BOOL)isPlaying;

- (void)stopPlaying;

- (void)playAction;

- (void)pauseAction;

- (void)resetPlayerWithURL:(NSURL *)videoURL;

@end

@interface LEVideoPlayerView (PlayerUtils)

- (NSString *)convertTime:(CGFloat)second;

@end
