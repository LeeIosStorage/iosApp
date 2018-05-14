//
//  SYDetailController.m
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SYDetailController.h"
#import <WebKit/WebKit.h>

@interface SYDetailController () <UIWebViewDelegate>

@end

@implementation SYDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *str = @"<html><body><h1>我的第一个标题</h1><p>我的第一个段落。</p></body></html><html><body><h1>我的第一个标题</h1><p>我的第一个段落。</p></body></html>";
    _webView.delegate = self;
    [_webView loadHTMLString:str baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, HitoScreenW, 500);
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TBC" forIndexPath:indexPath];
    cell.textLabel.text = @"123";
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 100)];
    v.backgroundColor = [UIColor redColor];
    [self.tableView.window bringSubviewToFront:v];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

@end
