//
//  LEMessageViewController.m
//  XWAPP
//
//  Created by hys on 2018/6/5.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEMessageViewController.h"
#import "LESegmentedView.h"
#import "LENoticeViewCell.h"
#import "LEMessageModel.h"

@interface LEMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) LESegmentedView *segmentedView;
@property (assign, nonatomic) NSInteger currentIndex;

@property (strong, nonatomic) NSMutableArray *noticeLists;
@property (strong, nonatomic) NSMutableArray *messageLists;
@property (strong, nonatomic) UITableView *noticeTableView;
@property (strong, nonatomic) UITableView *messageTableView;

@end

@implementation LEMessageViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self refreshNoticeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self setTitle:@"消息中心"];
    
    
    [self setRightBarButtonItemWithTitle:@"清空" color:kAppThemeColor];
    
    self.noticeLists = [[NSMutableArray alloc] init];
    self.messageLists = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.segmentedView];
    [self.segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    [self refreshUI];
    
    [self.view addSubview:self.noticeTableView];
    [self.noticeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
    }];
    
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
    }];
    self.messageTableView.hidden = YES;
    
    
}

- (void)refreshUI{
    
    [self.segmentedView updateRedCountWith:0 index:0];
    [self.segmentedView updateRedCountWith:0 index:1];
}

- (void)segmentedSelectItem:(NSInteger)index{
    
    self.currentIndex = index;
    if (index == 0) {
        self.noticeTableView.hidden = NO;
        self.messageTableView.hidden = YES;
    }else if (index == 1){
        self.noticeTableView.hidden = YES;
        self.messageTableView.hidden = NO;
    }
}

#pragma mark -
#pragma mark - Request
- (void)refreshNoticeRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"getNotice"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"offset"];
    [params setObject:[NSNumber numberWithInteger:1] forKey:@"limit"];
    
    NSString *caCheKey = [NSString stringWithFormat:@"getNotice%@",@""];
    BOOL needCache = NO;
//    if (self.nextCursor == 1) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
//        if (!isCache) {
//            [WeakSelf.tableView.mj_header endRefreshing];
//            [WeakSelf.tableView.mj_footer endRefreshing];
//        }
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LEMessageModel class] json:dataObject];
//
//        if (WeakSelf.nextCursor == 1) {
//            WeakSelf.commentLists = [[NSMutableArray alloc] init];
//        }
        [WeakSelf.noticeLists addObjectsFromArray:array];
//
//        if (!isCache) {
//            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
//                [WeakSelf.tableView.mj_footer setHidden:YES];
//            }else{
//                [WeakSelf.tableView.mj_footer setHidden:NO];
//                WeakSelf.nextCursor ++;
//            }
//        }
//
        [WeakSelf.noticeTableView reloadData];
        
        
    } failure:^(id responseObject, NSError *error) {
//        [WeakSelf.tableView.mj_header endRefreshing];
//        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
    
//    for (int i = 0; i < 60; i ++) {
//        LEMessageModel *messageModel = [[LEMessageModel alloc] init];
//        if (i == 2 || i == 10 || i == 58) {
//            messageModel.title = @"收徒快速赚金币";
//            messageModel.messageType = LEMessageTypeNone;
//            messageModel.des = @"快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币>>>";
//        }else{
//            messageModel.title = @"系统通知";
//            messageModel.messageType = LEMessageTypeSystem;
//            messageModel.rate = @"0.601";
//            messageModel.gold = @"38";
//        }
//        [self.noticeLists addObject:messageModel];
//    }
//    [self.noticeTableView reloadData];
//
//    for (int i = 0; i < 50; i ++) {
//        LEMessageModel *messageModel = [[LEMessageModel alloc] init];
//        messageModel.title = @"收徒快速赚金币";
//        messageModel.messageType = LEMessageTypeNone;
//        messageModel.des = @"快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币快速赚金币>>>";
//        [self.messageLists addObject:messageModel];
//    }
//    [self.messageTableView reloadData];
    
}

- (void)clearRecordRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"emptyNotice"];
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:nil responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:@"清除成功"];
        [WeakSelf.noticeLists removeAllObjects];
        [WeakSelf.noticeTableView reloadData];
        [WeakSelf.messageLists removeAllObjects];
        [WeakSelf.messageTableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
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
#pragma mark - Set And Getters
- (LESegmentedView *)segmentedView{
    if (!_segmentedView) {
        _segmentedView = [[LESegmentedView alloc] init];
        [_segmentedView setSegmentedWithArray:@[@{LESegmentedTitle:@"通知",LESegmentedImage:@"mine_message_tongzhi_nor",LESegmentedHImage:@"mine_message_tongzhi_sel",LESegmentedCount:@(2)},@{LESegmentedTitle:@"公告",LESegmentedImage:@"mine_message_gonggao_nor",LESegmentedHImage:@"mine_message_gonggao_sel",LESegmentedCount:@(2)}]];
        HitoWeakSelf;
        _segmentedView.segmentedSelectItem = ^(NSInteger index) {
            [WeakSelf segmentedSelectItem:index];
        };
    }
    return _segmentedView;
}

- (UITableView *)noticeTableView{
    if (!_noticeTableView) {
        _noticeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noticeTableView.dataSource = self;
        _noticeTableView.delegate = self;
        _noticeTableView.estimatedRowHeight = 44;
        _noticeTableView.rowHeight = UITableViewAutomaticDimension;
        _noticeTableView.backgroundColor = self.view.backgroundColor;
        
    }
    return _noticeTableView;
}


- (UITableView *)messageTableView{
    if (!_messageTableView) {
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.estimatedRowHeight = 44;
        _messageTableView.rowHeight = UITableViewAutomaticDimension;
        _messageTableView.backgroundColor = self.view.backgroundColor;
    }
    return _messageTableView;
}

#pragma mark -
#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.noticeTableView) {
        return self.noticeLists.count;
    }
    return self.messageLists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.noticeTableView) {
        static NSString *cellIdentifier = @"LENoticeViewCell";
        LENoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
            cell = [cells objectAtIndex:0];
            
        }
        
        [cell updateCellWithData:self.noticeLists[indexPath.row]];
        return cell;
    }
    
    static NSString *cellIdentifier = @"LENoticeViewCell";
    LENoticeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        
    }
    
    [cell updateCellWithData:self.messageLists[indexPath.row]];
    return cell;
}

@end
