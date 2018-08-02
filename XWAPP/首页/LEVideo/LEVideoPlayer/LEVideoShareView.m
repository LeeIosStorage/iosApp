//
//  LEVideoShareView.m
//  XWAPP
//
//  Created by hys on 2018/7/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoShareView.h"

@interface LEVideoShareView ()

@property (strong, nonatomic) UIButton *replayButton;

@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIImageView *leftLine;
@property (strong, nonatomic) UIImageView *rightLine;



@end

@implementation LEVideoShareView

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
    
    [self addSubview:self.replayButton];
    [self.replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(45);
    }];
    
    [self addSubview:self.leftLine];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipLabel.mas_left).offset(-8);
        make.centerY.equalTo(self.tipLabel);
        make.size.mas_equalTo(CGSizeMake(37, 0.5));
    }];
    [self addSubview:self.rightLine];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipLabel.mas_right).offset(8);
        make.centerY.equalTo(self.tipLabel);
        make.size.mas_equalTo(CGSizeMake(37, 0.5));
    }];
    
    NSArray *array = [NSArray arrayWithObjects:@{@"title":@"朋友圈",@"icon":@"le_share_pengyouwuan_video"},@{@"title":@"微信好友",@"icon":@"le_share_wx_video"},@{@"title":@"QQ好友",@"icon":@"le_share_qq_video"},@{@"title":@"复制链接",@"icon":@"le_share_fuzhlianjie_video"}, nil];
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *info = array[i];
        [self addItemWithIndex:i info:info];
    }
    
}

- (void)addItemWithIndex:(int)index info:(NSDictionary*)info{
    
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 65));
        make.top.equalTo(self.tipLabel.mas_bottom).offset(17);
        if (index == 0) {
            make.right.equalTo(self.mas_centerX).offset(-(44+25+12));
        }else if (index == 1){
            make.right.equalTo(self.mas_centerX).offset(-12);
        }else if (index == 2){
            make.left.equalTo(self.mas_centerX).offset(12);
        }else if (index == 3){
            make.left.equalTo(self.mas_centerX).offset(44+25+12);
        }
    }];
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:info[@"icon"]];
    [view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(view);
        make.height.equalTo(view.mas_width);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"cfcfcf"];
    label.font = HitoPFSCRegularOfSize(12);
    label.text = info[@"title"];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(view);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index+10;
    [button addTarget:self action:@selector(shareClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

#pragma mark -
#pragma mark - IBActions
- (void)replayClick{
    if (self.replayClickedBlock) {
        self.replayClickedBlock();
    }
}

- (void)shareClickAction:(UIButton *)sender{
    NSInteger index = sender.tag-10;
    if (self.videoShareClickedBlock) {
        self.videoShareClickedBlock(index);
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UIButton *)replayButton{
    if (!_replayButton) {
        _replayButton = [[UIButton alloc] init];
        [_replayButton setTitleColor:[UIColor colorWithHexString:@"cfcfcf"] forState:UIControlStateNormal];
        [_replayButton.titleLabel setFont:HitoPFSCRegularOfSize(14)];
        [_replayButton setTitle:@" 重播" forState:UIControlStateNormal];
        [_replayButton setImage:[UIImage imageNamed:@"video_xiangqing_chongbo"] forState:UIControlStateNormal];
        [_replayButton addTarget:self action:@selector(replayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replayButton;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor colorWithHexString:@"cfcfcf"];
        _tipLabel.font = HitoPFSCRegularOfSize(13);
        _tipLabel.text = @"分享到";
    }
    return _tipLabel;
}
- (UIImageView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIImageView alloc] init];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"cfcfcf"];
    }
    return _leftLine;
}

- (UIImageView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIImageView alloc] init];
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"cfcfcf"];
    }
    return _rightLine;
}

@end
