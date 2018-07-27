//
//  LEVideoPlayerView.m
//  XWAPP
//
//  Created by hys on 2018/7/11.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoPlayerView.h"

static void *AVPlayerPlayloadingViewControllerRateObservationContext = &AVPlayerPlayloadingViewControllerRateObservationContext;
static void *AVPlayerPlayloadingViewControllerStatusObservationContext = &AVPlayerPlayloadingViewControllerStatusObservationContext;
static void *AVPlayerPlayloadingViewControllerCurrentItemObservationContext = &AVPlayerPlayloadingViewControllerCurrentItemObservationContext;
static void *AVPlayerPlayloadingViewControllerloadedTimeRangesObservationContext = &AVPlayerPlayloadingViewControllerloadedTimeRangesObservationContext;

@implementation PlayerStatusModel

@end

//typedef NS_ENUM(NSInteger, PlayStatus) {
//    WYplayStatus_pause  = 0,
//    WYplayStatus_playing ,
//    WYplayStatus_end,
//};

@interface LEVideoPlayerView ()
{
    id              _mTimeObserver;
    
    AVPlayerLayer   *_playerLayer;
}

//@property (nonatomic, assign) PlayStatus                                            playStatus;

@property (readwrite, strong, setter = setPlayer:, getter = player) AVPlayer        *avPlayer;

@property (strong, nonatomic) AVPlayerItem                                          *playerItem;

@property (strong, nonatomic) NSString                                              *totalTimeString;
@property (strong, nonatomic) NSString                                              *curentTimeString;

@property (assign, nonatomic) BOOL                                                  isSeeking;
@property (assign, nonatomic) BOOL                                                  isVideoToolbarHidden;

@end

@implementation LEVideoPlayerView

#pragma mark -
#pragma mark - Lifecycle

- (void)dealloc
{
    [self stopPlaying];
    LELog(@"播放器销毁了!!!");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Public
- (void)setupPlayerWith:(NSURL *)videoURL{
    if (!videoURL) {
        return;
    }
    [self setPlayerSessionWithSourceURL:videoURL];
}

- (void)stopPlaying
{
    [self removePlayerObserver];
    [self removeObserverWithPlayItem:self.player.currentItem];
    [self.avPlayer pause];
    self.player = nil;
}

- (void)playAction{
    
    NSArray *layers = self.layer.sublayers;
    NSLog(@"layerslayerslayerslayerslayerslayerslayerslayerslayers=%@",layers);
    
    if (self.isFromBackgroundCallBack) {
//        [self.playControlBar setPlayButtonPauseImage];
        if(self.statusModel.status == PlayerItemStatus_ReadyToPlay) {
            NSError *error = nil;
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:&error];
            if(error) {
                LELog(@"play back error = %@", error);
            }
            NSError *activeError = nil;
            [session setActive:YES error:&activeError];
            if (activeError) {
                LELog(@"play active error = %@", activeError);
            }
            if(self.player.currentItem) {
                [self.player play];
            }
            
            self.playerStatusView.playStatus = LEplayStatus_playing;
        }
    } else {
        [self pauseAction];
    }

}

- (void)pauseAction{
    if (self.playerStatusView.playStatus == LEplayStatus_end) {
        return;
    }
    
    self.playerStatusView.playStatus = LEplayStatus_pause;
    if (self.statusModel.status == PlayerItemStatus_ReadyToPlay) {
        //容错处理，如果网络特别差，player没有数据，直接侧滑返回会引起crash
        [self.player pause];
    }
}

- (void)resumePlay{
    __weak LEVideoPlayerView *weakSelf = self;
    self.playerStatusView.playStatus = LEplayStatus_playing;
    [self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finshed) {
        [weakSelf.player play];
    }];
}

- (BOOL)isPlaying
{
    return (self.playerStatusView.playStatus == LEplayStatus_playing) ? YES : NO;
}


