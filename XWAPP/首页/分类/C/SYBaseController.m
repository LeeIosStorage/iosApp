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

@interface SYBaseController () <UISearchBarDelegate>
{
    
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPGController];
    [self setNaStyle];
    
    [self getNewsChannelRequest];
    
}

#pragma mark -
#pragma mark - Request
- (void)getNewsChannelRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetAllChannel"];
    [self.networkManager POST:requestUrl needCache:YES caCheKey:@"GetAllChannel" parameters:nil responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
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
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:arr2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        WeakSelf.headerArr = [NSMutableArray arrayWithArray:inUseTitles];
        [[LEDataStoreManager shareInstance] saveInUseChannelWithArray:inUseTitles];

        [WeakSelf reloadData];
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
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(38, 28, HitoScreenW - 76, 26)];
    search.searchBarStyle = UISearchBarStyleMinimal;
//    self.navigationItem.titleView = search;
    search.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:search];
    [self.view addSubview:search];
    search.placeholder = @"123";
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    // 添加 按钮名字
    [button setTitle:@"" forState:(UIControlStateNormal)];
    // 添加点击方法
    [button addTarget:self action:@selector(actionButton) forControlEvents:(UIControlEventTouchUpInside)];
    // 自适应大小
    button.frame = CGRectMake(0, 0, HitoScreenW, 26);
    // 添加到 表头 title
    self.navigationItem.titleView = button;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];

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
    
    
//    NSDictionary *dic = @{@"t1": @[@"1", @"2"], @"t2": @[@"3", @"4"]};
//    HitoUserDefaults(dic, @"DIC");
    
    
    return baseVC;
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    LEChannelModel *channelModel = self.headerArr[index];
    return channelModel.name;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, HitoNavBarHeight + HitoStatusBarHeight + 32, HitoScreenW, HitoScreenH - HitoTopHeight - 32 - 49);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, HitoNavBarHeight + HitoStatusBarHeight, HitoScreenW - 50, 32);
    
}

#pragma mark - searchBarDelegate






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
