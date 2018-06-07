//
//  LEEarningRankBottomView.m
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEEarningRankBottomView.h"

@interface LEEarningRankBottomView ()

@property (strong, nonatomic) UILabel *topLabel;
@property (strong, nonatomic) UILabel *userIdLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *apprenticeLabel;

@end

@implementation LEEarningRankBottomView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.textColor = kAppTitleColor;
    self.topLabel.font = HitoPFSCRegularOfSize(14);
    self.topLabel.text = @"未上榜";
    [self addSubview:self.topLabel];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.centerY.equalTo(self);
    }];
    
    self.userIdLabel = [[UILabel alloc] init];
    self.userIdLabel.textColor = kAppTitleColor;
    self.userIdLabel.font = HitoPFSCRegularOfSize(14);
    self.userIdLabel.textAlignment = NSTextAlignmentCenter;
    self.userIdLabel.text = @"我";
    [self addSubview:self.userIdLabel];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(117);
        make.centerY.equalTo(self);
    }];
    
    self.moneyLabel = [[UILabel alloc] init];
    self.moneyLabel.textColor = kAppTitleColor;
    self.moneyLabel.font = HitoPFSCRegularOfSize(14);
    self.moneyLabel.text = @"0";
    [self addSubview:self.moneyLabel];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.centerY.equalTo(self);
    }];
    
    self.apprenticeLabel = [[UILabel alloc] init];
    self.apprenticeLabel.textColor = kAppTitleColor;
    self.apprenticeLabel.font = HitoPFSCRegularOfSize(14);
    self.apprenticeLabel.text = @"0";
    [self addSubview:self.apprenticeLabel];
    [self.apprenticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-HitoActureHeight(137));
        make.centerY.equalTo(self);
    }];
    
}

- (void)updateViewWithData:(id)data{
    self.topLabel.text = @"未上榜";
    self.moneyLabel.text = @"1200";
    self.apprenticeLabel.text = @"200";
}

@end