- (void)resetPlayerWithURL:(NSURL *)videoURL{
    
//    if (!videoURL) {
//        return;
//    }
    [self stopPlaying];
    [self removePlayerLayer];
    [self initPlayerData];
    [self initPlayerLayer];
    
    self.playerStatusView.playStatus = LEplayStatus_loading;
    [self setupPlayerWith:videoURL];
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self initPlayerData];
    
    [self initPlayerLayer];
    
    [self initTapAction];
    [self initControlBar];
}

- (void)initPlayerData
{
    _isVideoToolbarHidden = NO;
    self.isFromBackgroundCallBack = YES;
    self.isSeeking = NO;
    self.curentTimeString = @"00:00";
    self.isFullScreen = NO;
    
    self.statusModel = [[PlayerStatusModel alloc] init];
    self.statusModel.status = PlayerItemStatus_UnKnown;
}

- (void)initControlBar{
    
    __weak LEVideoPlayerView *weakSelf = self;
    
    [self addSubview:self.playControlBar];
    [self.playControlBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self sliderValueChange];
    self.playControlBar.fullScreenBlock = ^{
        weakSelf.isFullScreen = !weakSelf.isFullScreen;
        [weakSelf toChangeViewOrientationToFull:weakSelf.isFullScreen];
    };
    
    //头部
    [self addSubview:self.playerTitleView];
    [self.playerTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    self.playerTitleView.cancelFullBlock = ^{
        if (weakSelf.isFullScreen) {
            weakSelf.isFullScreen = NO;
            [weakSelf toChangeViewOrientationToFull:NO];
        }
    };
    
    //播放状态
    [self addSubview:self.playerStatusView];
    [self.playerStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    self.playerStatusView.playStatus = LEplayStatus_loading;
    self.playerStatusView.playButtonClickedBlock = ^(UIButton *playButton) {
        [weakSelf changePlayStatus];
    };
}

- (void)initTapAction
{
    UITapGestureRecognizer *singleTapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayerViewAction:)];
    singleTapViewGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTapViewGesture];
}

-(void)initScrubberTimer
{
    double interval = .1f;
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
//        self.playSlider.minimumValue = 0.f;
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration)) {
//        CGFloat width = CGRectGetWidth([self.playSlider bounds]);
//        interval = 0.5f * duration / width;
        LELog(@"interval ---%f",interval);
    }
    __weak LEVideoPlayerView *weakSelf = self;
    _mTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                               queue:NULL
                                                          usingBlock:^(CMTime time) {
                                                              if (!weakSelf.isSeeking) {
                                                                  [weakSelf syncScrubber];
                                                              }
                                                          }];
}

//视频总时间
- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [self.player currentItem];
    if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

- (void)syncScrubber
{
    CGFloat currentSecond = self.playerItem.currentTime.value / self.playerItem.currentTime.timescale;
    self.curentTimeString = [self convertTime:currentSecond];
    self.playControlBar.playTimeLabel.text = self.curentTimeString;
    self.playControlBar.totalTimeLabel.text = self.totalTimeString;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration)) {
        self.playControlBar.loadingView.playSlider.minimumValue = 0.0;
        return;
    }
//
    double duration = CMTimeGetSeconds(playerDuration);
//    LELog(@"视频总时间duration:(%f) -- 已播放时间:(%f)",duration,currentSecond);
    if (isfinite(duration)) {
        float minValue = [self.playControlBar.loadingView.playSlider minimumValue];
        float maxValue = [self.playControlBar.loadingView.playSlider maximumValue];
        double time = CMTimeGetSeconds([self.player currentTime]);
        [self.playControlBar.loadingView.playSlider setValue:(maxValue - minValue) * time / duration + minValue];
    }
}

///计算缓冲区域
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)assetFailedToPrepareForPlayback:(NSError *)error
{
    /* Display the error. */
    if(self.playerErrorHandleBlock) {
        self.playerErrorHandleBlock(error);
    }
}

