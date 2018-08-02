//
//  LEPersonalNewsViewController.m
//  XWAPP
//
//  Created by hys on 2018/7/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEPersonalNewsViewController.h"
#import "LEPersonalHeaderView.h"
#import "LENewsTabBaseViewController.h"
#import "HJDefaultTabViewBar.h"
#import <HJTabViewController/HJTabViewBar.h>
#import <HJTabViewController/HJTabViewControllerPlugin_TabViewBar.h>
#import <HJTabViewController/HJTabViewControllerPlugin_HeaderScroll.h>
#import "LECustomNavBar.h"
#import "LELoginAuthManager.h"
#import "LEUserInfoModel.h"
#import "LELoginManager.h"

@interface LEPersonalNewsViewController ()
<
HJTabViewControllerDataSource,
HJTabViewControllerDelagate,
HJDefaultTabViewBarDelegate
>
{
    UIStatusBarStyle _currentStatusBarStyle;
    
    BOOL _isAttention;
}

@property (strong, nonatomic) LEUserInfoModel *userInfoModel;

@property (strong, nonatomic) WYNetWorkManager *netWorkManager;

@property (strong, nonatomic) LECustomNavBar *customNavBar;

@property (strong, nonatomic) LEPersonalHeaderView *headerView;

@end

@implementation LEPersonalNewsViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    [self setNaStyle];
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _currentStatusBarStyle;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    self.userInfoModel = [[LEUserInfoModel alloc] init];
    self.userInfoModel.userId = self.userId;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _currentStatusBarStyle = UIStatusBarStyleLightContent;
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tabDataSource = self;
    self.tabDelegate = self;
    HJDefaultTabViewBar *tabViewBar = [HJDefaultTabViewBar new];
    tabViewBar.normalColor = kAppTitleColor;
    tabViewBar.highlightedColor = kAppThemeColor;
    tabViewBar.delegate = self;
    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
    [self enablePlugin:tabViewBarPlugin];
    
    [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
    
    [self.view addSubview:self.customNavBar];
    [self.customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(HitoTopHeight);
    }];
    
    [self.headerView updateViewWithData:self.userInfoModel];
}

- (void)setData{
    [self.headerView updateViewWithData:self.userInfoModel];
    self.customNavBar.titleLabel.text = self.userInfoModel.nickName;
}

#pragma mark -
#pragma mark - Request
- (void)getUserInfo{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"userHome"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.userId.length > 0) [params setObject:_userId forKey:@"userId"];
    [self.netWorkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        
        WeakSelf.userInfoModel = [LEUserInfoModel modelWithJSON:dataObject];
        
        [WeakSelf setData];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)attentionRequest{
    
    if ([[LELoginManager sharedInstance] needUserLogin:self]) {
        return;
    }
    NSString *userId = self.userId;
    if ([[userId description] isEqualToString:[LELoginUserManager userID]]) {
        [SVProgressHUD showCustomInfoWithStatus:@"不能关注自己"];
        return;
    }
    HitoWeakSelf;
    
    BOOL isAttention = !self.userInfoModel.isAttention;
    [[LELoginAuthManager sharedInstance] userAttentionWithUserId:userId isAttention:isAttention result:^(BOOL success) {
        if (success) {
            WeakSelf.userInfoModel.isAttention = isAttention;
            [WeakSelf.headerView updateViewWithData:WeakSelf.userInfoModel];
        }else{
            
        }
    }];
}

#pragma mark -
#pragma mark - IBActions
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - Set And Getters
- (WYNetWorkManager *)netWorkManager{
    if (!_netWorkManager) {
        _netWorkManager = [[WYNetWorkManager alloc] init];
    }
    return _netWorkManager;
}

- (LEPersonalHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[LEPersonalHeaderView alloc] init];
        
        HitoWeakSelf;
        _headerView.attentionClickBlock = ^{
            [WeakSelf attentionRequest];
        };
    }
    return _headerView;
}

- (LECustomNavBar *)customNavBar{
    if (!_customNavBar) {
        _customNavBar = [[LECustomNavBar alloc] init];
        _customNavBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        HitoWeakSelf;
        _customNavBar.backClickBlock = ^{
            [WeakSelf backAction];
        };
    }
    return _customNavBar;
}

#pragma mark -
#pragma mark - HJDefaultTabViewBarDelegate
- (NSInteger)numberOfTabForTabViewBar:(HJDefaultTabViewBar *)tabViewBar {
    return [self numberOfViewControllerForTabViewController:self];
}

- (id)tabViewBar:(HJDefaultTabViewBar *)tabViewBar titleForIndex:(NSInteger)index {
    if (index == 0) {
        return @"文章";
    }
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"视频"];
    return attString;
}

- (void)tabViewBar:(HJDefaultTabViewBar *)tabViewBar didSelectIndex:(NSInteger)index {
    BOOL anim = labs(index - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:index animated:anim];
}

#pragma mark -
#pragma mark - HJTabViewControllerDataSource
- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
//    LELog(@"contentPercentY=%f",contentPercentY);
    self.customNavBar.backgroundColor = [UIColor colorWithWhite:1 alpha:contentPercentY];
    if (contentPercentY >= 0.65) {
        self.customNavBar.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        _currentStatusBarStyle = UIStatusBarStyleDefault;
        self.customNavBar.titleLabel.hidden = NO;
        self.customNavBar.lineImageView.hidden = NO;
        [self.customNavBar.backButton setImage:[UIImage imageNamed:@"btn_back_nor"] forState:UIControlStateNormal];
    }else{
        _currentStatusBarStyle = UIStatusBarStyleLightContent;
        self.customNavBar.titleLabel.hidden = YES;
        self.customNavBar.lineImageView.hidden = YES;
        [self.customNavBar.backButton setImage:[UIImage imageNamed:@"le_btn_back_white"] forState:UIControlStateNormal];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return 2;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    LENewsTabBaseViewController *vc = [[LENewsTabBaseViewController alloc] init];
    vc.userId = self.userId;
    vc.vcType = index;
    return vc;
}

- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    self.headerView.frame = CGRectMake(0, 0, 0, 300);
    return self.headerView;
}

- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    return HJTabViewBarDefaultHeight + 64;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
