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

@property (strong, nonatomic) NSMutableArray *newsList;

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
    [self addMJ];
}

- (void)tabBarSelectRefreshData{
    if (![self.tableView.mj_header isRefreshing] && !self.tableView.mj_header.hidden) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark -
#pragma mark - Private
- (void)setupSubviews{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseOneCell" bundle:nil] forCellReuseIdentifier:@"BaseOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseTwoCell" bundle:nil] forCellReuseIdentifier:@"BaseTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseThirdCell" bundle:nil] forCellReuseIdentifier:@"BaseThirdCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
}

- (void)endRereshShowTipView{
    
    RefrestInfoView *refrest = [[[NSBundle mainBundle] loadNibNamed:@"RefrestInfoView" owner:self options:nil] firstObject];
    refrest.titleLB.text = [NSString stringWithFormat:@"丨乐%@丨已为你更新 %d条信息", self.tagTitle, 10];
    self.tableView.tableHeaderView = refrest;
    self.tableView.mj_header.hidden = YES;
    
    dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
        
        __block CGPoint offset = self.tableView.contentOffset;
        CGFloat offsetY = refrest.frame.size.height-offset.y;
        LELog(@"%@",NSStringFromCGPoint(offset));
        if (offsetY > 0) {
//            CGRect frame = refrest.frame;
//            frame.origin.y -= offsetY;
            [UIView animateWithDuration:0.3 animations:^{
//                offset.y = offsetY;
//                [self.tableView setContentOffset:offset];
//                refrest.frame = frame;
//                self.tableView.tableHeaderView = refrest;
                self.tableView.tableHeaderView = nil;
                self.tableView.mj_header.hidden = NO;
            } completion:^(BOOL finished) {
//                self.tableView.tableHeaderView = nil;
//                offset.y = 0;
//                [self.tableView setContentOffset:offset];
            }];
        }else{
            self.tableView.tableHeaderView = nil;
            self.tableView.mj_header.hidden = NO;
//            offset.y -= refrest.frame.size.height;
//            [self.tableView setContentOffset:offset];
        }
        
    });
    
}

#pragma mark -
#pragma mark - Request
- (void)getNewsRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelId forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetNews%@",self.channelId];
    BOOL needCache = NO;
    if (self.nextCursor == 1) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (!isCache) {
            [WeakSelf.tableView.mj_header endRefreshing];
            [WeakSelf.tableView.mj_footer endRefreshing];
            if (WeakSelf.nextCursor == 1) {
                [WeakSelf endRereshShowTipView];
            }
        }
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"data"]];
        
        if (WeakSelf.nextCursor == 1) {
            WeakSelf.newsList = [[NSMutableArray alloc] init];
        }
        [WeakSelf.newsList addObjectsFromArray:array];
        
        if (!isCache) {
            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                [WeakSelf.tableView.mj_footer setHidden:NO];
                [WeakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [WeakSelf.tableView.mj_footer setHidden:NO];
                WeakSelf.nextCursor ++;
                [WeakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [WeakSelf.tableView reloadData];
        
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_header endRefreshing];
        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)newsShieldRequestWithReasons:(NSArray *)reasons{
    
    LENewsListModel *newsModel = [self.newsList objectAtIndex:_indexPath.row];
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
    
    [self.newsList removeObject:newsModel];
    [self.tableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationTop];
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
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:_indexPath];
    CGRect rect1 = [self.tableView convertRect:rectInTableView toView:[UIApplication sharedApplication].delegate.window];
    [self addTempView:rect1];
}

- (void)addTempView:(CGRect)rect {
    //添加蒙层
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    v.backgroundColor = kAppMaskOpaqueBlackColor;
    DelAlertView *delView = [[[NSBundle mainBundle] loadNibNamed:@"DelAlertView" owner:self options:nil] firstObject];
    delView.count = 0;
    delView.frame = CGRectMake(rect.origin.x, rect.origin.y, HitoScreenW, 160);
    

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.frame = rect;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [v addGestureRecognizer:tap];
    [UIView animateWithDuration:0.2 animations:^{
        LELog(@"%f", rect.origin.y);
        delView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, HitoScreenW, 160);
    }];
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:v];
    [v addSubview:delView];
    [v addSubview:cell];
    
    HitoWeakSelf;
    delView.delAlertViewShieldClickBlock = ^(NSArray *reasons) {
        [WeakSelf newsShieldRequestWithReasons:reasons];
        [WeakSelf removeView:tap];
    };
    
}

- (void)removeView:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
    [self.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
    _indexPath = nil;
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    MJWeakSelf;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        if (![weakSelf.tableView.mj_header isRefreshing]) {
            return;
        }
        weakSelf.nextCursor = 1;
        weakSelf.newsList = [[NSMutableArray alloc] init];
        [weakSelf getNewsRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        if (![weakSelf.tableView.mj_footer isRefreshing]) {
            return;
        }
        [weakSelf getNewsRequest];
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
