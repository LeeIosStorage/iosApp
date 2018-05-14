//
//  MineNaView.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MineNaView.h"
#import "UIView+Xib.h"

@implementation MineNaView
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

- (IBAction)rightAction:(UIButton *)sender {
    _rightBlock();
}
- (IBAction)leftAction:(UIButton *)sender {
    _leftBlock();
}

- (void)btnActionLeft:(LeftBlock)leftBlock {
    _leftBlock = leftBlock;
}
- (void)btnActionRight:(RightBlock)rightBlock {
    _rightBlock = rightBlock;
}


@end
