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
#import "LEWebViewController.h"
#import <SafariServices/SafariServices.h>

#define refresh_timeInterval  5*60

@interface SYBaseVC ()
<
SFSafariViewControllerDelegate
>
{
    UIView *_cellMaskView;
    BOOL _shieldingCellMaskView;
    
    BOOL _afreshLatestData;
    int _newestDatapages;
    int _upNewestDatapages;
}

@property (strong, nonatomic) NSMutableArray *newsList;
@property (strong, nonatomic) NSMutableArray *updateNewsList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) int downNextCursor;
@property (strong, nonatomic) NSDate *downStartUpdatedTime;//下拉刷新
@property (strong, nonatomic) NSDate *downEndUpdatedTime;

@property (assign, nonatomic) int upNextCursor;
@property (strong, nonatomic) NSDate *upStartUpdatedTime;//上拉加载
@property (strong, nonatomic) NSDate *upEndUpdatedTime;

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
    
    _afreshLatestData = NO;
    _newestDatapages = 1;
    _upNewestDatapages = 1;
    self.downNextCursor = 1;
    self.upNextCursor = 1;
    self.downStartUpdatedTime = [NSDate date];
    self.newsList = [[NSMutableArray alloc] init];
    self.updateNewsList = [[NSMutableArray alloc] init];
    
    _shieldingCellMaskView = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseOneCell" bundle:nil] forCellReuseIdentifier:@"BaseOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseTwoCell" bundle:nil] forCellReuseIdentifier:@"BaseTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseThirdCell" bundle:nil] forCellReuseIdentifier:@"BaseThirdCell"];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}

