//
//  LECommentListViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/30.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LECommentListViewController.h"
#import "LEMineCommentViewCell.h"

@interface LECommentListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) NSMutableArray *commentLists;
@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) int nextCursor;

@end

@implementation LECommentListViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self setTitle:@"我的评论"];
    
    [self setRightBarButtonItemWithTitle:@"清空" color:kAppThemeColor];
    
    self.nextCursor = 1;
    self.commentLists = [[NSMutableArray alloc] init];
    
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
        weakSelf.commentLists = [[NSMutableArray alloc] init];
        [weakSelf getCommentRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        
        [weakSelf getCommentRequest];
    }];
    [self.tableView.mj_footer setHidden:YES];
}

#pragma mark -
#pragma mark - Request
- (void)getCommentRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserComment"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
//    [params setObject:@"1" forKey:@"parentId"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"GetUserComment%@",@""];
    BOOL needCache = NO;
    if (self.nextCursor == 1) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (!isCache) {
            [WeakSelf.tableView.mj_header endRefreshing];
            [WeakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        NSArray *array = [NSArray modelArrayWithClass:[NSDictionary class] json:[dataObject objectForKey:@"data"]];
        
        if (WeakSelf.nextCursor == 1) {
            WeakSelf.commentLists = [[NSMutableArray alloc] init];
        }
        [WeakSelf.commentLists addObjectsFromArray:array];
        
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

- (void)clearRecordRequest{
    
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
    }
    return _tableView;
}

#pragma mark -
#pragma mark - IBActions
- (void)rightButtonClicked:(id)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定清空记录吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    HitoWeakSelf;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WeakSelf clearRecordRequest];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"LEMineCommentViewCell";
    LEMineCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        
    }
    
    return cell;
}

@end
