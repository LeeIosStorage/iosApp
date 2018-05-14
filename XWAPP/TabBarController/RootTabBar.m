//
//  RootTabBar.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "RootTabBar.h"
#import "PhoneLogin.h"

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
    if ([item.title isEqualToString:@"我的"]) {
        UIViewController *vv = self.viewControllers.lastObject;
        PhoneLogin *phone = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneLogin"];
        [vv presentViewController:phone animated:YES completion:^{
            //
        }];
    }

}

#pragma mark 判断是否登录若没登录跳转到登录页面
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{//每次点击都会执行的方法
    //点击购物车tabbarItem时进行一次判断
//    NSUserDefaults *userdefault =NSUserDefault;
//    NSString* str = [userdefaultvalueForKey:@"LoginStatu"];
    if([viewController.tabBarItem.title isEqualToString:@"我的"]){//判断点击的tabBarItem的title是不是购物车，如果是继续执行

        return YES;
    }
    return YES;
}









@end