- (void)sliderValueChange{
    __weak LEVideoPlayerView *weakSelf = self;
    self.playControlBar.loadingView.sliderValueTouchDownBlcok = ^(float value) {
        weakSelf.isSeeking = YES;
    };
    self.playControlBar.loadingView.sliderValueChangingBlock = ^(float value) {
        weakSelf.isSeeking = YES;
        CMTime playerDuration = [weakSelf playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration)) {
            float minValue = [weakSelf.playControlBar.loadingView.playSlider minimumValue];
            float maxValue = [weakSelf.playControlBar.loadingView.playSlider maximumValue];
            double time = duration * (value - minValue) / (maxValue - minValue);
            weakSelf.curentTimeString = [weakSelf convertTime:time];
            weakSelf.playControlBar.playTimeLabel.text = weakSelf.curentTimeString;
        }
    };
    self.playControlBar.loadingView.sliderValueChangedBlock = ^(float value) {
        
        if(weakSelf.statusModel.status != PlayerItemStatus_ReadyToPlay) {
            [weakSelf.playControlBar.loadingView.playSlider setValue:0.f];
            return;
        }
        weakSelf.isSeeking = YES;
        CMTime playerDuration = [weakSelf playerItemDuration];
        if (CMTIME_IS_INVALID(playerDuration)) {
            return;
        }
        double duration = CMTimeGetSeconds(playerDuration);
        if (isfinite(duration)) {
            float minValue = [weakSelf.playControlBar.loadingView.playSlider minimumValue];
            float maxValue = [weakSelf.playControlBar.loadingView.playSlider maximumValue];
            float value = [weakSelf.playControlBar.loadingView.playSlider value];
            double time = duration * (value - minValue) / (maxValue - minValue);
            [weakSelf.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) completionHandler:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        weakSelf.isSeeking = NO;
                        if (weakSelf.statusModel.status == PlayerItemStatus_ReadyToPlay) {
                            weakSelf.playerStatusView.playStatus = LEplayStatus_playing;
                            [weakSelf.player play];
                        }else{
                            [weakSelf.playControlBar.loadingView.playSlider setValue:0.f];
                        }
                    }
                });
                
            }];
        }
    };
}

#pragma mark -
#pragma mark - Handel Actions
- (void)changePlayStatus
{
    if (self.playerStatusView.playStatus == LEplayStatus_end) {
        [self resumePlay];
        return;
    }
    
    if (self.playerStatusView.playStatus == LEplayStatus_pause) {
        [self playAction];
    } else if (self.playerStatusView.playStatus == LEplayStatus_playing){
        [self pauseAction];
    }
}

- (void)tapPlayerViewAction:(UITapGestureRecognizer *)gesture
{
    if (self.playerStatusView.playStatus == LEplayStatus_end) {
        return;
    }
    
    _isVideoToolbarHidden = !_isVideoToolbarHidden;

    [self.playControlBar showBottomBarWithIsHidden];
    [self.playerStatusView showViewWithIsHidden];
    
    if (self.isFullScreen) {
        [self.playerTitleView showViewWithIsHidden];
    }
}

#pragma mark -
#pragma mark - Set And Getters
+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

- (LEPlayControlBar *)playControlBar{
    if (!_playControlBar) {
        _playControlBar = [[LEPlayControlBar alloc] init];
    }
    return _playControlBar;
}

- (LEPlayerTitleView *)playerTitleView{
    if (!_playerTitleView) {
        _playerTitleView = [[LEPlayerTitleView alloc] init];
    }
    return _playerTitleView;
}

- (LEPlayerStatusView *)playerStatusView{
    if (!_playerStatusView) {
        _playerStatusView = [[LEPlayerStatusView alloc] init];
    }
    return _playerStatusView;
}

- (LEVideoShareView *)videoShareView{
    if (!_videoShareView) {
        _videoShareView = [[LEVideoShareView alloc] init];
        
        HitoWeakSelf
        _videoShareView.replayClickedBlock = ^{
            [WeakSelf resumePlay];
            [WeakSelf.videoShareView removeFromSuperview];
        };
    }
    return _videoShareView;
}

