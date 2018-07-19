//
//  LEPlayerStatusView.m
//  XWAPP
//
//  Created by hys on 2018/7/13.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEPlayerStatusView.h"
#import <SVProgressHUD/SVIndefiniteAnimatedView.h>
#import <JMRoundedCorner/UIView+RoundedCorner.h>

@interface LEPlayerStatusView ()

@property (strong, nonatomic) SVIndefiniteAnimatedView *indefiniteAnimatedView;

@property (strong, nonatomic) UIView *playView;

@end

@implementation LEPlayerStatusView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.playView.hidden = YES;
}

- (void)refreshUI{
    if (self.playStatus == LEplayStatus_loading) {
        self.playView.hidden = YES;
        [self addSubview:self.indefiniteAnimatedView];
        [self.indefiniteAnimatedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self);
        }];
        
    }else{
        [self.indefiniteAnimatedView removeFromSuperview];
        self.indefiniteAnimatedView = nil;
        
        if (self.playStatus == LEplayStatus_pause) {
            self.playView.hidden = NO;
            self.playbutton.selected = YES;
        }else if (self.playStatus == LEplayStatus_playing){
            self.playView.hidden = NO;
            self.playbutton.selected = NO;
        }else{
//            self.playView.hidden = YES;
            self.playbutton.selected = YES;
        }
    }
}

- (void)showViewWithIsHidden{
    
    if (self.playStatus == LEplayStatus_pause || self.playStatus == LEplayStatus_playing) {
        if (self.hidden){
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.hidden = NO;
                self.alpha = 1;
            } completion:^(BOOL finished)
             {
             }];
        }else{
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.alpha = 0;
            }completion:^(BOOL finished){
                self.hidden = YES;
            }];
        }
    }
}

-(void)playButtonTaped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.playButtonClickedBlock) {
        self.playButtonClickedBlock(sender);
    }
}

#pragma mark -
#pragma mark - Set And Getters

- (void)setPlayStatus:(PlayStatus)playStatus{
    _playStatus = playStatus;
    [self refreshUI];
}

- (SVIndefiniteAnimatedView *)indefiniteAnimatedView{
    if (!_indefiniteAnimatedView) {
        _indefiniteAnimatedView = [[SVIndefiniteAnimatedView alloc] initWithFrame:CGRectZero];
        _indefiniteAnimatedView.strokeColor = [UIColor whiteColor];
        _indefiniteAnimatedView.strokeThickness = 1;
        _indefiniteAnimatedView.radius = 18;
    }
    return _indefiniteAnimatedView;
}

- (UIView *)playView{
    if (!_playView) {
        _playView = [[UIView alloc] init];
//        _playView.layer.cornerRadius = 22;
//        _playView.layer.masksToBounds = YES;
//        _playView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
        
        [_playView jm_setCornerRadius:22 withBackgroundColor:[UIColor colorWithRGB:0x000000 alpha:0.3]];
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:[UIImage imageNamed:@"le_player_stop_button"] forState:UIControlStateNormal];
        [playButton setImage:[UIImage imageNamed:@"le_player_play_bottom_window"] forState:UIControlStateSelected];
        [playButton  addTarget:self action:@selector(playButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
        _playbutton = playButton;
        [_playView addSubview:playButton];
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_playView);
        }];
    }
    return _playView;
}

@end
