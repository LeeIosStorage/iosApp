//
//  LECommentFooterView.m
//  XWAPP
//
//  Created by hys on 2018/5/19.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LECommentFooterView.h"

@implementation LECommentFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setupSubviews{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bottomImageView = [[UIImageView alloc] init];
    bottomImageView.backgroundColor = LineColor;
    [self addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(23);
        make.bottom.equalTo(self).offset(0);
        make.height.mas_equalTo(1);
    }];
    
}

@end
