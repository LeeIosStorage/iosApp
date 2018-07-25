//
//  LEVideoCustomViewController.m
//  XWAPP
//
//  Created by hys on 2018/7/11.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoCustomViewController.h"
#import <INTUAnimationEngine/INTUAnimationEngine.h>
#import "HotUpButton.h"

static const CGFloat kAnimationDuration = .4;

@interface LEVideoCustomViewController ()

@property (strong, nonatomic) HotUpButton *backButton;

@property (strong, nonatomic) NSString                  *videoUrl;

@property (assign, nonatomic) CGRect startRect;
@property (assign, nonatomic) CGRect endRect;

@property (assign, nonatomic) CGSize startSize;
@property (assign, nonatomic) CGSize endSize;

@property (nonatomic, assign) CGPoint startCenter;
@property (nonatomic, assign) CGPoint endCenter;

@property (nonatomic, assign) CGFloat startRotation;
@property (nonatomic, assign) CGFloat endRotation;

@property (nonatomic, assign) INTUAnimationID animationID;

@end

@implementation LEVideoCustomViewController

#pragma mark -
#pragma mark - Lifecycle
- (id)initWithUrl:(NSString *)playUrl{
    self = [super init];
    if (self) {
        self.videoUrl = playUrl;
//        self.view.backgroundColor = [UIColor clearColor];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            //兼容
            window = [UIApplication sharedApplication].windows[0];
        }
        
        self.startRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, VideoHeight);
        self.endRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
        self.startSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, VideoHeight);
        self.endSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        
        self.startCenter = CGPointMake([UIScreen mainScreen].bounds.size.width / 2 , VideoHeight / 2);
        self.endCenter = window.center;
        
        self.startRotation = 0.0;
        self.endRotation = M_PI_2;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark - Public
- (void)showViewInView:(UIView *)view
{
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC);
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, VideoHeight);
            [view addSubview:self.view];
            [self createPlayer];
        });
    });
    
//    [view addSubview:self.view];
//    [self createPlayer];
}

- (void)createPlayer{
    if (!self.videoPlayerView) {
        self.videoPlayerView = [[LEVideoPlayerView alloc] initWithFrame:CGRectZero];
        self.videoPlayerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.videoPlayerView];
        [self.videoPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.view insertSubview:self.backButton aboveSubview:self.videoPlayerView];
    }
    
    [self.videoPlayerView setupPlayerWith:[NSURL URLWithString:self.videoUrl]];
    self.videoPlayerView.playerTitleView.titleLabel.text = self.titleString;
    
    __weak __typeof(&*self)weakSelf = self;
    self.videoPlayerView.playerChangeOrientationToFull = ^(BOOL toFull) {
        if (weakSelf.toFullBlock) {
            weakSelf.toFullBlock(toFull);
        }
        if (toFull) {
            weakSelf.backButton.hidden = YES;
            weakSelf.videoPlayerView.playerTitleView.hidden = NO;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
            
        }else{
            weakSelf.backButton.hidden = NO;
            weakSelf.videoPlayerView.playerTitleView.hidden = YES;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        }
    };
    
    self.videoPlayerView.videoShareView.videoShareClickedBlock = ^(NSInteger index) {
        if (weakSelf.videoShareClickedBlock) {
            weakSelf.videoShareClickedBlock(index);
        }
    };
}

- (void)showFullAnimation
{
    __weak __typeof(&*self)weakSelf = self;
    self.animationID = [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options: INTUAnimationOptionAutoreverse
                                                     animations:^(CGFloat progress) {
                                                         weakSelf.view.center = INTUInterpolateCGPoint(self.startCenter, self.endCenter, progress);
                                                         weakSelf.view.bounds = INTUInterpolateCGRect(self.startRect, self.endRect, progress);

                                                         CGFloat rotation = INTUInterpolateCGFloat(self.startRotation, self.endRotation, progress);

                                                         weakSelf.view.transform = CGAffineTransformMakeRotation(rotation);
                                                     }
                                                     completion:^(BOOL finished) {
                                                         if (finished) {
//                                                             [weakSelf.videoPlayerView showOrHideFuncationView:NO];
                                                         }
                                                     }];
}

- (void)showNormalAnimation
{
    __weak __typeof(&*self)weakSelf = self;
//    [weakSelf.videoPlayerView showOrHideFuncationView:YES];
    self.animationID = [INTUAnimationEngine animateWithDuration:kAnimationDuration
                                                          delay:0.0
                                                         easing:INTUEaseInOutQuadratic
                                                        options: INTUAnimationOptionAutoreverse
                                                     animations:^(CGFloat progress) {

                                                         weakSelf.view.center = INTUInterpolateCGPoint(self.endCenter, CGPointMake([UIScreen mainScreen].bounds.size.width / 2, VideoHeight / 2), progress);
                                                         weakSelf.view.bounds = INTUInterpolateCGRect(self.endRect, self.startRect, progress);

                                                         CGFloat rotation = INTUInterpolateCGFloat(self.endRotation, self.startRotation, progress);

                                                         weakSelf.view.transform = CGAffineTransformMakeRotation(rotation);
                                                     }
                                                     completion:^(BOOL finished) {
                                                         if (finished) {

                                                         }
                                                     }];
}

- (void)play{
    if (!self.videoPlayerView.isPlaying) {
        [self.videoPlayerView playAction];
    }
}

- (void)pause{
    if (self.videoPlayerView.isPlaying) {
        [self.videoPlayerView pauseAction];
    }
}

- (void)resetPlayerWithURL:(NSString *)videoUrl{
    [self.videoPlayerView resetPlayerWithURL:[NSURL URLWithString:videoUrl]];
}

#pragma mark -
#pragma mark - IBActions
- (void)backAction:(id)sender{
    if (self.playerBackBlock) {
        self.playerBackBlock();
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (HotUpButton *)backButton{
    if (!_backButton) {
        _backButton = [HotUpButton buttonWithType:UIButtonTypeSystem];
        [_backButton setImage:[UIImage imageNamed:@"le_btn_back_white"] forState:UIControlStateNormal];
        [_backButton setTintColor:[UIColor whiteColor]];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.videoPlayerView.playerTitleView.titleLabel.text = _titleString;
}

@end
