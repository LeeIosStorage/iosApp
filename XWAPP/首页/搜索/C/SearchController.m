//
//  SearchController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SearchController.h"
#import "SearchCollectionViewController.h"


@interface SearchController () <UISearchBarDelegate>

@property (nonatomic, strong) SearchCollectionViewController *collecVC;
HitoPropertyNSMutableArray(historyArr);



@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchBar];
    [self addChildVC];
    
}

- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _historyArr;
}

- (void)addChildVC {
    _collecVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCollectionViewController"];
    _collecVC.view.frame = self.view.frame;
    [_collecVC didMoveToParentViewController:self];
    [self addChildViewController:_collecVC];
    [self.view addSubview:_collecVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addSearchBar {
    
    UIView *title_ve = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    //设置titleview，不过这个view并不是我们需要的居中的view；
    self.navigationItem.titleView = title_ve;
    
    __weak typeof(self) weakSelf = self;
    //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
    dispatch_async(dispatch_get_main_queue(), ^{
        //要居中view的宽度
        CGFloat width = HitoActureWidth(265);
        weakSelf.search = [[UISearchBar alloc] init];
        weakSelf.search.searchBarStyle = UISearchBarStyleMinimal;
        weakSelf.search.userInteractionEnabled = YES;
        weakSelf.search.delegate = self;
        weakSelf.search.placeholder = @"搜索你感兴趣的内容";
        UITextField *searchField = [weakSelf.search valueForKey:@"_searchField"];
        if (searchField) {
            [searchField setValue:HitoColorFromRGB(0x666666) forKeyPath:@"_placeholderLabel.textColor"];
            [searchField setValue:HitoPFSCMediumOfSize(13) forKeyPath:@"_placeholderLabel.font"];
            
        }
        

        //实际居中的view

        //设置一个基于window居中的坐标
        weakSelf.search.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-width)/2, 20, width, 44);
        //坐标系转换到titleview
        weakSelf.search.frame = [weakSelf.view.window convertRect:weakSelf.search.frame toView:weakSelf.navigationItem.titleView];
        //centerview添加到titleview
        [weakSelf.navigationItem.titleView addSubview:weakSelf.search];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)searchBarItem:(UIBarButtonItem *)sender {
    if ([_search.text isEqualToString:@""]) {
        return;
    }
    
    [self.historyArr insertObject:_search.text atIndex:0];



    
    
    if (0 == 1) {
        //
    } else {
        _collecVC.historyArr = self.historyArr;
        [_collecVC.collectionView reloadData];

    }
}


@end
