//
//  MineBottom.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MineBottom.h"
#import "UIView+Xib.h"


@implementation MineBottom


#if 1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self setupSelfNameXibOnSelf];
    [self changeLB];
}

#endif

#if 0
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //加载同名xib并添加到self

        [self setupSelfNameXibOnSelf];
        [self changeLB];
    }
    return self;
}
#endif

- (void)changeLB {
    if (HitoScreenW > 375) {
        _topLB.font = HitoPFSCMediumOfSize(12);
        _bottomLB.font = HitoPFSCMediumOfSize(18);
        _topHeight.constant = 18;
        _bottomHeight.constant = 20;
    } else {
        _topLB.font = HitoPFSCMediumOfSize(12);
        _bottomLB.font = HitoPFSCMediumOfSize (16);
        _topHeight.constant = 12;
        _bottomHeight.constant = 16;
        
    }
}

@end
