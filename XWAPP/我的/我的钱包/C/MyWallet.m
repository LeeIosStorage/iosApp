//
//  MyWallet.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/4.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MyWallet.h"
#import "UIView+Xib.h"
#import "PNChart.h"
#import "WalletHeader.h"
#import "WalletCell.h"
#import "LEWalletHeaderView.h"
#import "LEGoldRecordModel.h"
#import "WithdrawController.h"
#import "LEShareSheetView.h"
#import "LEEarningRankViewController.h"
#import "WYShareManager.h"
#import "LELoginAuthManager.h"
#import "LETaskListModel.h"

@interface MyWallet ()
<
UITableViewDelegate,
UITableViewDataSource,
LEShareSheetViewDelegate,
WXShaerStateDelegate
>
{
    LEShareSheetView *_shareSheetView;
}

@property (strong, nonatomic) NSMutableArray *goldRecordList;
@property (strong, nonatomic) NSMutableArray *moneyRecordList;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableDictionary *nextCursorDic;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) LEWalletHeaderView *walletHeaderView;

@property (strong, nonatomic) UIView *bottonView;


@end

@implementation MyWallet

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    [WYShareManager shareInstance].delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_needShare) {
        [self rightBtnAction:nil];
        _needShare = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setView];
    [self refreshDataRequest:0];
    [self refreshDataRequest:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的钱包";
    
    self.currentIndex = 0;
    self.nextCursorDic = [NSMutableDictionary dictionary];
    [self.nextCursorDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%ld",self.currentIndex]];
    [self.nextCursorDic setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"%ld",self.currentIndex+1]];
    self.goldRecordList = [[NSMutableArray alloc] init];
    self.moneyRecordList = [[NSMutableArray alloc] init];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 58, 0));
    }];
    
    [self.view addSubview:self.bottonView];
    [self.bottonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(58);
    }];
    
    self.walletHeaderView.width = HitoScreenW;
    self.walletHeaderView.height = 245;//265  430
    self.tableView.tableHeaderView = self.walletHeaderView;
    [self.tableView reloadData];
    
    [self setData];
}

- (void)setData{
    
    [self.walletHeaderView updateHeaderViewData:nil];
}

- (void)refreshDataWithIndex:(NSInteger)currentIndex{
    
    if (currentIndex == 0) {
        
    }else if (currentIndex == 1){
        
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Request
- (void)refreshDataRequest:(NSInteger)currentIndex{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserGoldsChangeLogs"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    if (currentIndex == 0) {
        [params setObject:@"1" forKey:@"data_type"];
    }else if (currentIndex == 1){
        [params setObject:@"2" forKey:@"data_type"];
    }
    [params setObject:[self.nextCursorDic objectForKey:[NSString stringWithFormat:@"%ld",currentIndex]] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:50] forKey:@"limit"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        
        if ([dataObject isEqual:[NSNull null]]) {
            return;
        }
        
        NSArray *array = [NSArray modelArrayWithClass:[LEGoldRecordModel class] json:[dataObject objectForKey:@"records"]];
        if (currentIndex == 0) {
            [WeakSelf.goldRecordList addObjectsFromArray:array];
            
        }else if (currentIndex == 1){
            [WeakSelf.moneyRecordList addObjectsFromArray:array];
        }
        
        [WeakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark - IBActions
- (void)btnAction:(UIButton *)sender {
    [MobClick event:kMineEarningRankClick];
    LEEarningRankViewController *rankVc = [[LEEarningRankViewController alloc] init];
    [self.navigationController pushViewController:rankVc animated:YES];
}

- (void)rightBtnAction:(UIButton *)sender {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@&code=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppSharePackageWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken],[LELoginUserManager invitationCode]];
    
    LEShareModel *shareModel = [LEShareModel new];
    shareModel.shareTitle = [NSString stringWithFormat:@"在这里看了几天新闻,赚了%.2f元,一开始不信,现在我已经爱上这了!",[LELoginUserManager income]];
    shareModel.shareDescription = @"";
    shareModel.shareWebpageUrl = webUrl;
    shareModel.shareImage = nil;
    
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.shareModel = shareModel;
    [_shareSheetView showShareAction];
    
    [WYShareManager shareInstance].delegate = self;
}

#pragma mark -
#pragma mark - Set And Getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 44;
    }
    return _tableView;
}

