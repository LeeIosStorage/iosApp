//
//  SYBaseVC.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SYBaseVC.h"
#import "BaseOneCell.h"
#import "BaseTwoCell.h"
#import "BaseThirdCell.h"
#import "RefrestInfoView.h"
#import "DelAlertView.h"

#import "DetailController.h"
#import "SYDetailController.h"
#import "LENewsListModel.h"

@interface SYBaseVC ()
{
    UIView *_cellMaskView;
    BOOL _shieldingCellMaskView;
    
    int _newestDatapages;
    NSDate *_startUpdatedTime;
    NSDate *_endUpdatedTime;
}

@property (strong, nonatomic) NSMutableArray *newsList;
@property (strong, nonatomic) NSMutableArray *updateNewsList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) int nextCursor;

@end

@implementation SYBaseVC

#pragma mark -
#pragma mark - Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshData{
    if (!self.tableView.mj_header) {
        [self addMJ];
    }
}

- (void)tabBarSelectRefreshData{
    if (![self.tableView.mj_header isRefreshing] && !self.tableView.mj_header.hidden) {
        CGPoint offset = self.tableView.contentOffset;
        if (offset.y > 200) {
            offset.y = 0;
            [self.tableView setContentOffset:offset animated:NO];
            HitoWeakSelf;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [WeakSelf.tableView.mj_header beginRefreshing];
            });
        }else{
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

#pragma mark -
#pragma mark - Private
- (void)setupSubviews{
    
    _newestDatapages = 1;
    _startUpdatedTime = [NSDate date];
    self.newsList = [[NSMutableArray alloc] init];
    self.updateNewsList = [[NSMutableArray alloc] init];
    
    _shieldingCellMaskView = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseOneCell" bundle:nil] forCellReuseIdentifier:@"BaseOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseTwoCell" bundle:nil] forCellReuseIdentifier:@"BaseTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseThirdCell" bundle:nil] forCellReuseIdentifier:@"BaseThirdCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
}

- (void)endRereshShowTipView:(int)updateCount{
    
    if (updateCount <= 0) {
        return;
    }
    
    RefrestInfoView *refrest = [[[NSBundle mainBundle] loadNibNamed:@"RefrestInfoView" owner:self options:nil] firstObject];
    refrest.titleLB.text = [NSString stringWithFormat:@"丨乐%@丨已为你更新 %d条内容", @"头条", updateCount];//self.tagTitle
    self.tableView.tableHeaderView = refrest;
    self.tableView.mj_header.hidden = YES;
    
    dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
        
        __block CGPoint offset = self.tableView.contentOffset;
        CGFloat offsetY = refrest.frame.size.height-offset.y;
//        LELog(@"%@",NSStringFromCGPoint(offset));
        
        UITableViewCell *cell = nil;
        for (UIView *subView in self->_cellMaskView.subviews) {
            if ([subView isKindOfClass:[UITableViewCell class]]) {
                cell = (UITableViewCell *)subView;
            }
        }
        CGRect frame = cell.frame;
        
        if (offsetY > 0) {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.tableView.tableHeaderView = nil;
                self.tableView.mj_header.hidden = NO;
                cell.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            [UIView animateWithDuration:0.05 animations:^{
                self.tableView.tableHeaderView = nil;
                self.tableView.mj_header.hidden = NO;
                cell.frame = frame;
            } completion:^(BOOL finished) {
                
            }];
        }
        
    });
    
}

