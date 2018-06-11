//
//  LESearchBar.m
//  XWAPP
//
//  Created by hys on 2018/5/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESearchBar.h"

@implementation LESearchBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UITextField *searchField;
    for (UIView *v in self.subviews) {
        NSArray *subViews = v.subviews;
        for (id view in subViews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                searchField = view;
            }
//            else if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
//                [view removeFromSuperview];
//            }
        }
    }
    
    if (searchField != nil) {
        
        searchField.attributedPlaceholder = _attributedPlaceholder;
        
//        searchField.background = nil;
//        searchField.backgroundColor = [UIColor greenColor];
//        searchField.borderStyle = UITextBorderStyleNone;
    }
//
//    [self setBackgroundColor:[UIColor blueColor]];
//    self.tintColor = [UIColor redColor];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder{
    _attributedPlaceholder = attributedPlaceholder;
    [self layoutIfNeeded];
}

@end