- (LEWalletHeaderView *)walletHeaderView{
    if (!_walletHeaderView) {
        _walletHeaderView = [[LEWalletHeaderView alloc] init];
        
        HitoWeakSelf;
        _walletHeaderView.putForwardBlock = ^{
            WithdrawController *withdrawVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WithdrawController"];
            [WeakSelf.navigationController pushViewController:withdrawVc animated:YES];
        };
    }
    return _walletHeaderView;
}

- (UIView *)bottonView{
    if (!_bottonView) {
        _bottonView = [[UIView alloc] init];
        _bottonView.backgroundColor = HitoWhiteColor;
        _bottonView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottonView.layer.shadowOpacity = 0.8f;
        _bottonView.layer.shadowRadius = 4.0f;
        _bottonView.layer.shadowOffset = CGSizeMake(4,4);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitleColor:HitoColorFromRGB(0xf9473d) forState:UIControlStateNormal];
        [btn setTitle:@"收入排行榜" forState:UIControlStateNormal];
        btn.titleLabel.font = HitoPFSCMediumOfSize(14);
        btn.layer.cornerRadius = 21;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HitoColorFromRGB(0xf9473d).CGColor;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottonView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_bottonView).offset(12);
            make.size.mas_equalTo(CGSizeMake(137, 42));
            make.centerY.equalTo(self->_bottonView);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.layer.cornerRadius = 21;
        rightBtn.layer.masksToBounds = YES;
        [rightBtn setBackgroundColor:HitoColorFromRGB(0xff4b41)];
        [rightBtn setTitleColor:HitoColorFromRGB(0xffffff) forState:UIControlStateNormal];
        rightBtn.titleLabel.font = HitoPFSCMediumOfSize(14);
        [rightBtn setTitle:@"分享获得乐币" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottonView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(15);
            make.right.equalTo(self->_bottonView).offset(-12);
            make.centerY.equalTo(self->_bottonView);
            make.height.mas_equalTo(42);
        }];
        
    }
    return _bottonView;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentIndex == 1) {
        return self.moneyRecordList.count;
    }
    return self.goldRecordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"WalletCell";
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[WalletCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LEGoldRecordModel *model = nil;
    if (self.currentIndex == 0) {
        model = self.goldRecordList[indexPath.row];
        model.recordType = 0;
    }else if (self.currentIndex == 1){
        model = self.moneyRecordList[indexPath.row];
        model.recordType = 1;
    }
    [cell updateWalletCellWithData:model];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WalletHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"WalletHeader" owner:self options:nil] firstObject];
    header.frame = CGRectMake(0, 0, HitoScreenW, 50);
    [header refreshUIWithIndex:self.currentIndex];
    
    HitoWeakSelf;
    [header leftBlockAction:^{
        WeakSelf.currentIndex = 0;
        [WeakSelf refreshDataWithIndex:WeakSelf.currentIndex];
    }];
    
    [header rightBlockAction:^{
        WeakSelf.currentIndex = 1;
        [WeakSelf refreshDataWithIndex:WeakSelf.currentIndex];
    }];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}


#pragma mark - scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark -
#pragma mark - WXShaerStateDelegate
- (void)sendState:(int)state{
    if (state == 1) {
        LETaskListModel *taskModel = [[LELoginAuthManager sharedInstance] getTaskWithTaskType:LETaskCenterTypeShowIncome];
        [[LELoginAuthManager sharedInstance] updateUserTaskStateRequestWith:taskModel.taskId success:^(BOOL success) {
            if (success) {
                [MBProgressHUD showCustomGoldTipWithTask:@"晒收入" gold:[NSString stringWithFormat:@"+%d",[taskModel.coin intValue]]];
            }else{
                [SVProgressHUD showCustomInfoWithStatus:@"分享成功"];
            }
        }];
    }else if (state == 2){
        [SVProgressHUD showCustomInfoWithStatus:@"分享失败"];
    }
}

@end