- (void)removeCellMaskView{
    if (_cellMaskView) {
        [_cellMaskView removeFromSuperview];
        _indexPath = nil;
        _shieldingCellMaskView = NO;
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark - Request
//默认type=0  =1时新数据小于10条再去加载老数据
- (void)getNewsRequest:(int)type{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelId forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:_startUpdatedTime]] forKey:@"start"];
    if (!_endUpdatedTime) [NSDate date];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:_endUpdatedTime]] forKey:@"end"];
    
    LELog(@"GetNews params = %@",params);
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetNews%@",self.channelId];
    BOOL needCache = NO;
    if (self.nextCursor == 1 && _startUpdatedTime) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf removeCellMaskView];
        
        if (!isCache) {
            [WeakSelf.tableView.mj_footer endRefreshing];
        }
        if (requestType != WYRequestTypeSuccess) {
            if (!isCache) {
                [WeakSelf.tableView.mj_header endRefreshing];
            }
            return ;
        }
        
        BOOL needRefresh = NO;
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"data"]];
        self->_newestDatapages = [[dataObject objectForKey:@"page"] intValue];
        
        if (isCache) {
            WeakSelf.newsList = [[NSMutableArray alloc] init];
            
        }else{
            
            if (self->_startUpdatedTime) {
                if (self.nextCursor == 1) {
                    WeakSelf.updateNewsList = [[NSMutableArray alloc] init];
                    [WeakSelf endRereshShowTipView:(int)array.count];
                    if (self->_newestDatapages > 1) {
                        WeakSelf.newsList = [[NSMutableArray alloc] init];
                    }
                }
                NSUInteger index = WeakSelf.updateNewsList.count;
                if (index > WeakSelf.newsList.count) {
                    index = WeakSelf.newsList.count;
                }
                [WeakSelf.newsList insertObjects:array atIndex:index];
                [WeakSelf.updateNewsList addObjectsFromArray:array];
                
                if (WeakSelf.newsList.count <= 0) {
                    needRefresh = YES;
                }else{
                    [WeakSelf.tableView.mj_header endRefreshing];
                }
                
            }else{
                
                [WeakSelf.tableView.mj_header endRefreshing];
                [WeakSelf.newsList addObjectsFromArray:array];
                
            }
            
            BOOL resetFooterAdd = NO;
            if (self->_startUpdatedTime && self->_newestDatapages == WeakSelf.nextCursor) {
                self->_endUpdatedTime = self->_startUpdatedTime;
                self->_startUpdatedTime = nil;
                WeakSelf.nextCursor = 1;
                resetFooterAdd = YES;
            }
            if (needRefresh) {
                [WeakSelf getNewsRequest:1];
            }
            
            if (resetFooterAdd) {
                [WeakSelf.tableView.mj_footer setHidden:NO];
                [WeakSelf.tableView.mj_footer resetNoMoreData];
            }else{
                if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                    [WeakSelf.tableView.mj_footer setHidden:NO];
                    [WeakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [WeakSelf.tableView.mj_footer setHidden:NO];
                    WeakSelf.nextCursor ++;
                    [WeakSelf.tableView.mj_footer resetNoMoreData];
                }
            }
        }
        
        if (WeakSelf.newsList.count == 0) {
            [WeakSelf.tableView.mj_footer setHidden:YES];
            [WeakSelf.tableView.mj_footer resetNoMoreData];
        }
        
        [WeakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf removeCellMaskView];
        [WeakSelf.tableView.mj_header endRefreshing];
        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)newsShieldRequestWithReasons:(NSArray *)reasons{
    
    LENewsListModel *newsModel = [self.newsList objectAtIndex:_indexPath.row];
    LENewsListModel *updateNewsModel = nil;
    if (_indexPath.row >= 0 && _indexPath.row < [self.updateNewsList count]) {
        updateNewsModel = self.updateNewsList[_indexPath.row];
    }
//    HitoWeakSelf;
//    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@""];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:newsModel.newsId forKey:@"newsId"];
//    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
//
//        if (requestType != WYRequestTypeSuccess) {
//            return ;
//        }
//
//        [SVProgressHUD showCustomSuccessWithStatus:@"已减少此内容推荐"];
//
//    } failure:^(id responseObject, NSError *error) {
//
//    }];
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    [_cellMaskView removeFromSuperview];
    [self.tableView reloadData];
    _shieldingCellMaskView = YES;
    
    HitoWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WeakSelf.newsList removeObject:newsModel];
        [WeakSelf.updateNewsList removeObject:updateNewsModel];
        if (self->_indexPath == nil) {
            [WeakSelf.tableView reloadData];
            return;
        }
        [WeakSelf.tableView deleteRowsAtIndexPaths:@[self->_indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self->_indexPath = nil;
        self->_shieldingCellMaskView = NO;
        [SVProgressHUD showCustomInfoWithStatus:@"已减少此内容推荐"];
    });
}

