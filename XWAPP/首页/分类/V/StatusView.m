//
//  StatusView.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "StatusView.h"
#import "UIView+Xib.h"

@implementation StatusView

#if 1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self setupSelfNameXibOnSelf];
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
    _deleeBlock();
}

- (void)deleblockAction:(DeleBlock)deleblock {
    _deleeBlock = deleblock;
}

- (IBAction)cancelAction:(UIButton *)sender {
}

@end
