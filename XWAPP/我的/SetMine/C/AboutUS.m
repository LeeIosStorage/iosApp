//
//  AboutUS.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "AboutUS.h"
#import "WeiboSDK.h"

@interface AboutUS ()

@end

@implementation AboutUS

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setVC];
    [self setNaStyle];
}

- (void)setVC {
    [self setNaStyle];
    [self setTitle:@"关于我们"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)gotoWeibo:(id)sender{
     [WeiboSDK linkToUser:@"5701065233"];
}

@end