#pragma mark - TBDelegate&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.newsList.count) {
        newsModel = [self.newsList objectAtIndex:indexPath.row];
    }
    NSUInteger count = newsModel.cover.count;
    MJWeakSelf;
    if (count == 1 && newsModel.type != 1) {
        BaseOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOneCell"];
        
        [cell.statusView deleblockAction:^{
            [weakSelf deleNewCurCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        
        return cell;
    } else if (count == 3) {
        BaseThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseThirdCell"];
        [cell.statusView deleblockAction:^{
            [weakSelf deleNewCurCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        
        return cell;
    } else {
        BaseTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTwoCell"];
        [cell.statusView deleblockAction:^{
            [weakSelf deleNewCurCell:cell];
        }];
        
        [cell updateCellWithData:newsModel];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = [self.newsList objectAtIndex:indexPath.row];
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 删除按钮
- (void)deleNewCurCell:(UITableViewCell *)cell {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if ([_indexPath isEqual:indexPath]) {
        return;
    }
    
    _indexPath = indexPath;
    if (_indexPath == nil) {
        return;
    }
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    CGRect rect1 = [self.tableView convertRect:rectInTableView toView:[UIApplication sharedApplication].delegate.window];
    //判断cell是否全部显示
    if (rect.origin.y < 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + rect.origin.y) animated:YES];

        
    } else if ((NSInteger)(rect.origin.y + rect.size.height + 160) > (NSInteger)(self.tableView.frame.size.height)) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + rect.origin.y + rect.size.height + 160 - self.tableView.frame.size.height) animated:YES];
    } else {
        [self addTempView:rect1];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (_indexPath && !_shieldingCellMaskView) {
        CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:_indexPath];
        CGRect rect1 = [self.tableView convertRect:rectInTableView toView:[UIApplication sharedApplication].delegate.window];
        [self addTempView:rect1];
    }
}

- (void)addTempView:(CGRect)rect {
    //添加蒙层
    _cellMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    _cellMaskView.backgroundColor = kAppMaskOpaqueBlackColor;
    DelAlertView *delView = [[[NSBundle mainBundle] loadNibNamed:@"DelAlertView" owner:self options:nil] firstObject];
    delView.count = 0;
    delView.frame = CGRectMake(rect.origin.x, rect.origin.y, HitoScreenW, 160);
    

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.frame = rect;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [_cellMaskView addGestureRecognizer:tap];
    [UIView animateWithDuration:0.2 animations:^{
        LELog(@"%f", rect.origin.y);
        delView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, HitoScreenW, 160);
    }];
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:_cellMaskView];
    [_cellMaskView addSubview:delView];
    [_cellMaskView addSubview:cell];
    
    HitoWeakSelf;
    delView.delAlertViewShieldClickBlock = ^(NSArray *reasons) {
        [WeakSelf newsShieldRequestWithReasons:reasons];
//        [WeakSelf removeView:tap];
    };
    
}

- (void)removeView:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
    if (_indexPath == nil) {
        [self.tableView reloadData];
        return;
    }
    [self.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
    _indexPath = nil;
    _shieldingCellMaskView = NO;
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    MJWeakSelf;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        if (![weakSelf.tableView.mj_header isRefreshing]) {
            return;
        }
        self->_endUpdatedTime = [NSDate date];
        self->_startUpdatedTime = weakSelf.tableView.mj_header.lastUpdatedTime;
        if (self->_startUpdatedTime == nil) {
            self->_startUpdatedTime = [NSDate dateWithTimeInterval:-1*60*60 sinceDate:[NSDate date]];
        }
        
        self->_newestDatapages = 1;
        weakSelf.nextCursor = 1;
        [weakSelf getNewsRequest:0];
    }];
    self.tableView.mj_header.lastUpdatedTimeKey = [NSString stringWithFormat:@"MJRefreshHeaderLastUpdatedTimeKey_%@",self.channelId];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            return;
        }
        [weakSelf getNewsRequest:0];
    }];
    [self.tableView.mj_footer setHidden:YES];
}

#pragma mark -
#pragma mark - Set And Getters
- (NSMutableArray *)newsList{
    if (!_newsList) {
        _newsList = [[NSMutableArray alloc] init];
    }
    return _newsList;
}

@end
