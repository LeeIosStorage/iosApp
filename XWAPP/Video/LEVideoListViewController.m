//
//  LEVideoListViewController.m
//  XWAPP
//
//  Created by hys on 2018/7/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoListViewController.h"
#import "LEVideoListViewCell.h"
#import "LENewsListModel.h"
#import "DetailController.h"
#import "LEPersonalNewsViewController.h"
#import "LEPersonalNewsViewController.h"
#import "LEShareSheetView.h"

#define refresh_timeInterval  5*60

@interface LEVideoListViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
LEVideoListViewCellDelegate,
LEShareSheetViewDelegate
>
{
    BOOL _afreshLatestData;
    int _newestDatapages;
    int _upNewestDatapages;
    
    LEShareSheetView *_shareSheetView;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *videoList;

@property (assign, nonatomic) int downNextCursor;
@property (strong, nonatomic) NSDate *downStartUpdatedTime;//下拉刷新
@property (strong, nonatomic) NSDate *downEndUpdatedTime;

@property (assign, nonatomic) int upNextCursor;
@property (strong, nonatomic) NSDate *upStartUpdatedTime;//上拉加载
@property (strong, nonatomic) NSDate *upEndUpdatedTime;

@end

@implementation LEVideoListViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
//    [self getNewsRequest:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)setup{
    
    _afreshLatestData = NO;
    _newestDatapages = 1;
    _upNewestDatapages = 1;
    self.downNextCursor = 1;
    self.upNextCursor = 1;
    self.downStartUpdatedTime = [NSDate date];
    
    self.videoList = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

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
#pragma mark - Request
//默认type=0  =1时新数据小于10条再去加载老数据
- (void)getNewsRequest:(int)type{
    
    self.downNextCursor = 1;
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"getVideoNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelId forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:self.downNextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.downStartUpdatedTime]] forKey:@"start"];
    if (!self.downEndUpdatedTime) [NSDate date];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.downEndUpdatedTime]] forKey:@"end"];
    
    LELog(@"下拉刷新 GetNews params = %@ \n time:{%@,%@}",params,self.downEndUpdatedTime,self.downStartUpdatedTime);
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetNews%@",self.channelId];
    BOOL needCache = NO;
    if (self.downNextCursor == 1 && self.downStartUpdatedTime) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf.tableView.mj_header endRefreshing];
        
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
            WeakSelf.videoList = [[NSMutableArray alloc] init];
        }
        [WeakSelf.videoList addObjectsFromArray:array];
        
        if (!isCache) {
            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                [WeakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [WeakSelf.tableView.mj_footer setHidden:NO];
                WeakSelf.downNextCursor ++;
            }
        }
        
        /*
        if (WeakSelf.downNextCursor == 1) {
            self->_newestDatapages = [[dataObject objectForKey:@"page"] intValue];
            LELog(@"下拉刷新>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>获取数据的page数%d",self->_newestDatapages);
            //            self->_newestDatapages = 2;
        }
        
        if (isCache) {
            WeakSelf.videoList = [[NSMutableArray alloc] init];
            
        }else{
            
//            [WeakSelf endRereshShowTipView:(int)array.count];
            
            [WeakSelf.videoList insertObjects:array atIndex:0];
            if (WeakSelf.videoList.count <= 6) {
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
            
            if (WeakSelf.videoList.count <= 0) {
                [WeakSelf.tableView.mj_footer setHidden:YES];
                [WeakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        [WeakSelf sortNewsListArray];
        */
        
        [WeakSelf.tableView reloadData];
        