- (void)endRereshShowTipView:(int)updateCount{
    
    if (updateCount <= 0) {
        return;
    }
    
    RefrestInfoView *refrest = [[[NSBundle mainBundle] loadNibNamed:@"RefrestInfoView" owner:self options:nil] firstObject];
    refrest.titleLB.text = [NSString stringWithFormat:@"丨乐%@丨已为你更新 %d条内容", @"资讯", updateCount];//self.tagTitle
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

- (void)sortNewsListArray{
    
    //置顶操作
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (LENewsListModel *model in self.newsList) {
        if (![categoryArray containsObject:model]) {
            [categoryArray addObject:model];
        }
        if (model.isTop) {
            if (![tmpArray containsObject:model]) {
                [tmpArray addObject:model];
            }
        }
    }
    [categoryArray removeObjectsInArray:tmpArray];
    [self.newsList removeAllObjects];
    [self.newsList addObjectsFromArray:categoryArray];
    
    //暂时先这样处理, 需要后台配合
    if (tmpArray.count > 1) {
        tmpArray = [tmpArray subarrayWithRange:NSMakeRange(0, 1)];
    }
    [self.newsList insertObjects:tmpArray atIndex:0];
}

- (void)insertADToNewsList:(NSArray *)array index:(NSInteger)index adModel:(LENewsListModel *)adModel animation:(BOOL)animation{
    return;
    if (array.count == 0) {
        return;
    }
    
    if (self.newsList.count >= index) {
        LENewsListModel *indexModel = [self.newsList objectAtIndex:index];
        if (indexModel.is_ad) {
            return;
        }
        [self.newsList insertObject:adModel atIndex:index];
        
        if (animation) {
            [CATransaction begin];
            [self.tableView beginUpdates];
            [CATransaction setCompletionBlock:^{
                //动画结束 回调
            }];
            [self.tableView insertRow:index inSection:0 withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [CATransaction commit];
        }else{
            [self.tableView reloadData];
        }
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
    [params setObject:[NSNumber numberWithInteger:self.downNextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    NSString *userId = [LELoginUserManager userID];
    if (!userId) userId = @"0";
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.downStartUpdatedTime]] forKey:@"start"];
    if (!self.downEndUpdatedTime) [NSDate date];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.downEndUpdatedTime]] forKey:@"end"];
    
    LELog(@"下拉刷新 GetNews params = %@ \n time:{%@,%@}",params,self.downEndUpdatedTime,self.downStartUpdatedTime);
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetNews%@",self.channelId];
    BOOL needCache = NO;
    if (self.downNextCursor == 1 && self.downStartUpdatedTime) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf removeCellMaskView];
        
        if (requestType != WYRequestTypeSuccess) {
            if (!isCache) {
                [WeakSelf.tableView.mj_header endRefreshing];
            }
            return ;
        }
        if ([dataObject isEqual:[NSNull null]]) {
            [WeakSelf.tableView.mj_header endRefreshing];
            return;
        }
        BOOL needRefresh = NO;
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"records"]];
        if (WeakSelf.downNextCursor == 1) {
            self->_newestDatapages = [[dataObject objectForKey:@"pages"] intValue];
            if (self->_newestDatapages == 0) {
                self->_newestDatapages = 1;
            }
            LELog(@"下拉刷新>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>获取数据的page数%d",self->_newestDatapages);
//            self->_newestDatapages = 2;
        }
        
        if (isCache) {
            WeakSelf.newsList = [[NSMutableArray alloc] init];
            
        }else{
            
            [WeakSelf endRereshShowTipView:(int)array.count];

            [WeakSelf.newsList insertObjects:array atIndex:0];
            if (WeakSelf.newsList.count <= 6) {
                needRefresh = YES;
                if (type == 1) {
                    //防止无限循环
                    [WeakSelf.tableView.mj_header endRefreshing];
                    LELog(@"出现了无限循环情况!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                    return;
                }
            }else{
                [WeakSelf.tableView.mj_header endRefreshing];
            }
            
            if (needRefresh) {
                WeakSelf.downStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval sinceDate:[NSDate date]];
                //test
                WeakSelf.downStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval*60 sinceDate:[NSDate date]];
                
                [WeakSelf getNewsRequest:1];
            }
            
            if (self->_newestDatapages == WeakSelf.downNextCursor) {
                WeakSelf.downNextCursor = 1;
                self->_newestDatapages = 1;
                self->_afreshLatestData = YES;
            }else{
                WeakSelf.downNextCursor ++;
            }
            
            [WeakSelf.tableView.mj_footer setHidden:NO];
            [WeakSelf.tableView.mj_footer resetNoMoreData];
            
            if (WeakSelf.newsList.count <= 0) {
                [WeakSelf.tableView.mj_footer setHidden:YES];
                [WeakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        
        [WeakSelf sortNewsListArray];
        
        [WeakSelf.tableView reloadData];
        
        //添加广告
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LENewsListModel *adModel = [[LENewsListModel alloc] init];
            adModel.is_ad = YES;
            adModel.title = @"慧一舍棋牌游戏先行者";
            adModel.cover = [NSArray arrayWithObjects:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530704113914&di=dbc4e909286b3b4c758392a37db370b5&imgtype=0&src=http%3A%2F%2Fwww.zshouyou.com%2Fud%2Fallimg%2F171026%2F16320T126-0.png", nil];
            adModel.adUrl = @"http://www.huiyishe.cn";
            adModel.adType = 0;
            [WeakSelf insertADToNewsList:array index:1 adModel:adModel animation:YES];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf removeCellMaskView];
        [WeakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreNewsRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelId forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:self.upNextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    NSString *userId = [LELoginUserManager userID];
    if (!userId) userId = @"0";
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.upStartUpdatedTime]] forKey:@"start"];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.upEndUpdatedTime]] forKey:@"end"];
    
    LELog(@"上拉加载 GetNews params = %@ \n time:{%@,%@}",params,self.upEndUpdatedTime,self.upStartUpdatedTime);
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf removeCellMaskView];
        [WeakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        if ([dataObject isEqual:[NSNull null]]) {
            return;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"records"]];
        if (WeakSelf.upNextCursor == 1) {
            self->_upNewestDatapages = [[dataObject objectForKey:@"pages"] intValue];
            if (self->_upNewestDatapages == 0) {
                self->_upNewestDatapages = 1;
            }
            LELog(@"上拉加载>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>获取数据的page数%d",self->_upNewestDatapages);
        }
        
        [WeakSelf.newsList addObjectsFromArray:array];
        
        if (self->_upNewestDatapages == WeakSelf.upNextCursor) {
            WeakSelf.upNextCursor = 1;
            self->_upNewestDatapages = 1;
            WeakSelf.upEndUpdatedTime = WeakSelf.upStartUpdatedTime;
            WeakSelf.upStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval sinceDate:WeakSelf.upEndUpdatedTime];
        }else{
            WeakSelf.upNextCursor ++;
        }
        
        [WeakSelf.tableView.mj_footer setHidden:NO];
        [WeakSelf.tableView.mj_footer resetNoMoreData];
        
        [WeakSelf sortNewsListArray];
        
        [WeakSelf.tableView reloadData];
        
        //添加广告
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LENewsListModel *adModel = [[LENewsListModel alloc] init];
            adModel.is_ad = YES;
            adModel.title = @"足球宝贝";
            adModel.cover = [NSArray arrayWithObjects:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530707693966&di=abc86e4d7da0465e0b99c027f75800b0&imgtype=0&src=http%3A%2F%2Fimg2.ph.126.net%2FI8P3Eq4u62gn_jX9DOMNJw%3D%3D%2F1554304821414308681.jpg", nil];
            adModel.adType = 1;
            NSInteger index = WeakSelf.newsList.count - array.count;
            
            [WeakSelf insertADToNewsList:array index:index adModel:adModel animation:YES];
        });
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf removeCellMaskView];
        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)newsShieldRequestWithReasons:(NSArray *)reasons{
    
    LENewsListModel *newsModel = [self.newsList objectAtIndex:_indexPath.row];
    LENewsListModel *updateNewsModel = nil;
    if (_indexPath.row >= 0 && _indexPath.row < [self.updateNewsList count]) {
        updateNewsModel = self.updateNewsList[_indexPath.row];
    }
    
    HitoWeakSelf;
    if ([LELoginUserManager userID]) {
        NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"SaveUninterestedNews"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:newsModel.newsId forKey:@"newsId"];
        [params setObject:[LELoginUserManager userID] forKey:@"userId"];
        [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
            
            if (requestType != WYRequestTypeSuccess) {
                return ;
            }
            
        } failure:^(id responseObject, NSError *error) {
            
        }];
    }
    
    
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    [_cellMaskView removeFromSuperview];
    [self.tableView reloadData];
    _shieldingCellMaskView = YES;
    
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.newsList.count) {
        newsModel = [self.newsList objectAtIndex:indexPath.row];
    }
    NSUInteger count = newsModel.cover.count;
    NSString *coverStr = [[newsModel.cover firstObject] description];
    if (count == 1 && coverStr.length > 0) {
        return 120;
    } else if (count == 3) {
        return 195;
    } else {
        return 113;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.newsList.count) {
        newsModel = [self.newsList objectAtIndex:indexPath.row];
    }
    NSUInteger count = newsModel.cover.count;
    NSString *coverStr = [[newsModel.cover firstObject] description];
    MJWeakSelf;
    if (count == 1 && coverStr.length > 0) {
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
    
    if (newsModel.is_ad) {
        [self adJumphandle:newsModel];
        return;
    }
    
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    detail.isVideo = (newsModel.typeId == 1);
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
#pragma mark - 广告跳转
- (void)adJumphandle:(LENewsListModel *)model{
    
    switch (model.adType) {
        case 1:
            [self jumpSafariViewController:model];
            break;
            
        default:{
            NSString *webUrl = model.adUrl;
            LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:webUrl];
            webVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVc animated:YES];
        }
            break;
    }
}

