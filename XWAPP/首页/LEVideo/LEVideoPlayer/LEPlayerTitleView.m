//
//  LEPlayerTitleView.m
//  XWAPP
//
//  Created by hys on 2018/7/12.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEPlayerTitleView.h"

@implementation LEPlayerTitleView

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
//    self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.3];
    [WYCommonUtils addShadowWithView:self mode:0 size:CGSizeMake(HitoScreenH, 90)];
    self.hidden = YES;
    
    [self addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(30);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelButton.mas_right).offset(7);
        make.centerY.equalTo(self.cancelButton);
        make.right.equalTo(self).offset(-30);
    }];
}

- (void)showViewWithIsHidden{
    
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

#pragma mark -
#pragma mark - IBActions
- (void)cancelAction:(id)sender{
    if (self.cancelFullBlock) {
        self.cancelFullBlock();
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (HotUpButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [HotUpButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_back_pre"] forState:UIControlStateNormal];
        [_cancelButton setTintColor:[UIColor whiteColor]];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

@end
