//
//  LENewsTabBaseViewController.m
//  XWAPP
//
//  Created by hys on 2018/7/20.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsTabBaseViewController.h"
#import "LEVideoListViewCell.h"
#import "LENewsListModel.h"
#import "DetailController.h"
#import "BaseOneCell.h"
#import "BaseTwoCell.h"
#import "BaseThirdCell.h"

@interface LENewsTabBaseViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation LENewsTabBaseViewController

- (UIScrollView *)tabContentScrollView {
    return self.tableView;
}

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self getNewsRequest:_vcType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Request
- (void)getNewsRequest:(NSInteger)type{
    
    NSDate *downEndUpdatedTime = [NSDate date];
    NSDate *downStartUpdatedTime = [NSDate dateWithTimeInterval:-5*60 sinceDate:downEndUpdatedTime];
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"255" forKey:@"cid"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:50] forKey:@"limit"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:downStartUpdatedTime]] forKey:@"start"];
    [params setObject:[NSNumber numberWithLongLong:[WYCommonUtils getDateTimeTOMilliSeconds:downEndUpdatedTime]] forKey:@"end"];
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            
            return ;
        }
        if ([dataObject isEqual:[NSNull null]]) {
            [WeakSelf.tableView.mj_header endRefreshing];
            return;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:[dataObject objectForKey:@"data"]];
        
        WeakSelf.dataArray = [NSMutableArray array];
        [WeakSelf.dataArray addObjectsFromArray:array];
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
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.vcType == 1) {
        return HitoActureHeight(262);
    }
    LENewsListModel *newsModel = nil;
    if (indexPath.row < self.dataArray.count) {
        newsModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    NSUInteger count = newsModel.cover.count;
    NSString *coverStr = [[newsModel.cover firstObject] description];
    if (count == 1 && newsModel.type != 1 && coverStr.length > 0) {
        return 120;
    } else if (count == 3) {
        return 195;
    } else {
        return 113;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vcType == 0) {
        LENewsListModel *newsModel = nil;
        if (indexPath.row < self.dataArray.count) {
            newsModel = [self.dataArray objectAtIndex:indexPath.row];
        }
        NSUInteger count = newsModel.cover.count;
        NSString *coverStr = [[newsModel.cover firstObject] description];
        if (count == 1 && newsModel.type != 1 && coverStr.length > 0) {
            static NSString *cellIdentifier = @"BaseOneCell";
            BaseOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
                cell = [cells objectAtIndex:0];
                cell.cellType = LENewsListCellTypePersonal;
            }
            
            [cell updateCellWithData:newsModel];
            
            return cell;
        } else if (count == 3) {
            
            static NSString *cellIdentifier = @"BaseThirdCell";
            BaseThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
                cell = [cells objectAtIndex:0];
                cell.cellType = LENewsListCellTypePersonal;
            }
            
            [cell updateCellWithData:newsModel];
            
            return cell;
        } else {
            static NSString *cellIdentifier = @"BaseTwoCell";
            BaseTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
                cell = [cells objectAtIndex:0];
                cell.cellType = LENewsListCellTypePersonal;
            }

            [cell updateCellWithData:newsModel];
            
            return cell;
        }
    }
    static NSString *cellIdentifier = @"LEVideoListViewCell";
    LEVideoListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.cellType = LENewsListCellTypePersonal;
    }
    
    LENewsListModel *model = self.dataArray[indexPath.row];
    [cell updateCellWithData:model];
    
    HitoWeakSelf;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsListModel *newsModel = [self.dataArray objectAtIndex:indexPath.row];
    if (self.vcType == 1) {
        newsModel.is_video = YES;
    }
    
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    detail.newsId = newsModel.newsId;
    detail.isVideo = newsModel.is_video;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
