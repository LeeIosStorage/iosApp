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

@interface LEVideoListViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
LEVideoListViewCellDelegate
>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *videoList;

@property (strong, nonatomic) NSDate *downStartUpdatedTime;//下拉刷新
@property (strong, nonatomic) NSDate *downEndUpdatedTime;

@end

@implementation LEVideoListViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self getNewsRequest:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData{
//    if (!self.tableView.mj_header) {
//        [self addMJ];
//    }
}

- (void)tabBarSelectRefreshData{
//    if (![self.tableView.mj_header isRefreshing] && !self.tableView.mj_header.hidden) {
//        CGPoint offset = self.tableView.contentOffset;
//        if (offset.y > 200) {
//            offset.y = 0;
//            [self.tableView setContentOffset:offset animated:NO];
//            HitoWeakSelf;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [WeakSelf.tableView.mj_header beginRefreshing];
//            });
//        }else{
//            [self.tableView.mj_header beginRefreshing];
//        }
//    }
}

#pragma mark -
#pragma mark - Private
- (void)setup{
//    self.view.backgroundColor = [UIColor whiteColor];
    self.videoList = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark - Request
- (void)getNewsRequest:(int)type{
    
    self.downEndUpdatedTime = [NSDate date];
    self.downStartUpdatedTime = [NSDate dateWithTimeInterval:-5*60 sinceDate:self.downEndUpdatedTime];
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.channelId forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:50] forKey:@"limit"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.downStartUpdatedTime]] forKey:@"start"];
    if (!self.downEndUpdatedTime) [NSDate date];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:self.downEndUpdatedTime]] forKey:@"end"];
    
    LELog(@"下拉刷新 GetNews params = %@ \n time:{%@,%@}",params,self.downEndUpdatedTime,self.downStartUpdatedTime);
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            
            return ;
        }
        if ([dataObject isEqual:[NSNull null]]) {
            [WeakSelf.tableView.mj_header endRefreshing];
            return;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"data"]];
        
        WeakSelf.videoList = [NSMutableArray array];
        [WeakSelf.videoList addObjectsFromArray:array];
        [WeakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        
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
    newsModel.is_video = YES;
    
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    detail.isVideo = newsModel.is_video;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -
#pragma mark - LEVideoListViewCellDelegate
- (void)videoCellAvatarClickWithCell:(LEVideoListViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    LEPersonalNewsViewController *personalNewsVc = [[LEPersonalNewsViewController alloc] init];
    personalNewsVc.userId = [LELoginUserManager userID];
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
    newsModel.is_video = YES;
    
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    detail.isVideo = newsModel.is_video;
    detail.locateCommentSection = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)shareClickCell:(LEVideoListViewCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
}

@end
