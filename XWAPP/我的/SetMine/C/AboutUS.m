//
//  AboutUS.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "AboutUS.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
