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

@interface HoitPointController ()

@end

@implementation HoitPointController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTB];
    [self addMJ];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (void)setTB {
    [self setTitle:@"实时热点"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [UIView new];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
//    if (indexPath.row == 2) {
//        cell.lineView.hidden = YES;
//    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HotHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"HotHeader" owner:self options:nil] firstObject];
    header.frame = CGRectMake(0, 0, HitoScreenW, 36);
    header.titleLB.text = @"昨天";
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];

            
            
        });
        
        dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
            
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
            
            
        });
        
    }];
    //上啦加载
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        //
    }];
}

@end
