//
//  LENewsSourceView.m
//  XWAPP
//
//  Created by hys on 2018/7/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsSourceView.h"
#import "LENewsListModel.h"

@interface LENewsSourceView ()

@property (strong, nonatomic) UILabel *sourceLabel;

@end

@implementation LENewsSourceView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    [self addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(2);
//        make.bottom.equalTo(self).offset(-0);
    }];
}

- (CGFloat)updateWithData:(id)data{
    CGFloat height = 45;
    
    LENewsListModel *model = (LENewsListModel *)data;
    NSString *sourceStr = [NSString stringWithFormat:@"本文及配图均为乐资讯自媒体用户上传，不代表平台观点。"];
    if ([model.souce isEqualToString:@"中国新闻网"] || [model.souce isEqualToString:@"中青网娱乐"] || [model.souce isEqualToString:@"光明网"] || [model.souce isEqualToString:@"中国青年网"] || [model.souce containsString:@"中国"]) {
        sourceStr = [NSString stringWithFormat:@"本文为%@上传，不代表平台观点。",model.souce];
    }
    
    self.sourceLabel.text = sourceStr;
    
    return height;
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[UILabel alloc] init];
        _sourceLabel.textColor = kAppSubTitleColor;
        _sourceLabel.font = HitoPFSCRegularOfSize(12.0f);
        _sourceLabel.numberOfLines = 2;
    }
    return _sourceLabel;
}

@end
