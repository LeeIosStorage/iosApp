//
//  RootTabBar.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "RootTabBar.h"
#import "PhoneLogin.h"
#import "LELoginManager.h"
#import "SYBaseController.h"
#import "TaskCenterController.h"
#import "MineController.h"

@interface RootTabBar () <UITabBarControllerDelegate>

@end

@implementation RootTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"我的"] || [item.title isEqualToString:@"任务中心"]) {
        
        UIViewController *vc = self.viewControllers.lastObject;
        [[LELoginManager sharedInstance] needUserLogin:vc];
    }

}

#pragma mark 判断是否登录若没登录跳转到登录页面
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    if([viewController.tabBarItem.title isEqualToString:@"我的"] || [viewController.tabBarItem.title isEqualToString:@"任务中心"]){
        if (![LELoginUserManager hasAccoutLoggedin]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *currentVc = [nav.viewControllers lastObject];
        if ([currentVc isKindOfClass:[SYBaseController class]]) {
            SYBaseController *vc = (SYBaseController *)currentVc;
            [vc tabBarSelectRefreshData];
        }else if ([currentVc isKindOfClass:[TaskCenterController class]]){
            TaskCenterController *vc = (TaskCenterController *)currentVc;
            [vc tabBarSelectRefreshData];
        }else if ([currentVc isKindOfClass:[MineController class]]){
            MineController *vc = (MineController *)currentVc;
            [vc tabBarSelectRefreshData];
        }
    }
}

@end
