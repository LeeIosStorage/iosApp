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


@interface SYBaseController () <UISearchBarDelegate>

HitoPropertyNSMutableArray(headerArr);
HitoPropertyNSMutableArray(dataArr);
@property (nonatomic, strong) UIView *addView;

@end





@implementation SYBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPGController];
    [self setNaStyle];
    
    
    [AFNRequest requst:@"https://api.weibo.com/proxy/article/publish.json" parameters:@{@"title" : @"", @"content" : @"", @"cover" : @"", @"summary": @"text", @"": @"", @"access_token": @""} complete:^(id jsonData) {
        //
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




#pragma mark - 数据源懒加载

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (NSMutableArray *)headerArr {
    if (!_headerArr) {
        _headerArr = [@[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"] mutableCopy];
    }
    return _headerArr;
}

#pragma mark - 基础设置
- (void)setPGController {
    [super viewDidLoad];
    self.titleSizeNormal = 15;
    self.titleSizeSelected = 15;
    self.menuViewStyle = WMMenuViewStyleDefault;
    self.menuItemWidth = 80;
    self.titleFontName = @"PingFangSC-Medium";
    self.titleColorSelected = HitoRGBA(255, 75, 65, 1);
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
    baseVC.tagTitle = _headerArr[index];
    
    
    NSDictionary *dic = @{@"t1": @[@"1", @"2"], @"t2": @[@"3", @"4"]};
    HitoUserDefaults(dic, @"DIC");
    
    
    return baseVC;
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.headerArr[index];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, HitoNavBarHeight + HitoStatusBarHeight + 50, HitoScreenW, HitoScreenH - HitoTopHeight - 40 - 49);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, HitoNavBarHeight + HitoStatusBarHeight + 10, HitoScreenW - 50, 40);
    
}

#pragma mark - searchBarDelegate






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
