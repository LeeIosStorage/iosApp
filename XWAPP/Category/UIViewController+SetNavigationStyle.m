//
//  UIViewController+SetNavigationStyle.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "UIViewController+SetNavigationStyle.h"

@implementation UIViewController (SetNavigationStyle)

- (void)setNaStyle {
    
    for (UINavigationItem *item in self.navigationController.navigationBar.items) {
        item.leftBarButtonItem.image = [item.leftBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.rightBarButtonItem.image = [item.rightBarButtonItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    for (UITabBarItem *item in self.tabBarController.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"btn_back_nor"]];
//    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"btn_back_nor"]];
//    self.navigationController.navigationBar.tintColor = HitoRGBA(102, 102, 102, 1);
//    self.navigationController.navigationBar.topItem.title = @"";
//    
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor = HitoRGBA(102, 102, 102, 1);

}

@end
