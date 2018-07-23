//
//  LENewsBottomInfoView.m
//  XWAPP
//
//  Created by hys on 2018/7/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsBottomInfoView.h"
#import "LENewsListModel.h"

@interface LENewsBottomInfoView ()

@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIButton *favourButton;

@property (strong, nonatomic) UIButton *commentButton;

@end

@implementation LENewsBottomInfoView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(10);
    }];
    
    [self addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.dateLabel);
    }];
    
    [self addSubview:self.favourButton];
    [self.favourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.commentButton.mas_left).offset(-20);
        make.centerY.equalTo(self.dateLabel);
    }];
}

- (void)updateViewWithData:(id)data{
    
    LENewsListModel *newsModel = (LENewsListModel *)data;
    
    NSMutableString *statusString = [NSMutableString string];
    
    NSString *dateString = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:newsModel.public_time]];
    if (dateString.length > 0) {
        [statusString appendFormat:@"%@    ",dateString];
    }
    int readCount = 1231;
    [statusString appendFormat:@"阅读%@",[WYCommonUtils numberFormatWithNum:readCount]];
    self.dateLabel.text = statusString;
    
    int commentCount = newsModel.commentCount;
    [self.commentButton setTitle:[NSString stringWithFormat:@" %d",commentCount] forState:UIControlStateNormal];
    
    [self.favourButton setTitle:[NSString stringWithFormat:@" %d",123] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = kAppSubTitleColor;
        _dateLabel.font = HitoPFSCRegularOfSize(13);
    }
    return _dateLabel;
}

- (UIButton *)favourButton{
    if (!_favourButton) {
        _favourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favourButton setTitleColor:kAppSubTitleColor forState:UIControlStateNormal];
        [_favourButton.titleLabel setFont:HitoPFSCRegularOfSize(13)];
        [_favourButton setTitle:@" 0" forState:UIControlStateNormal];
        [_favourButton setImage:[UIImage imageNamed:@"home_geren_dianzan_nor"] forState:UIControlStateNormal];
        [_favourButton setImage:[UIImage imageNamed:@"home_geren_dianzan_pre"] forState:UIControlStateSelected];
    }
    return _favourButton;
}
//
- (UIButton *)commentButton{
    if (!_commentButton) {
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentButton setTitleColor:kAppSubTitleColor forState:UIControlStateNormal];
        [_commentButton.titleLabel setFont:HitoPFSCRegularOfSize(13)];
        [_commentButton setTitle:@" 0" forState:UIControlStateNormal];
        [_commentButton setImage:[UIImage imageNamed:@"home_geren_pinglun"] forState:UIControlStateNormal];
    }
    return _commentButton;
}

@end
