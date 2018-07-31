//
//  LENetworkStatusView.m
//  XWAPP
//
//  Created by hys on 2018/7/31.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENetworkStatusView.h"

@interface LENetworkStatusView ()

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) UIButton *playButton;

@end

@implementation LENetworkStatusView

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
    self.backgroundColor = HitoRGBA(0,0,0,0.7);
    
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(-5);
    }];
    
    [self addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_centerY).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 29));
    }];
    
}

- (void)refreshUIWith:(NSInteger)type{
    if (type == 0) {
        self.tipLabel.text = @"视频加载失败";
        [self.playButton setTitle:@"点击重试" forState:UIControlStateNormal];
    }else{
        self.tipLabel.text = @"当前为非Wifi状态，继续播放将消耗流量";
        [self.playButton setTitle:@"继续播放" forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark - IBActions
- (void)replayClick{
    if (self.continueClickedBlock) {
        self.continueClickedBlock();
    }
//    [self removeFromSuperview];
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = HitoPFSCRegularOfSize(13);
        _tipLabel.textColor = [UIColor colorWithHexString:@"cfcfcf"];
    }
    return _tipLabel;
}

- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_playButton.titleLabel setFont:HitoPFSCRegularOfSize(14)];
        _playButton.layer.cornerRadius = 5;
        _playButton.layer.masksToBounds = YES;
        _playButton.layer.borderWidth = 1;
        _playButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [_playButton addTarget:self action:@selector(replayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

@end
