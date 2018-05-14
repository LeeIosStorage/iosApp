//
//  CALayer+LayerColor.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "CALayer+LayerColor.h"

@implementation CALayer (LayerColor)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

- (void)setShadowColorFromUIColor:(UIColor *)color {
    self.shadowColor = color.CGColor;
}



@end
