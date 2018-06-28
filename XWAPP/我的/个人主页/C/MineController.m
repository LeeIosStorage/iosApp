//
//  MineController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/26.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MineController.h"
#import "MineHeader.h"
#import "MyWallet.h"
#import "MineFirstCell.h"
#import "MineSecondCell.h"
#import "MineThirdCell.h"
#import "MineNaView.h"
#import "LECollectViewController.h"
#import "YQMController.h"
#import "LEWebViewController.h"
#import "LEAttentionViewController.h"
#import "LECommentListViewController.h"
#import "WithdrawController.h"
#import "WXApi.h"
#import "LELoginAuthManager.h"
#import "LEMessageViewController.h"
#import "LELoginAuthManager.h"

#define cell_title @"title"
#define cell_type @"type"

typedef NS_ENUM(NSInteger, LEMineCellType) {
    LEMineCellTypeNone = 0,
    LEMineCellTypeRecruit,          //邀请收徒
    LEMineCellTypeGreenHand,        //新手任务
    LEMineCellTypeInvitationCode,   //邀请码
    LEMineCellTypeBindingWeixin,    //绑定微信
    LEMineCellTypeAttention,        //我的关注
    LEMineCellTypeCollect,          //我的收藏
    LEMineCellTypeComment,          //我的评论
    
};

@interface MineController ()
<
SDCycleScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>
{
    BOOL _viewDidAppear;
}

@property (nonatomic, strong) MineHeader *header;

@property (strong, nonatomic) UIImageView *tableBackgroundView;

@end

@implementation MineController

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[HitoImage(@"mine_top_background") stretchableImageWithLeftCapWidth:HitoScreenW/2 topCapHeight:0] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self refreshSecondArray];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _viewDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewDidAppear = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTB];
    [self addMJ];
    [self setNaStyle];
    [self navAction];
    
    [self refreshViewUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
//    _header.allBottomViewTop.constant = HitoActureHeight(40) / 3;
//    _header.centerBigView.constant = HitoActureHeight(60) / 2;
}

- (void)tabBarSelectRefreshData{
    if (![self.tableView.mj_header isRefreshing] && _viewDidAppear) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)refreshTaskInfoUI:(NSNotification *)notif{
    [self refreshSecondArray];
}

- (void)refreshUserInfoUI:(NSNotification *)notif{
    [self refreshViewUI];
}

#pragma mark -
#pragma mark - Request
- (void)refreshUserInfo{
    
    HitoWeakSelf;
    [LELoginUserManager refreshUserInfoRequestSuccess:^(BOOL isSuccess, NSString *message) {
        
        [WeakSelf.tableView.mj_header endRefreshing];
        if (isSuccess) {
            [WeakSelf refreshViewUI];
        }else{
            
        }
    }];
    
    
    //任务列表刷新
    [[LELoginAuthManager sharedInstance] refreshTaskInfoRequestSuccess:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf refreshSecondArray];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark - addTBHeaderView
- (void)addHeaderView {
    if (!_header) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"MineHeader" owner:self options:nil] firstObject];

        _header.leftMine.topLB.text = @"我的金币(个)";
        _header.centerMine.topLB.text = @"我的零钱(元)";
        _header.rightMine.topLB.text = @"阅读时长(分钟)";
        _header.rightMine.lineView.hidden = YES;
        
        HitoWeakSelf;
        [_header leftClickAction:^{
            [MobClick event:kMineGoldClick];
            MyWallet *wallet = [[MyWallet alloc] init];
            wallet.hidesBottomBarWhenPushed = YES;
            [WeakSelf.navigationController pushViewController:wallet animated:YES];
        }];
        
        [_header centerClickAction:^{
            [MobClick event:kMineBalanceClick];
            MyWallet *wallet = [[MyWallet alloc] init];
            wallet.hidesBottomBarWhenPushed = YES;
            [WeakSelf.navigationController pushViewController:wallet animated:YES];
        }];
    }
    
    UIView *hh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoActureHeight(134)+39)];
    self.header.frame = hh.frame;
    [hh addSubview:self.header];
    self.tableView.tableHeaderView = hh;
}

