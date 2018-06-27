//
//  LEEarningRankViewController.m
//  XWAPP
//
//  Created by hys on 2018/6/5.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEEarningRankViewController.h"
#import "LESegmentedView.h"
#import "LEEarningRankModel.h"
#import "LEEarningRankViewCell.h"
#import "LEEarningRankBottomView.h"

@interface LEEarningRankViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) LESegmentedView *segmentedView;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSMutableArray *weekRankLists;
@property (strong, nonatomic) NSMutableArray *allRankLists;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) LEEarningRankBottomView *earningRankBottomView;

@end

@implementation LEEarningRankViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self refreshRankRequest:0];
    [self refreshRankRequest:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self setTitle:@"收入排行榜"];
    self.currentIndex = 0;
    
    self.weekRankLists = [[NSMutableArray alloc] init];
    self.allRankLists = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.segmentedView];
    [self.segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 44, 0));
    }];
    
    [self.view addSubview:self.earningRankBottomView];
    [self.earningRankBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}

- (void)segmentedSelectItem:(NSInteger)index{
    
    self.currentIndex = index;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Request
- (void)refreshRankRequest:(NSInteger )type{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserMoneyList"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [params setObject:[NSNumber numberWithInteger:type+1] forKey:@"type"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        
        if ([dataObject isEqual:[NSNull null]]) {
            return;
        }
        
        NSArray *array = [NSArray modelArrayWithClass:[LEEarningRankModel class] json:dataObject];
        if (type == 0) {
            [WeakSelf.weekRankLists addObjectsFromArray:array];
            
        }else if (type == 1){
            [WeakSelf.allRankLists addObjectsFromArray:array];
        }
        
        [WeakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
//    for (int i = 0; i < 100; i ++) {
//        LEEarningRankModel *rankModel = [[LEEarningRankModel alloc] init];
//        rankModel.userId = @"10201";
//        rankModel.apprenticeCount = 200;
//        rankModel.money = @"1024";
//        if (i < 50) {
//            [self.weekRankLists addObject:rankModel];
//        }
//        [self.allRankLists addObject:rankModel];
//    }
//    [self.tableView reloadData];
    
    [self.earningRankBottomView updateViewWithData:nil];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (LESegmentedView *)segmentedView{
    if (!_segmentedView) {
        _segmentedView = [[LESegmentedView alloc] init];
        [_segmentedView setSegmentedWithArray:@[@{LESegmentedTitle:@"周榜"},@{LESegmentedTitle:@"总榜"}]];
        HitoWeakSelf;
        _segmentedView.segmentedSelectItem = ^(NSInteger index) {
            [WeakSelf segmentedSelectItem:index];
        };
    }
    return _segmentedView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = 44;
//        _tableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _tableView;
}

- (LEEarningRankBottomView *)earningRankBottomView{
    if (!_earningRankBottomView) {
        _earningRankBottomView = [[LEEarningRankBottomView alloc] init];
        _earningRankBottomView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        _earningRankBottomView.layer.shadowColor = [UIColor blackColor].CGColor;
        _earningRankBottomView.layer.shadowOpacity = 0.8f;
        _earningRankBottomView.layer.shadowRadius = 4.0f;
        _earningRankBottomView.layer.shadowOffset = CGSizeMake(4,4);
    }
    return _earningRankBottomView;
}

#pragma mark -
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentIndex == 0) {
        return self.weekRankLists.count;
    }
    return self.allRankLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 36)];
    headerView.backgroundColor = HitoRGBA(213, 213, 213, 1);
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.textColor = kAppTitleColor;
    topLabel.font = HitoPFSCRegularOfSize(14);
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.text = @"排名";
    [headerView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(16);
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *userIdLabel = [[UILabel alloc] init];
    userIdLabel.textColor = kAppTitleColor;
    userIdLabel.font = HitoPFSCRegularOfSize(14);
    userIdLabel.text = @"用户ID";
    [headerView addSubview:userIdLabel];
    [userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLabel.mas_right).offset(50);
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textColor = kAppTitleColor;
    moneyLabel.font = HitoPFSCRegularOfSize(14);
    moneyLabel.text = @"总收入（元）";
    [headerView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-3);
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *apprenticeLabel = [[UILabel alloc] init];
    apprenticeLabel.textColor = kAppTitleColor;
    apprenticeLabel.font = HitoPFSCRegularOfSize(14);
    apprenticeLabel.text = @"徒弟数";
    [headerView addSubview:apprenticeLabel];
    [apprenticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-HitoActureHeight(137));
        make.centerY.equalTo(headerView);
    }];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"LEEarningRankViewCell";
    LEEarningRankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        
    }
    cell.row = indexPath.row;
    if (self.currentIndex == 0) {
        [cell updateCellWithData:self.weekRankLists[indexPath.row]];
    }else{
        [cell updateCellWithData:self.allRankLists[indexPath.row]];
    }
    
    return cell;
}

@end
