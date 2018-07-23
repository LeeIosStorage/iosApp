//
//  LEVideoTabBarViewController.m
//  XWAPP
//
//  Created by hys on 2018/7/16.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoTabBarViewController.h"
#import "WYNetWorkManager.h"
#import "LEChannelModel.h"
#import "LEVideoListViewController.h"

@interface LEVideoTabBarViewController ()
{
    BOOL _viewDidAppear;
}
HitoPropertyNSMutableArray(videoChannelArray);
HitoPropertyNSArray(allChannelArray);

@property (nonatomic, strong) WYNetWorkManager *networkManager;

@end

@implementation LEVideoTabBarViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _viewDidAppear = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewDidAppear = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    
    [self getNewsChannelRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarSelectRefreshData{
    if (_viewDidAppear) {
        
        LEVideoListViewController *vc = (LEVideoListViewController *)self.currentViewController;
        [vc tabBarSelectRefreshData];
    }
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    [self setNaStyle];
    [self setPGController];
    [self addLineView];
}

- (void)setPGController {
    self.titleSizeNormal = 17;
    self.titleSizeSelected = 17;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuView.layoutMode = WMMenuViewLayoutModeLeft;
    self.menuItemWidth = 60;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorSelected = kAppThemeColor;
    self.progressColor = HitoBlueColor;
}

- (void)addLineView{
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:HitoColorFromRGB(0Xd9d9d9) size:CGSizeMake(HitoScreenW, 0.5)]];
    [self.view addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(HitoTopHeight-0.5);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark -
#pragma mark - Request
- (void)getNewsChannelRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetAllChannel"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"type"];
    [self.networkManager POST:requestUrl needCache:YES caCheKey:@"GetAllChannel" parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            WeakSelf.allChannelArray = [NSArray modelArrayWithClass:[LEChannelModel class] json:dataObject];
            [WeakSelf.videoChannelArray removeAllObjects];
            [WeakSelf.videoChannelArray addObjectsFromArray:WeakSelf.allChannelArray];
            [WeakSelf reloadData];
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (WYNetWorkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[WYNetWorkManager alloc] init];
    }
    return _networkManager;
}

- (NSArray *)allChannelArray{
    if (!_allChannelArray) {
        _allChannelArray = [[NSArray alloc] init];
    }
    return _allChannelArray;
}

- (NSMutableArray *)videoChannelArray{
    if (!_videoChannelArray) {
        _videoChannelArray = [[NSMutableArray alloc] init];
        
        LEChannelModel *channelModel = [[LEChannelModel alloc] init];
        channelModel.channelId = @"255";
        channelModel.name = @"推荐";
        [_videoChannelArray addObject:channelModel];
    }
    return _videoChannelArray;
}

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.videoChannelArray.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    LEVideoListViewController *baseVC = [[LEVideoListViewController alloc] init];
    
    LEChannelModel *channelModel = self.videoChannelArray[index];
    baseVC.tagTitle = channelModel.name;
    baseVC.channelId = channelModel.channelId;
    
    return baseVC;
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    LEChannelModel *channelModel = self.videoChannelArray[index];
    return channelModel.name;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, HitoTopHeight, HitoScreenW, HitoScreenH - HitoTopHeight - 49);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 10, HitoScreenW , HitoTopHeight);
    
}

#pragma mark -
#pragma mark - WMPageControllerDelegate

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    if ([viewController isKindOfClass:[LEVideoListViewController class]]) {
        LEVideoListViewController *baseVc = (LEVideoListViewController *)viewController;
//        [MobClick event:kHomeVideoChannelClick label:baseVc.tagTitle];
        [baseVc refreshData];
    }
}

@end
