//
//  LERedpointView.m
//  XWAPP
//
//  Created by hys on 2018/6/5.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LERedpointView.h"

@interface LERedpointView ()

@property (strong, nonatomic) UILabel *redLabel;

@end

@implementation LERedpointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor colorWithHexString:@"ee3626"];
    self.layer.cornerRadius = 9;
//    self.layer.masksToBounds = YES;
    
    self.hidden = YES;
    [self addSubview:self.redLabel];
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setText:(int)count{
    if (count <= 0) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
        NSString *text = [NSString stringWithFormat:@"%d",count];
        if (count > 9) {
            text = @"9+";
        }
        self.redLabel.text = text;
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)redLabel{
    if (!_redLabel) {
        _redLabel = [[UILabel alloc] init];
        _redLabel.textColor = [UIColor whiteColor];
        _redLabel.font = HitoPFSCRegularOfSize(10);
        _redLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _redLabel;
}

@end
