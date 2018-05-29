//
//  SearchController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SearchController.h"
#import "SearchCollectionViewController.h"
#import "LENewsListModel.h"
#import "BaseOneCell.h"
#import "BaseTwoCell.h"
#import "BaseThirdCell.h"
#import "DetailController.h"
#import "LEDataStoreManager.h"

@interface SearchController ()
<
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>

HitoPropertyNSMutableArray(historyArr);
HitoPropertyNSMutableArray(searchNewsList);

@property (nonatomic, strong) SearchCollectionViewController *collecVC;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
    [self addSearchBar];
    [self addChildVC];
    
    self.searchNewsList = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
    
}

- (void)addChildVC {
    
    _collecVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchCollectionViewController"];
    _collecVC.view.frame = self.view.frame;
    [_collecVC didMoveToParentViewController:self];
    [self addChildViewController:_collecVC];
    [self.view addSubview:_collecVC.view];
    
    _collecVC.historyArr = self.historyArr;
    [_collecVC.collectionView reloadData];
    
    HitoWeakSelf;
    _collecVC.searchSelectTextBlock = ^(NSString *content) {
        [WeakSelf beginSearchAction:content];
    };
}

- (void)addSearchBar {
    
    UIView *title_ve = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-120, 44)];
    //设置titleview，不过这个view并不是我们需要的居中的view；
    self.navigationItem.titleView = title_ve;
    
//    __weak typeof(self) weakSelf = self;
//    //主线程列队一个block， 这样做 可以获取到autolayout布局后的frame，也就是titleview的frame。在viewDidLayoutSubviews中同样可以获取到布局后的坐标
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
    
    //要居中view的宽度
    CGFloat width = title_ve.width;
    self.search = [[LESearchBar alloc] init];
    self.search.searchBarStyle = UISearchBarStyleMinimal;
    self.search.userInteractionEnabled = YES;
    self.search.delegate = self;
    NSString *placeholder = @"搜索你感兴趣的内容";
    self.search.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(13) color:HitoColorFromRGB(0x666666)];
    
    self.search.frame = CGRectMake(0, 7, width, 30);
    [self.navigationItem.titleView addSubview:self.search];
    
    [self.search becomeFirstResponder];
}

- (void)beginSearchAction:(NSString *)searchText{
    
    [_search resignFirstResponder];
    _search.text = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (_search.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入搜索关键字"];
        return;
    }
    
    for (NSString *obj in self.historyArr) {
        if ([obj isEqualToString:_search.text]) {
            [self.historyArr removeObject:obj];
            break;
        }
    }
    [self.historyArr insertObject:_search.text atIndex:0];
    
    [[LEDataStoreManager shareInstance] saveSearchRecordWithArray:self.historyArr];
    _collecVC.historyArr = self.historyArr;
    [_collecVC.collectionView reloadData];
    
    [self searchRequest];
    
}

#pragma mark -
#pragma mark - Request
- (void)searchRequest{
    
    
    NSString *searchText = self.search.text;
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"255" forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
//        [WeakSelf.tableView.mj_header endRefreshing];
//        [WeakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD dismiss];
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"data"]];
        WeakSelf.searchNewsList = [[NSMutableArray alloc] initWithArray:array];
        
//        if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
//            [WeakSelf.tableView.mj_footer setHidden:YES];
//        }else{
//            [WeakSelf.tableView.mj_footer setHidden:NO];
//            WeakSelf.nextCursor ++;
//        }
        
        [WeakSelf.tableView setHidden:NO];
        WeakSelf.collecVC.view.hidden = YES;
        [WeakSelf.tableView reloadData];
        
        
    } failure:^(id responseObject, NSError *error) {
//        [WeakSelf.tableView.mj_header endRefreshing];
//        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)searchBarItem:(UIBarButtonItem *)sender {
    [self beginSearchAction:_search.text];
}

#pragma mark -
#pragma mark - Set And Getters
- (NSMutableArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [NSMutableArray arrayWithCapacity:0];
        [_historyArr addObjectsFromArray:[[LEDataStoreManager shareInstance] getSearchRecordArray]];
    }
    return _historyArr;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
//        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self beginSearchAction:_search.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.collecVC.view.hidden = NO;
    self.tableView.hidden = YES;
    [self.searchNewsList removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - TBDelegate&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchNewsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.searchNewsList.count) {
        newsModel = [self.searchNewsList objectAtIndex:indexPath.row];
    }
    NSUInteger count = newsModel.cover.count;
    MJWeakSelf;
    if (count == 1 && newsModel.type != 1) {
        static NSString *cellIdentifier = @"BaseOneCell";
        BaseOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        cell.statusView.deleButton.hidden = YES;
        [cell.statusView deleblockAction:^{
            [weakSelf deleNew:indexPath curCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        
        return cell;
    } else if (count == 3) {
        
        static NSString *cellIdentifier = @"BaseThirdCell";
        BaseThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        cell.statusView.deleButton.hidden = YES;
        [cell.statusView deleblockAction:^{
            [weakSelf deleNew:indexPath curCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"BaseTwoCell";
        BaseTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        cell.statusView.deleButton.hidden = YES;
        [cell.statusView deleblockAction:^{
            [weakSelf deleNew:indexPath curCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = [self.searchNewsList objectAtIndex:indexPath.row];
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 删除按钮
- (void)deleNew:(NSIndexPath *)indexPath curCell:(UITableViewCell *)cell {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        [_search resignFirstResponder];
    }
}

@end