- (void)jumpSafariViewController:(LENewsListModel *)model{
    //Safari百度搜索
    NSString *webUrl = model.adUrl;
    webUrl = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@",model.title];
    NSString *encodedUrl = [webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (@available(iOS 9.0, *)) {
        SFSafariViewController *svc =[[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:encodedUrl]];
        svc.delegate = self;
        [self.navigationController presentViewController:svc animated:true completion:nil];
    } else {
        // Fallback on earlier versions
        LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:encodedUrl];
        webVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVc animated:YES];
    }
}
#pragma mark - SFSafariViewControllerDelegate
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller API_AVAILABLE(ios(9.0)){
    [controller dismissViewControllerAnimated:YES completion:nil];
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
        
        if (self->_afreshLatestData) {
            weakSelf.downEndUpdatedTime = [NSDate date];
            weakSelf.downStartUpdatedTime = weakSelf.tableView.mj_header.lastUpdatedTime;
            self->_afreshLatestData = NO;
        }
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:weakSelf.downStartUpdatedTime];
        if (timeInterval > refresh_timeInterval) {
            if (timeInterval > refresh_timeInterval*2) {
                weakSelf.downNextCursor = 1;
            }
            weakSelf.downEndUpdatedTime = [NSDate date];
            weakSelf.downStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval sinceDate:weakSelf.downEndUpdatedTime];
        }
        
        [weakSelf getNewsRequest:0];
    }];
    self.tableView.mj_header.lastUpdatedTimeKey = [NSString stringWithFormat:@"MJRefreshHeaderLastUpdatedTimeKey_%@",self.channelId];
    self.downEndUpdatedTime = [NSDate date];
    self.downStartUpdatedTime = self.tableView.mj_header.lastUpdatedTime;
    if (self.downStartUpdatedTime == nil) {
        self.downStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval sinceDate:[NSDate date]];
    }
    //间隔时间超过5分钟 设置5分钟
    NSTimeInterval timeInterval = [self.downEndUpdatedTime timeIntervalSinceDate:self.downStartUpdatedTime];
    if (timeInterval > refresh_timeInterval) {
        self.downStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval sinceDate:self.downEndUpdatedTime];
    }
    weakSelf.downNextCursor = 1;
    [self.tableView.mj_header beginRefreshing];
    
    
    
    //上拉加载
    self.upEndUpdatedTime = weakSelf.downStartUpdatedTime;
    self.upStartUpdatedTime = [NSDate dateWithTimeInterval:-refresh_timeInterval sinceDate:self.upEndUpdatedTime];
    
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            return;
        }
        [weakSelf loadMoreNewsRequest];
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
