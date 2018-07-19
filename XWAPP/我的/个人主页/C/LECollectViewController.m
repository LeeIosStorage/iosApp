//
//  LECollectViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/28.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LECollectViewController.h"
#import "LENewsListModel.h"
#import "BaseOneCell.h"
#import "BaseTwoCell.h"
#import "BaseThirdCell.h"
#import "DetailController.h"

@interface LECollectViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

HitoPropertyNSMutableArray(collectNewsList);

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) int nextCursor;

@end

@implementation LECollectViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setupSubviews{
    
    [self setTitle:@"我的收藏"];
    
    self.nextCursor = 1;
    
    self.collectNewsList = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
    
    [self addMJ];
    
}

- (void)addMJ {
    //下拉刷新
    MJWeakSelf;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        
        weakSelf.nextCursor = 1;
        weakSelf.collectNewsList = [[NSMutableArray alloc] init];
        [weakSelf getCollectRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        
        [weakSelf getCollectRequest];
    }];
    [self.tableView.mj_footer setHidden:YES];
}

#pragma mark -
#pragma mark - Set And Getters
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
#pragma mark - Request
- (void)getCollectRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetFavoriteNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetFavoriteNews%@",@""];
    BOOL needCache = NO;
    if (self.nextCursor == 1) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf.tableView.mj_header endRefreshing];
        [WeakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        if ([dataObject isEqual:[NSNull null]]) {
            return;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"data"]];
        
        if (WeakSelf.nextCursor == 1) {
            WeakSelf.collectNewsList = [[NSMutableArray alloc] init];
        }
        [WeakSelf.collectNewsList addObjectsFromArray:array];
        
        if (!isCache) {
            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                [WeakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [WeakSelf.tableView.mj_footer setHidden:NO];
                WeakSelf.nextCursor ++;
            }
        }
        
        [WeakSelf.tableView reloadData];
        
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_header endRefreshing];
        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)cancelCollectWithCell:(UITableViewCell *)cell{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.collectNewsList.count) {
        newsModel = [self.collectNewsList objectAtIndex:indexPath.row];
    }
    
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"DeleteFavoriteNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:newsModel.favoriteId forKey:@"favoriteId"];
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {

        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"取消收藏成功"];
        [WeakSelf.collectNewsList removeObjectAtIndex:indexPath.row];
        [WeakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];

    } failure:^(id responseObject, NSError *error) {

    }];
    
}

#pragma mark - TBDelegate&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectNewsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.collectNewsList.count) {
        newsModel = [self.collectNewsList objectAtIndex:indexPath.row];
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
        
        [cell.statusView deleblockAction:^{
            [weakSelf cancelCollectWithCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        cell.statusView.deleButton.hidden = YES;
        cell.statusView.cancelCollectButton.hidden = NO;
        
        return cell;
    } else if (count == 3) {
        
        static NSString *cellIdentifier = @"BaseThirdCell";
        BaseThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        [cell.statusView deleblockAction:^{
            [weakSelf cancelCollectWithCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        cell.statusView.deleButton.hidden = YES;
        cell.statusView.cancelCollectButton.hidden = NO;
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"BaseTwoCell";
        BaseTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
        }
        
        [cell.statusView deleblockAction:^{
            [weakSelf cancelCollectWithCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        cell.statusView.deleButton.hidden = YES;
        cell.statusView.cancelCollectButton.hidden = NO;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = [self.collectNewsList objectAtIndex:indexPath.row];
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
