//
//  LENewsDetailContentView.m
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsDetailContentView.h"
#import "LENewsDetailModel.h"

@interface LENewsDetailContentView ()

@end

@implementation LENewsDetailContentView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.contentLabel];
    self.contentLabel.top = 10;
    self.contentLabel.left = 0;
}


#pragma mark -
#pragma mark - Public
- (void)updateWithData:(id)data{
    
    self.contentLabel.displaysAsynchronously = YES;
    self.contentLabel.ignoreCommonProperties = YES;
    LENewsDetailModel *detailModel = (LENewsDetailModel *)data;
    self.contentLabel.textLayout = detailModel.textLayout;
    self.contentLabel.width = self.frame.size.width;
    self.contentLabel.height = detailModel.textLayout.textBoundingSize.height;
}

#pragma mark -
#pragma mark - Set And Getters
- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
    }
    return _contentLabel;
}

@end
