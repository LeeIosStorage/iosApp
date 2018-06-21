//
//  HoitPointController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "HoitPointController.h"
#import "HotCell.h"
#import "HotHeader.h"
#import "LERefreshHeader.h"
#import "LEHotNewsModel.h"
#import "WYNetWorkManager.h"
#import "DetailController.h"

@interface HoitPointController ()
{
    BOOL _viewDidAppear;
}
@property (strong, nonatomic) NSMutableArray *hotNewsList;

@property (assign, nonatomic) int nextCursor;

@end

@implementation HoitPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MobClick event:kNewsRealHotClick];
    [self setTB];
    [self addMJ];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_viewDidAppear) {
        [self.tableView.mj_header beginRefreshing];
    }
    _viewDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])]];
}

- (void)setTB {
    
    [self setTitle:@"实时热点"];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.hotNewsList = [[NSMutableArray alloc] init];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [UIView new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Request
- (void)getNewsRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetHotNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:@"1" forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf.tableView.mj_header endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LEHotNewsModel class] json:[dataObject objectForKey:@"data"]];
        
        NSMutableArray *todayArray = [NSMutableArray array];
        NSMutableArray *yesterdayArray = [NSMutableArray array];
        for (LEHotNewsModel *model in array) {
            NSString *daystr = [WYCommonUtils dateDayToDayDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:model.public_time]];
            if ([daystr isEqualToString:@"今天"]) {
                [todayArray addObject:model];
            }else if ([daystr isEqualToString:@"昨天"]){
                [yesterdayArray addObject:model];
            }
        }
        
        if (WeakSelf.nextCursor == 1) {
            WeakSelf.hotNewsList = [[NSMutableArray alloc] init];
            if (todayArray.count > 0) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                [mutDic setObject:@"今天" forKey:@"title"];
                [mutDic setObject:[NSMutableArray array] forKey:@"data"];
                [WeakSelf.hotNewsList addObject:mutDic];
            }
        }
        if (yesterdayArray.count > 0) {
            if (WeakSelf.hotNewsList.count < 2) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                [mutDic setObject:@"昨天" forKey:@"title"];
                [mutDic setObject:[NSMutableArray array] forKey:@"data"];
                [WeakSelf.hotNewsList addObject:mutDic];
            }
        }
        
        for (NSMutableDictionary *mutDic in WeakSelf.hotNewsList) {
            NSString *title = [mutDic objectForKey:@"title"];
            NSMutableArray *mutArray = [mutDic objectForKey:@"data"];
            if ([title isEqualToString:@"今天"]) {
                [mutArray addObjectsFromArray:todayArray];
            }else if ([title isEqualToString:@"昨天"]){
                [mutArray addObjectsFromArray:yesterdayArray];
            }
        }
        
        if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
            [WeakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [WeakSelf.tableView.mj_footer setHidden:NO];
            WeakSelf.nextCursor ++;
        }
        if (WeakSelf.hotNewsList.count == 0) {
            [WeakSelf.tableView.mj_footer setHidden:YES];
        }
        
        [WeakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.hotNewsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = [self.hotNewsList objectAtIndex:section];
    NSArray *array = dic[@"data"];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
    
    NSDictionary *dic = [self.hotNewsList objectAtIndex:indexPath.section];
    NSArray *array = dic[@"data"];
    LEHotNewsModel *model = array[indexPath.row];
    [cell updateCellWithData:model];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dic = [self.hotNewsList objectAtIndex:section];
    
    HotHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"HotHeader" owner:self options:nil] firstObject];
    header.frame = CGRectMake(0, 0, HitoScreenW, 36);
    header.titleLB.text = dic[@"title"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.hotNewsList objectAtIndex:indexPath.section];
    NSArray *array = dic[@"data"];
    LEHotNewsModel *model = array[indexPath.row];
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = model.newsId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    HitoWeakSelf;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        WeakSelf.nextCursor = 1;
        [WeakSelf getNewsRequest];
    }];
    
    //上啦加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        [WeakSelf getNewsRequest];
    }];
    self.tableView.mj_footer.hidden = YES;
    
}

@end
