//
//  LECustomNavBar.m
//  XWAPP
//
//  Created by hys on 2018/7/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LECustomNavBar.h"

@interface LECustomNavBar ()



@end

@implementation LECustomNavBar

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
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(32);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60);
        make.right.equalTo(self).offset(-60);
        make.centerY.equalTo(self.backButton.mas_centerY);
    }];
    
    [self addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    self.lineImageView.hidden = YES;
}

#pragma mark -
#pragma mark - IBActions
- (void)backAction:(id)sender{
    if (self.backClickBlock) {
        self.backClickBlock();
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (HotUpButton *)backButton{
    if (!_backButton) {
        _backButton = [HotUpButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"le_btn_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HitoPFSCRegularOfSize(17);
        _titleLabel.textColor = kAppTitleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    }
    return _lineImageView;
}

@end