//        //添加广告
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            LENewsListModel *adModel = [[LENewsListModel alloc] init];
//            adModel.is_ad = YES;
//            adModel.title = @"慧一舍棋牌游戏先行者";
//            adModel.cover = [NSArray arrayWithObjects:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530704113914&di=dbc4e909286b3b4c758392a37db370b5&imgtype=0&src=http%3A%2F%2Fwww.zshouyou.com%2Fud%2Fallimg%2F171026%2F16320T126-0.png", nil];
//            adModel.adUrl = @"http://www.huiyishe.cn";
//            //            adModel.adUrl = @"http://v4.qutoutiao.net/Act-ss-mp4-sd/8a4da8c4692d4b15a14dd3d16097b5c0/sd.mp4";
//            //http://html2.qktoutiao.com/detail/2018/06/26/108079647.html
//            //http://v4.qutoutiao.net/Act-ss-mp4-sd/8a4da8c4692d4b15a14dd3d16097b5c0/sd.mp4
//            adModel.adType = 0;
//            [WeakSelf insertADToNewsList:array index:1 adModel:adModel animation:YES];
//        });
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreNewsRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"getVideoNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelId forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:self.upNextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.upStartUpdatedTime]] forKey:@"start"];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.upEndUpdatedTime]] forKey:@"end"];
    
    LELog(@"上拉加载 GetNews params = %@ \n time:{%@,%@}",params,self.upEndUpdatedTime,self.upStartUpdatedTime);
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        if ([dataObject isEqual:[NSNull null]]) {
            return;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"records"]];
        
        
        [WeakSelf.videoList addObjectsFromArray:array];
        
        if (!isCache) {
            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                [WeakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [WeakSelf.tableView.mj_footer setHidden:NO];
                WeakSelf.downNextCursor ++;
            }
        }
        
        
        /*
        if (WeakSelf.upNextCursor == 1) {
            self->_upNewestDatapages = [[dataObject objectForKey:@"page"] intValue];
            LELog(@"上拉加载>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>获取数据的page数%d",self->_upNewestDatapages);
        }
        
        [WeakSelf.videoList addObjectsFromArray:array];
        
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
        
//        [WeakSelf sortNewsListArray];
        */
        
        [WeakSelf.tableView reloadData];
        
//        //添加广告
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            LENewsListModel *adModel = [[LENewsListModel alloc] init];
//            adModel.is_ad = YES;
//            adModel.title = @"足球宝贝";
//            adModel.cover = [NSArray arrayWithObjects:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1530707693966&di=abc86e4d7da0465e0b99c027f75800b0&imgtype=0&src=http%3A%2F%2Fimg2.ph.126.net%2FI8P3Eq4u62gn_jX9DOMNJw%3D%3D%2F1554304821414308681.jpg", nil];
//            adModel.adType = 1;
//            NSInteger index = WeakSelf.newsList.count - array.count;
//
//            [WeakSelf insertADToNewsList:array index:index adModel:adModel animation:YES];
//        });
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = HitoActureHeight(262);
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LEVideoListViewCell";
    LEVideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.delegate = self;
    }
    
    LENewsListModel *model = self.videoList[indexPath.row];
    [cell updateCellWithData:model];
    
    HitoWeakSelf;
    cell.statusView.attentionClickBlock = ^{
        [WeakSelf attentionClickCell:cell];
    };
    cell.statusView.commentClickBlock = ^{
        [WeakSelf commentClickCell:cell];
    };
    cell.statusView.shareClickBlock = ^{
        [WeakSelf shareClickCell:cell];
    };
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = [self.videoList objectAtIndex:indexPath.row];
    
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    detail.isVideo = (newsModel.typeId == 1);
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
#pragma mark - LEVideoListViewCellDelegate
- (void)videoCellAvatarClickWithCell:(LEVideoListViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LENewsListModel *model = self.videoList[indexPath.row];
    LEPersonalNewsViewController *personalNewsVc = [[LEPersonalNewsViewController alloc] init];
    personalNewsVc.userId = model.userId;
    personalNewsVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalNewsVc animated:YES];
}

- (void)attentionClickCell:(LEVideoListViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LENewsListModel *model = self.videoList[indexPath.row];
    model.isAttention = !model.isAttention;
    [self.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}

- (void)commentClickCell:(LEVideoListViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LENewsListModel *newsModel = [self.videoList objectAtIndex:indexPath.row];
    
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    detail.isVideo = (newsModel.typeId == 1);
    detail.locateCommentSection = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)shareClickCell:(LEVideoListViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LENewsListModel *newsModel = [self.videoList objectAtIndex:indexPath.row];
    
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.newsModel = newsModel;
    [_shareSheetView showShareAction];
    
}

@end
