//
//  LEWebViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/29.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEWebViewController.h"
#import <WebKit/WebKit.h>

@interface LEWebViewController ()
<
WKUIDelegate,
WKNavigationDelegate
>
@property (strong, nonatomic) NSURL *URL;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) WKWebView *webView;

@property (strong, nonatomic) CALayer *progresslayer;

@end

@implementation LEWebViewController

- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        // 对网址进行userid token拼接处理
        NSMutableString *urlString = [NSMutableString string];
        [urlString appendString:[url absoluteString]];
//        if ([urlString containsString:@"?"]) {
//            if ([WYLoginUserManager userID]) {
//                [urlString appendString:[NSString stringWithFormat:@"&userId=%@",[WYLoginUserManager userID]]];
//            }
//        } else {
//            if ([WYLoginUserManager userID]) {
//                [urlString appendString:[NSString stringWithFormat:@"?userId=%@",[WYLoginUserManager userID]]];
//            }
//        }
//
//        if ([WYLoginUserManager authToken]) {
//            [urlString appendString:[NSString stringWithFormat:@"&token=%@",[WYLoginUserManager authToken]]];
//        }
//        self.canShare = YES;
        
        self.urlString = urlString;
        self.URL = [NSURL URLWithString:self.urlString];
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    self.webView = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.webView) {
        [self createWebView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)createWebView
{
    //    WKUserContentController* userContentController = WKUserContentController.new;
    //    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    //    webViewConfig.userContentController = userContentController;
    //    webViewConfig.processPool = [BAWKWebViewCookieSyncManager shareManager].processPool;
    //    WKUserScript * cookieScript = [[WKUserScript alloc] initWithSource:[self cookieJavaScriptString] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    //    [userContentController addUserScript:cookieScript];
    
    
    WKWebView *webView = [[WKWebView alloc] init];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HitoScreenW, 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = kAppThemeColor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    
    self.webView = webView;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self loadURL:self.URL];
}

- (void)loadURL:(NSURL *)url{
     //设置userAgent
    NSString *agent = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"];
    if (agent == nil) {
        
        //get the original user-agent of webview
        
        [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSString *oldAgent = result;
            NSString *newAgent = [oldAgent stringByAppendingFormat:@" LettBrowser/%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
            NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        }];
        
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
//        NSString *oldAgent = @"";
//
//        NSLog(@"old agent :%@", oldAgent);
//
//        //add my info to the new agent
//        NSString *newAgent = [oldAgent stringByAppendingFormat:@"LettBrowser/%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]];
//        NSLog(@"new agent :%@", newAgent);
//
//        //regist the new agent
//        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
//        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"skey=skeyValue" forHTTPHeaderField:@"Cookie"];
    [self.webView loadRequest:request];
    
}

#pragma mark -
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progresslayer.opacity = 1;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
            return;
        }
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
        if ([change[@"new"] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark -
#pragma mark WKNavgationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    NSString *requestPath = [[request URL] absoluteString];
    
    NSRange downloadInfo = [requestPath rangeOfString:@"itms-services://"];
    if (downloadInfo.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestPath]];
    }
    decisionHandler(actionPolicy);
}



// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
//    LELog(@"didCommitNavigation");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.title = webView.title;
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    LELog(@"didFailProvisionalNavigation");
}

#pragma mark -
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
}

- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
{
    
}

//- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
//{
//    return YES;
//}

@end
