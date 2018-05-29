//
//  HotUpButton.m
//  WangYu
//
//  Created by KID on 15/3/26.
//
//

#import "HotUpButton.h"

@implementation HotUpButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = 0.0;
    CGFloat heightDelta = 0.0;
    if (_hotSpot) {
        widthDelta = MAX(_hotSpot - bounds.size.width, 0);
        heightDelta = MAX(_hotSpot - bounds.size.height, 0);
    }else {
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        widthDelta = MAX(44.0 - bounds.size.width, 0);
        heightDelta = MAX(44.0 - bounds.size.height, 0);
    }
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