- (void)refreshViewUI{
    
    _header.leftMine.bottomLB.text = [NSString stringWithFormat:@"%ld",[LELoginUserManager todayGolds]];
    _header.centerMine.bottomLB.text = [NSString stringWithFormat:@"%.2f",[LELoginUserManager balance]];
    _header.rightMine.bottomLB.text = [NSString stringWithFormat:@"%.1f",[LELoginUserManager readDuration]];
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:[LELoginUserManager headImgUrl]] setImage:_header.avatarImageView setbitmapImage:[UIImage imageNamed:@"LOGO"]];
    
}

-(void)sendAuthRequest
{
    HitoWeakSelf;
    [SVProgressHUD showCustomWithStatus:nil];
    [[LELoginAuthManager sharedInstance] socialAuthBinding:UMSocialPlatformType_WechatSession presentingController:self success:^(BOOL success) {
        if (success) {
            
        }
        [WeakSelf.tableView reloadData];
    }];
    [SVProgressHUD dismiss];
}

#pragma mark - setTB

- (void)setTB {
    [self addHeaderView];
    //防止TABBAR灰色
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 80)];
    footerView.backgroundColor = self.view.backgroundColor;
    self.tableView.tableFooterView = footerView;
    
    //初始化数据
    self.secondArr = [NSMutableArray array];
    self.fourArr = [NSMutableArray array];
    
    [self.fourArr addObject:@{cell_title:@"我的收藏",cell_type:@(LEMineCellTypeCollect)}];
    [self.fourArr addObject:@{cell_title:@"我的评论",cell_type:@(LEMineCellTypeComment)}];
    
    _imageArr = [NSMutableArray arrayWithArray:@[]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskInfoUI:) name:kRefreshUITaskInfoNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserInfoUI:) name:kRefreshUILoginNotificationKey object:nil];
    
}

- (void)refreshSecondArray{
    
    self.secondArr = [NSMutableArray array];
    [self.secondArr addObject:@{cell_title:@"每收一名徒弟赚3500金币，可立即领取提现",cell_type:@(LEMineCellTypeRecruit)}];
    if ([LELoginAuthManager sharedInstance].taskList.count == 0) {
        if (![[LELoginAuthManager sharedInstance] taskCompletedWithGreenHandTask]) {
            [self.secondArr addObject:@{cell_title:@"新手任务",cell_type:@(LEMineCellTypeGreenHand)}];
        }
        if (![[LELoginAuthManager sharedInstance] taskCompletedWithTaskType:LETaskCenterTypeInvitationCode]) {
            [self.secondArr addObject:@{cell_title:@"输入邀请码",cell_type:@(LEMineCellTypeInvitationCode)}];
        }
        if (![[LELoginAuthManager sharedInstance] taskCompletedWithTaskType:LETaskCenterTypeBindingWeixin]) {
            [self.secondArr addObject:@{cell_title:@"微信绑定",cell_type:@(LEMineCellTypeBindingWeixin)}];
        }
    }
    [self.tableView reloadData];
}


- (void)navAction {

    [_naView btnActionLeft:^{
        //
    }];
    [_naView btnActionRight:^{
        //
    }];
    
}

- (IBAction)leftBarButton:(UIBarButtonItem *)sender {
    [MobClick event:kMessageCenterClick];
    LEMessageViewController *messageVc = [[LEMessageViewController alloc] init];
    messageVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVc animated:YES];
}

- (IBAction)rightBarButton:(UIBarButtonItem *)sender {
    
}

-(void)handleClickAt:(id)sender event:(id)event{
    
    WithdrawController *withdrawVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WithdrawController"];
    [self.navigationController pushViewController:withdrawVc animated:YES];
}

