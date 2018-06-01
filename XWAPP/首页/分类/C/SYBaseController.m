//
//  SYBaseController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SYBaseController.h"
#import "SYBaseVC.h"
#import "XLChannelControl.h"
#import "SearchController.h"
#import "WYNetWorkManager.h"
#import "WYNetWorkManager.h"
#import "LEChannelModel.h"
#import "LEDataStoreManager.h"
#import "DetailController.h"
#import "LESearchBar.h"

@interface SYBaseController () <UISearchBarDelegate>
{
    BOOL _viewDidAppear;
}

HitoPropertyNSMutableArray(headerArr);
HitoPropertyNSMutableArray(dataArr);
HitoPropertyNSArray(localInUseChannelArray);
HitoPropertyNSArray(allChannelArray);

@property (nonatomic, strong) WYNetWorkManager *networkManager;
@property (nonatomic, strong) UIView *addView;

@end

@implementation SYBaseController

#pragma mark -
#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _viewDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewDidAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPGController];
    [self setNaStyle];
    
    [self getNewsChannelRequest];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (void)tabBarSelectRefreshData{
    if (_viewDidAppear) {
        
        SYBaseVC *vc = (SYBaseVC *)self.currentViewController;
        [vc tabBarSelectRefreshData];
    }
}

#pragma mark -
#pragma mark - Request
- (void)getNewsChannelRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetAllChannel"];
    [self.networkManager POST:requestUrl needCache:YES caCheKey:@"GetAllChannel" parameters:nil responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        
        if ([dataObject isKindOfClass:[NSArray class]]) {
            WeakSelf.allChannelArray = [NSArray modelArrayWithClass:[LEChannelModel class] json:dataObject];
            if (WeakSelf.localInUseChannelArray.count <= 0) {
                [WeakSelf.headerArr removeAllObjects];
                [WeakSelf.headerArr addObjectsFromArray:WeakSelf.allChannelArray];
            }
            [WeakSelf reloadData];
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark - NavColor


#pragma mark - addBtn

- (IBAction)addBtnAction:(UIButton *)sender {
    
    NSArray *arr1 = [NSArray arrayWithArray:self.headerArr];
    
    NSMutableArray *tmpAllArr = [NSMutableArray arrayWithArray:self.allChannelArray];
    NSMutableArray *removeArr = [NSMutableArray array];
    for (LEChannelModel *model in tmpAllArr) {
        for (LEChannelModel *m in arr1) {
            if ([model.channelId isEqualToString:m.channelId]) {
                [removeArr addObject:model];
                break;
            }
        }
    }
    
    [tmpAllArr removeObjectsInArray:removeArr];
    NSArray *arr2 = [NSArray arrayWithArray:tmpAllArr];
    
    HitoWeakSelf;
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:arr2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles, NSInteger currentIndex, BOOL needRefresh) {
        
        WeakSelf.headerArr = [NSMutableArray arrayWithArray:inUseTitles];
        [[LEDataStoreManager shareInstance] saveInUseChannelWithArray:inUseTitles];

        if (needRefresh) {
            [WeakSelf reloadData];
        }
        
        if (currentIndex >= 0 && currentIndex < WeakSelf.headerArr.count) {
            [WeakSelf setSelectIndex:(int)currentIndex];
        }
    }];
}




#pragma mark -
#pragma mark - Set And Getters

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSArray *)allChannelArray{
    if (!_allChannelArray) {
        _allChannelArray = [[NSArray alloc] init];
    }
    return _allChannelArray;
}

- (NSMutableArray *)headerArr {
    if (!_headerArr) {
        _headerArr = [[NSMutableArray alloc] init];
        
        self.localInUseChannelArray = [[LEDataStoreManager shareInstance] getInUseChannelArray];
        if (_localInUseChannelArray.count > 0) {
            [_headerArr addObjectsFromArray:_localInUseChannelArray];
            return _headerArr;
        }
        
        LEChannelModel *channelModel = [[LEChannelModel alloc] init];
        channelModel.channelId = @"255";
        channelModel.name = @"推荐";
        [_headerArr addObject:channelModel];

    }
    return _headerArr;
}

- (WYNetWorkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[WYNetWorkManager alloc] init];
    }
    return _networkManager;
}


#pragma mark - 基础设置
- (void)setPGController {
    [super viewDidLoad];
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuView.layoutMode = WMMenuViewLayoutModeLeft;
    self.menuItemWidth = 55;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorSelected = kAppThemeColor;
    self.progressColor = HitoBlueColor;
    [self addSearchBar];
}

#pragma mark - 设置搜索条
- (void)addSearchBar {
    
    UIView *title_ve = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    self.navigationItem.titleView = title_ve;
    
    LESearchBar *search = [[LESearchBar alloc] initWithFrame:CGRectMake(0, 7, HitoScreenW - 110, 30)];
    search.searchBarStyle = UISearchBarStyleMinimal;
    [self.navigationItem.titleView addSubview:search];
    search.userInteractionEnabled = YES;
//    [self.view bringSubviewToFront:search];
//    [self.view addSubview:search];
    NSString *placeholder = @"搜索你感兴趣的内容";
    search.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(13) color:HitoColorFromRGB(0x666666)];
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    // 添加 按钮名字
    [button setTitle:@"" forState:(UIControlStateNormal)];
    // 添加点击方法
    [button addTarget:self action:@selector(actionButton) forControlEvents:(UIControlEventTouchUpInside)];
    // 自适应大小
    button.frame = CGRectMake(0, 7, HitoScreenW - 110, 30);
    // 添加到 表头 title
    [self.navigationItem.titleView addSubview:button];
}

- (void)actionButton {
    SearchController *search = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchController"];
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.headerArr.count;
}

#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    SYBaseVC *baseVC = [[SYBaseVC alloc] initWithNibName:@"SYBaseVC" bundle:nil];
    
    LEChannelModel *channelModel = self.headerArr[index];
    baseVC.tagTitle = channelModel.name;
    baseVC.channelId = channelModel.channelId;
    
    return baseVC;
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    LEChannelModel *channelModel = self.headerArr[index];
    return channelModel.name;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40, HitoScreenW, HitoScreenH - HitoTopHeight - 40 - 49);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, HitoScreenW - 50, 40);
    
}

#pragma mark -
#pragma mark - WMPageControllerDelegate
- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
}

- (void)pageController:(WMPageController *)pageController willCachedViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    if ([viewController isKindOfClass:[SYBaseVC class]]) {
        [viewController refreshData];
    }
}

#pragma mark - searchBarDelegate
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
