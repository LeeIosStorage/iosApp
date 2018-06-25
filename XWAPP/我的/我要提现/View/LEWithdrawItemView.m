//
//  LEWithdrawItemView.m
//  XWAPP
//
//  Created by hys on 2018/6/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEWithdrawItemView.h"

@interface LEWithdrawItemView ()

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UIImageView *cornerImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation LEWithdrawItemView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithHexString:@"b5b5b5"].CGColor;
    self.layer.borderWidth = 0.5;
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).offset(-7);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self addSubview:self.cornerImageView];
    [self.cornerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 21));
        make.top.right.equalTo(self);
    }];
    
    [self addSubview:self.clickButton];
    [self.clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)updateItemViewData:(LEWithdrawModel *)model{
    
    self.cornerImageView.highlighted = model.isSelected;
    self.layer.borderColor = [UIColor colorWithHexString:@"b5b5b5"].CGColor;
    if (model.isSelected) {
        self.layer.borderColor = kAppThemeColor.CGColor;
    }
    self.iconImageView.hidden = YES;
    self.titleLabel.text = [NSString stringWithFormat:@"%d元",[model.money intValue]];
    if (model.icon.length > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
        self.iconImageView.hidden = NO;
        self.iconImageView.image = [UIImage imageNamed:model.icon];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_centerX).offset(-4);
        }];
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)cornerImageView{
    if (!_cornerImageView) {
        _cornerImageView = [[UIImageView alloc] init];
        _cornerImageView.image = nil;
        _cornerImageView.highlightedImage = [UIImage imageNamed:@"mine_tixian"];
    }
    return _cornerImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kAppTitleColor;
        _titleLabel.font = HitoPFSCRegularOfSize(16);
    }
    return _titleLabel;
}

- (UIButton *)clickButton{
    if (!_clickButton) {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _clickButton;
}

@end
