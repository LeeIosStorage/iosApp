//
//  StatusView.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "StatusView.h"
#import "UIView+Xib.h"

@interface StatusView ()


@end

@implementation StatusView

#if 1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self setupSelfNameXibOnSelf];
    
    [self.sourceLabel removeFromSuperview];
    [self addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(15);
        make.centerY.equalTo(self.tagLabel.mas_centerY);
    }];
}

#endif

#if 0
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //加载同名xib并添加到self
        [self setupSelfNameXibOnSelf];
    }
    return self;
}
#endif

- (IBAction)deleAction:(UIButton *)sender {
    if (_deleeBlock) {
        _deleeBlock();
    }
}

- (void)deleblockAction:(DeleBlock)deleblock {
    _deleeBlock = deleblock;
}

- (IBAction)cancelAction:(UIButton *)sender {
    if (_deleeBlock) {
        _deleeBlock();
    }
}

- (void)updateSourceConstraints:(NSInteger)type{
    if (type == 0) {
        [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel.mas_right).offset(15);
        }];
    }else{
        [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel.mas_left);
        }];
    }
}

@end