#pragma mark -TBDelegate
#pragma mark - TBDelegate&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return _secondArr.count;
            break;
        case 2:
            return 1;
            break;
        default:
            return _fourArr.count;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        MineFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineFirstCell"];
        
        [cell.rightButton addTarget:self action:@selector(handleClickAt:event:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else if (indexPath.section == 1) {
        MineSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineSecondCell"];
        NSDictionary *dic = _secondArr[indexPath.row];
        cell.leftLB.text = dic[cell_title];
        cell.rightLabel.hidden = YES;
        LEMineCellType cellType = [[dic objectForKey:cell_type] integerValue];
        if (cellType == LEMineCellTypeBindingWeixin) {
            if ([LELoginUserManager wxNickname].length > 0) {
                cell.rightLabel.hidden = NO;
                cell.rightLabel.text = [NSString stringWithFormat:@"已绑定(%@)",[LELoginUserManager wxNickname]];
            }
        }
        return cell;
    } else if (indexPath.section == 2) {
        MineThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineThirdCell"];

        SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, HitoScreenW, cell.frame.size.height) delegate:self placeholderImage:nil];
        cycle.backgroundColor = [UIColor whiteColor];
        cycle.localizationImageNamesGroup = [NSArray arrayWithObjects:@"banner_fenxiang",@"banner_fenxiang1",@"banner_fenxiang2", nil];
//        cycle.imageURLStringsGroup = self.imageArr;
        [cell.centerView addSubview:cycle];
        return cell;
    } else {
        MineSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineSecondCell"];
        cell.rightLabel.hidden = YES;
        NSDictionary *dic = _fourArr[indexPath.row];
        cell.leftLB.text = dic[cell_title];
        return cell;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 8)];
    footView.backgroundColor = HitoColorFromRGB(0Xf1f1f1);
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 71;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2) {
        return HitoActureHeight(61);
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
    } else if (indexPath.section == 1) {
        
        NSDictionary *dic = _secondArr[indexPath.row];
        LEMineCellType cellType = [[dic objectForKey:cell_type] integerValue];
        
        if (cellType == LEMineCellTypeRecruit) {
            //邀请活动
            NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppInviteActivityWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken]];
            LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:webUrl];
            webVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVc animated:YES];
        }else if (cellType == LEMineCellTypeGreenHand){
            [self.tabBarController setSelectedIndex:1];
        }else if (cellType == LEMineCellTypeInvitationCode){
            YQMController *yqm = [[YQMController alloc] init];
            yqm.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yqm animated:YES];
        }else if (cellType == LEMineCellTypeBindingWeixin){
            [self sendAuthRequest];
        }
        
    } else if (indexPath.section == 2) {
        
    } else {
        NSDictionary *dic = _fourArr[indexPath.row];
        LEMineCellType cellType = [[dic objectForKey:cell_type] integerValue];
        if (cellType == LEMineCellTypeAttention) {
            
            LEAttentionViewController *attentionVc = [[LEAttentionViewController alloc] init];
            attentionVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:attentionVc animated:YES];
            
        }else if (cellType == LEMineCellTypeCollect) {
            
            LECollectViewController *collectVc = [[LECollectViewController alloc] init];
            collectVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collectVc animated:YES];
            
        }else if (cellType == LEMineCellTypeComment) {
            
            LECommentListViewController *commentVc = [[LECommentListViewController alloc] init];
            commentVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commentVc animated:YES];
            
        }
    }
}


#pragma mark -
#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    MJWeakSelf;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshUserInfo];
    }];
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark - Set And Getters
- (UIImageView *)tableBackgroundView{
    if (!_tableBackgroundView) {
        _tableBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_back"]];

    }
    return _tableBackgroundView;
}

#pragma mark -
#pragma mark - SDCycleScrollViewDelegate  轮播图的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppInviteActivityWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken]];
    LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:webUrl];
    webVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
    
}


#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    if (offset.y <= 0) {
        self.tableView.backgroundView = self.tableBackgroundView;
        [self setCustomTitle:@""];
    }else{
        self.tableView.backgroundView = nil;
        [self setCustomTitle:[LELoginUserManager nickName]];
    }
}

@end
