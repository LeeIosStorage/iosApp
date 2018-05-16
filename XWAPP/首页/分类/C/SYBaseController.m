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


@interface SYBaseController () <UISearchBarDelegate>

HitoPropertyNSMutableArray(headerArr);
HitoPropertyNSMutableArray(dataArr);

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
    
//    __weak typeof(self)weakSelf = self;
//
//    [AFNRequest requst:@"http://192.168.60.170:5001/api/news/GetAllChannel" parameters:nil complete:^(id jsonData) {
//        //
//        NSLog(@"^^^^^%@",jsonData);
//        if ([jsonData isKindOfClass:[NSArray class]]) {
////            NSDictionary *dic = (NSDictionary *)jsonData;
//            NSArray *array = jsonData;
//            [weakSelf.headerArr removeAllObjects];
//            for (NSDictionary *dic in array) {
////                NSString *name = dic[@"name"];
//                [weakSelf.headerArr addObject:dic];
//            }
//            [weakSelf reloadData];
//        }
//    }];
}

#pragma mark -
#pragma mark - Request
- (void)getNewsChannelRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetAllChannel"];
    [self.networkManager GET:requestUrl needCache:YES caCheKey:@"GetAllChannel" parameters:nil responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
//        NSLog(@"^^^^^%@",dataObject);
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        if ([dataObject isKindOfClass:[NSArray class]]) {
            NSArray *array = dataObject;
            [WeakSelf.headerArr removeAllObjects];
            for (NSDictionary *dic in array) {
                [WeakSelf.headerArr addObject:dic];
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
    NSArray *arr2 = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索",@"综艺",@"美食",@"育儿"];
    
    HitoWeakSelf;
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:arr2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
        WeakSelf.headerArr = [NSMutableArray arrayWithArray:inUseTitles];
//        NSLog(@"inUseTitles = %@",inUseTitles);
//        NSLog(@"unUseTitles = %@",unUseTitles);
        WeakSelf.headerArr = [NSMutableArray arrayWithArray:inUseTitles];
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

- (NSMutableArray *)headerArr {
    if (!_headerArr) {
        _headerArr = [[NSMutableArray alloc] init];
        [_headerArr addObject:@{@"id":@"255",@"name":@"推荐"}];
//        _headerArr = [@[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"] mutableCopy];
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
    self.menuViewStyle = WMMenuViewStyleLine;
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
    
    NSDictionary *dic = self.headerArr[index];
    baseVC.tagTitle = dic[@"name"];
    baseVC.channelId = dic[@"id"];
    
    
//    NSDictionary *dic = @{@"t1": @[@"1", @"2"], @"t2": @[@"3", @"4"]};
//    HitoUserDefaults(dic, @"DIC");
    
    
    return baseVC;
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSDictionary *dic = self.headerArr[index];
    return dic[@"name"];
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