#pragma mark -
#pragma mark --- Prepare to play asset, URL
- (void)setPlayerSessionWithSourceURL:(NSURL *)sourceUrl{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    NSArray *requestedKeys = @[@"playable"];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            LELog(@"loading video ...........");
            [self prepareToPlayAsset:asset withKeys:requestedKeys];
        });
    }];
}

- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *key in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:key error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    
    if (!asset.playable) {
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription,NSLocalizedDescriptionKey,
                                   localizedFailureReason,NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        return;
    }
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self addObserverWithPlayItem:self.playerItem];
    
    if (!self.avPlayer) {
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
    }
    [self addPlayerObserver];
    
}

#pragma mark -
#pragma mark - 创建播放器
- (void)initPlayerLayer
{
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _playerLayer.frame = self.layer.bounds;
    [self.layer addSublayer:_playerLayer];
}

- (void)removePlayerLayer{
    [_playerLayer removeFromSuperlayer];
}

#pragma mark -
#pragma mark - 添加监控
- (void)addPlayerObserver
{
    [self.player addObserver:self
                  forKeyPath:@"currentItem"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:AVPlayerPlayloadingViewControllerCurrentItemObservationContext];
    [self.player addObserver:self
                  forKeyPath:@"rate"
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:AVPlayerPlayloadingViewControllerRateObservationContext];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayError:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayEnterBack:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center addObserver:self selector:@selector(videoPlayBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [center addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

/** 移除 time observer */
- (void)removePlayerObserver
{
    [self.avPlayer removeTimeObserver:_mTimeObserver];
    [self.avPlayer removeObserver:self forKeyPath:@"rate" context:AVPlayerPlayloadingViewControllerRateObservationContext];
    [self.avPlayer removeObserver:self forKeyPath:@"currentItem" context:AVPlayerPlayloadingViewControllerCurrentItemObservationContext];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [center removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:nil];
    [center removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [center removeObserver:self];
}

- (void)addObserverWithPlayItem:(AVPlayerItem *)item
{
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:AVPlayerPlayloadingViewControllerStatusObservationContext];
    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:AVPlayerPlayloadingViewControllerloadedTimeRangesObservationContext];
//    [item addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverWithPlayItem:(AVPlayerItem *)item
{
    [item removeObserver:self forKeyPath:@"status" context:AVPlayerPlayloadingViewControllerStatusObservationContext];
    [item removeObserver:self forKeyPath:@"loadedTimeRanges" context:AVPlayerPlayloadingViewControllerloadedTimeRangesObservationContext];
//    [item removeObserver:self forKeyPath:@"playbackBufferEmpty"];
//    [item removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
}

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if (context == AVPlayerPlayloadingViewControllerStatusObservationContext) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
            {
                self.statusModel.status = PlayerItemStatus_UnKnown;
                [SVProgressHUD showCustomInfoWithStatus:@"Unknown"];
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                self.statusModel.status = PlayerItemStatus_ReadyToPlay;
                self.playControlBar.loadingView.playSlider.enabled = YES;
                CGFloat totalSecond = self.player.currentItem.duration.value / (float)self.playerItem.duration.timescale;// 转换成秒
                self.totalTimeString = [self convertTime:totalSecond];
                self.playControlBar.playTimeLabel.text = self.curentTimeString;
                self.playControlBar.totalTimeLabel.text = self.totalTimeString;
                self.backgroundColor = [UIColor blackColor];
                [self initScrubberTimer];
                if (self.playerStatusView.playStatus != LEplayStatus_pause) {
                    //如果没加载完就被拖动让他自己还原
                    if (self.isFromBackgroundCallBack) {
                        if (self.player.rate == 0.f){
                            [self.playControlBar.loadingView.playSlider setValue:0.f];
                            [self playAction];
                        }
                    } else {
                        [self pauseAction];
                    }
                }
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                self.statusModel.status = PlayerItemStatus_Failed;
                self.statusModel.message = playerItem.error;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
                
            default:
                break;
        }
    } else if (context == AVPlayerPlayloadingViewControllerRateObservationContext) {
        
    } else if (context == AVPlayerPlayloadingViewControllerCurrentItemObservationContext) {
        
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        if (newPlayerItem == (id)[NSNull null]){
            
        } else {
            
        }
    } else if (context == AVPlayerPlayloadingViewControllerloadedTimeRangesObservationContext) {
        
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.player.currentItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        LELog(@"load time ranges timeInterval == %f  totalDuration == %.2f",timeInterval,totalDuration);
        
    } else {
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
}

- (void)videoPlayEnd:(NSNotification *)notic
{
//    [self useDelegateWith:LPAVPlayerStatusPlayEnd];
    self.playerStatusView.playStatus = LEplayStatus_end;
    [self.player seekToTime:kCMTimeZero];
    
    if (self.isFullScreen) {
        self.isFullScreen = NO;
        [self toChangeViewOrientationToFull:self.isFullScreen];
    }
    self.playControlBar.hidden = YES;
//    self.playerTitleView.hidden = YES;
    self.playerStatusView.hidden = YES;
    [self addSubview:self.videoShareView];
    [self.videoShareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
/** 视频异常中断 */
- (void)videoPlayError:(NSNotification *)notic
{
    LELog(@"视频异常中断");
}
/** 进入后台 */
- (void)videoPlayEnterBack:(NSNotification *)notic
{
    self.isFromBackgroundCallBack = NO;
    [self pauseAction];
}
/** 返回前台 */
- (void)videoPlayBecomeActive:(NSNotification *)notic
{
    self.isFromBackgroundCallBack = YES;
    if (self.playerStatusView.playStatus != LEplayStatus_end) {
        [self playAction];
    }
}

#pragma mark -
#pragma mark - 横竖屏约束
- (void)orientationChanged:(NSNotification *)notification {
    
    if (self.playerStatusView.playStatus == LEplayStatus_end) {
        return;
    }
    
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    if (currentOrientation == UIDeviceOrientationFaceUp) return;
    if (currentOrientation == UIDeviceOrientationLandscapeLeft) {
        if (self.isFullScreen) return;
        self.isFullScreen = YES;
    }else if (currentOrientation == UIDeviceOrientationLandscapeRight) {
        if (self.isFullScreen) return;
        self.isFullScreen = YES;
    }else {
        if (!self.isFullScreen) return;
        self.isFullScreen = NO;
    }
    [self toChangeViewOrientationToFull:self.isFullScreen];
}

- (void)toChangeViewOrientationToFull:(BOOL)toFull
{
    if (self.playerChangeOrientationToFull) {
        self.playerChangeOrientationToFull(toFull);
    }
    self.playControlBar.fullScreenButton.selected = toFull;
    if (toFull) {
        self.backgroundColor = [UIColor blackColor];
    }
}

// sizeClass 横竖屏切换时，执行
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // 横竖屏切换时重新添加约束
//    CGRect bounds = [UIScreen mainScreen].bounds;
//    [_mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(@(0));
//        make.width.equalTo(@(bounds.size.width));
//        make.height.equalTo(@(bounds.size.height));
//    }];
//    // 横竖屏判断
//    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) { // 竖屏
//        self.downView.backgroundColor = self.topView.backgroundColor = [UIColor clearColor];
//        [self.rotationButton setImage:[UIImage imageNamed:@"player_fullScreen_iphone"] forState:(UIControlStateNormal)];
//    } else { // 横屏
//        self.downView.backgroundColor = self.topView.backgroundColor = RGBColor(89, 87, 90);
//        [self.rotationButton setImage:[UIImage imageNamed:@"player_window_iphone"] forState:(UIControlStateNormal)];
//
//    }
}

@end
