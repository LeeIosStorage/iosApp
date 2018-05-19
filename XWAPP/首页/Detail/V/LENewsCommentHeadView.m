//
//  LENewsCommentHeadView.m
//  XWAPP
//
//  Created by hys on 2018/5/19.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsCommentHeadView.h"

@interface LENewsCommentHeadView ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LENewsCommentHeadView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    if (self == [super init]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
    UIView *topView = [UIView new];
    topView.backgroundColor = kAppBackgroundColor;
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(8);
    }];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = LineColor;
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"最新评论";
        _titleLabel.textColor = kAppTitleColor;
        _titleLabel.font = HitoPFSCRegularOfSize(14);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
