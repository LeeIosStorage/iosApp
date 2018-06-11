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

@property (strong, nonatomic) IBOutlet UILabel *aboutVersionLabel;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;

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
    
    NSString *localVserion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    self.aboutVersionLabel.text = [NSString stringWithFormat:@"%@ %@",appName,localVserion];
    
    self.aboutLabel.text = @"Copyright © 2018\n杭州哈妞科技有限公司";
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

- (IBAction)onlineServiceAction:(id)sender{
    
}

- (IBAction)businessAction:(id)sender{
    
}

@end
