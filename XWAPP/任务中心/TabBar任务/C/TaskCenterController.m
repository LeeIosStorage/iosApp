//
//  TaskCenterController.m
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "TaskCenterController.h"
#import "TaskCell.h"
#import "TaskCellHeader.h"
#import "YQMController.h"
#import "LERefreshHeader.h"
#import "LETaskListModel.h"
#import "LELoginAuthManager.h"
#import "LEWebViewController.h"
#import "MyWallet.h"
#import "WYShareManager.h"
#import <SDWebImageManager.h>
#import "LELoginAuthManager.h"

#define BoxTimeInterval  4*60*60

@interface TaskCenterController ()
<
UITabBarControllerDelegate,
WXShaerStateDelegate
>
{
    BOOL _isGetLastOperateTime;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSTimer *countDownTimer;

@property (strong, nonatomic) NSDictionary *signInConfig;

@property (strong, nonatomic) NSDate *lastOperateTime;
@property (assign, nonatomic) int secondsCountDown;

@end

@implementation TaskCenterController

#pragma mark -
#pragma mark - Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [WYShareManager shareInstance].delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaStyle];
    [self setUpNormalView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarSelectRefreshData{
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - setNormalView
- (void)setUpNormalView {
    
    self.title = @"任务中心";
    self.daySuper.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTaskInfoUI:) name:kRefreshUITaskInfoNotificationKey object:nil];
    
    [self refreshDayViewStatus];
    
    _isGetLastOperateTime = NO;
    self.secondsCountDown = 0;
    [self refreshBoxViewStatus];
    
    [self.qiandaoBtn setTitle:@"明日签到可领金币" forState:UIControlStateDisabled];
    [self refreshSignInButtonStatus:NO];
    
    [self addMJ];
    
    self.headerView.height = HitoActureHeight(228) + 165;
    [self.tableView reloadData];
}

- (void)addMJ {
    //下拉刷新
    MJWeakSelf;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshTaskInfoRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshTaskInfoUI:(NSNotification *)notif{
    
    id dataObject = notif.object;
    [self setTaskListData:dataObject];
}

#pragma mark -
#pragma mark - Private
- (void)refreshUI{
    [self refreshDayViewStatus];
}

- (void)refreshSignInButtonStatus:(BOOL)enabled
{
    self.qiandaoBtn.enabled = enabled;
    if (enabled) {
        [self.qiandaoBtn setBackgroundColor:HitoColorFromRGB(0xffb636)];
    }else{
        [self.qiandaoBtn setBackgroundColor:HitoColorFromRGB(0xdadada)];
    }
}

- (void)refreshDayViewStatus{
    
    for (id subView in self.daySuper.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageview = (UIImageView *)subView;
            int tag = (int)imageview.tag;
            int golds = [[_signInConfig objectForKey:[NSString stringWithFormat:@"day%d",tag+1]] intValue];
            BOOL isSigned = [[_signInConfig objectForKey:[NSString stringWithFormat:@"day%d_is_signed",tag+1]] boolValue];
            UIView *itemView = [self.daySuper viewWithTag:tag+10];
            UILabel *label = [itemView viewWithTag:0];
            UILabel *hLabel = [itemView viewWithTag:1];
            label.text = [NSString stringWithFormat:@"%d",golds];
            hLabel.text = [NSString stringWithFormat:@"+%d",golds];
            if (isSigned) {
                imageview.highlighted = YES;
                label.hidden = YES;
                hLabel.hidden = NO;
            }else{
                imageview.highlighted = NO;
                label.hidden = NO;
                hLabel.hidden = YES;
            }
        }
    }
}

- (int)todaySignInGold{
    int gold = 0;
    for (int i = 0; i < _signInConfig.count; i ++) {
        int golds = [[_signInConfig objectForKey:[NSString stringWithFormat:@"day%d",i+1]] intValue];
        BOOL isSigned = [[_signInConfig objectForKey:[NSString stringWithFormat:@"day%d_is_signed",i+1]] boolValue];
        if (isSigned) {
            int golds = [[_signInConfig objectForKey:[NSString stringWithFormat:@"day%d",i+1]] intValue];
            BOOL isSigned = [[_signInConfig objectForKey:[NSString stringWithFormat:@"day%d_is_signed",i+2]] boolValue];
            if (!isSigned) {
                LELog(@"%@",[NSString stringWithFormat:@"day%d_is_signed",i+2]);
                return golds;
            }
        }else{
            return golds;
        }
    }
    return gold;
}

- (void)refreshBoxViewStatus{
    if (_secondsCountDown <= 0) {
        
        [_boxIM setHighlighted:NO];
        _centerLB.hidden = NO;
        _topLB.hidden = YES;
        _bottomIM.hidden = YES;
        _bottomLB.hidden = YES;
        [_boxView setBackgroundColor:HitoColorFromRGB(0xFFCD50)];
        
    }else{
        [_boxIM setHighlighted:YES];
        _centerLB.hidden = YES;
        _topLB.hidden = NO;
        _bottomIM.hidden = NO;
        _bottomLB.hidden = NO;
        [_boxView setBackgroundColor:HitoColorFromRGB(0xdadada)];
        
        //设置定时器
        if (_countDownTimer) {
            [self stopTimer];
        }
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
        NSString *format_time = [WYCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",self.secondsCountDown]];
        self.bottomLB.text = [NSString stringWithFormat:@"%@",format_time];
    }
}

-(void)countDownAction{
    //倒计时-1
    self.secondsCountDown--;
    LELog(@"%d",self.secondsCountDown);
    
    NSString *format_time = [WYCommonUtils secondChangToDateString:[NSString stringWithFormat:@"%d",self.secondsCountDown]];
    self.bottomLB.text = [NSString stringWithFormat:@"%@",format_time];
    
    if(self.secondsCountDown <= 0){
        [self stopTimer];
        [self refreshBoxViewStatus];
    }
}

- (void)stopTimer{
    [_countDownTimer invalidate];
    _countDownTimer = nil;
}

- (void)setTaskListData:(id)dataObject{

    NSArray *array = [NSArray modelArrayWithClass:[LETaskListModel class] json:dataObject];
    [self.taskLists removeAllObjects];
    
    NSMutableDictionary *mutDic1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *mutDic2 = [NSMutableDictionary dictionary];
    NSMutableArray *mutArray1 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *mutArray2 = [NSMutableArray arrayWithCapacity:8];
    for (LETaskListModel *taskModel in array) {
        if (taskModel.taskStatus == 1) {
            continue;
        }
        if (taskModel.type == 1) {
            [mutArray1 addObject:taskModel];
        }else if (taskModel.type == 2){
            [mutArray2 addObject:taskModel];
        }
    }
    
    if (mutArray1.count > 0) {
        [mutDic1 setObject:mutArray1 forKey:@"data"];
        [mutDic1 setObject:@"新手任务" forKey:@"title"];
        [mutDic1 setObject:@"task_xinshourenwu" forKey:@"image"];
        [self.taskLists addObject:mutDic1];
    }
    if (mutArray2.count > 0) {
        [mutDic2 setObject:mutArray2 forKey:@"data"];
        [mutDic2 setObject:@"日常任务" forKey:@"title"];
        [mutDic2 setObject:@"task_richagnrenwu" forKey:@"image"];
        [self.taskLists addObject:mutDic2];
    }
    
    [self.tableView reloadData];
    
}

-(void)sendAuthRequest
{
    [MobClick event:kTaskCenterBingWXClick];
    HitoWeakSelf;
    [SVProgressHUD showCustomWithStatus:nil];
    [[LELoginAuthManager sharedInstance] socialAuthBinding:UMSocialPlatformType_WechatSession presentingController:self success:^(BOOL success) {
        if (success) {
            [SVProgressHUD showCustomInfoWithStatus:@"微信绑定成功"];
        }
        [WeakSelf.tableView reloadData];
    }];
}

- (void)pushWebViewController:(NSString *)url{
    //邀请活动
    LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:url];
    webVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)shareImageToWXTimeline{
    
    
    NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@&code=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppSharePackageWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken],[LELoginUserManager invitationCode]];
    NSString *shareTitle = @"在这里看了几天新闻,还能赚钱,一开始不信,现在我已经爱上这了!";
    NSString *shareDescription = @"";
    [WYShareManager shareInstance].delegate = self;
    [[WYShareManager shareInstance] shareToWXWithScene:WXSceneTimeline title:shareTitle description:shareDescription webpageUrl:webUrl image:nil isVideo:NO];
    
    
    return;
//    UIImage *shareImage = nil;
    [SVProgressHUD showCustomWithStatus:nil];
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527856210447&di=82ac636ef350de01ef175ad25a6fd144&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F58%2Fd%2F2.jpg"] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            [SVProgressHUD dismiss];
            [[WYShareManager shareInstance] shareToWXWithImage:image scene:WXSceneTimeline];
        }else{
            [SVProgressHUD showCustomErrorWithStatus:@"网络问题请重试"];
        }
    }];
}

#pragma mark -
#pragma mark - Set And Getters
- (NSMutableArray *)taskLists {
    if (!_taskLists) {
        _taskLists = [NSMutableArray arrayWithCapacity:0];
    }
    return _taskLists;
}

#pragma mark -
#pragma mark - Request
- (void)refreshTaskInfoRequest{
    
    HitoWeakSelf;
    [[LELoginAuthManager sharedInstance] refreshTaskInfoRequestSuccess:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf.tableView.mj_header endRefreshing];
        });
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        
        [WeakSelf setTaskListData:dataObject];
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_header endRefreshing];
    }];
    
    [self getSignConfig];
    [self checkCoinBoxRequest];
    return;
    
//
//    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserTask"];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
////    requesUrl = [NSString stringWithFormat:@"%@uid=%@",requesUrl,[LELoginUserManager userID]];
//    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [WeakSelf.tableView.mj_header endRefreshing];
//        });
//
//        if (requestType != WYRequestTypeSuccess) {
//            return;
//        }
//        [WeakSelf refreshSignInButtonStatus:YES];
//        [WeakSelf setTaskListData:dataObject];
//
//
//    } failure:^(id responseObject, NSError *error) {
//        [WeakSelf.tableView.mj_header endRefreshing];
//    }];
    
}

- (void)getSignConfig{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetSignConfig"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        WeakSelf.signInConfig = [NSDictionary dictionaryWithDictionary:dataObject];
        [WeakSelf refreshUI];
        
        BOOL isSignIn = [[WeakSelf.signInConfig objectForKey:@"today_is_signed"] boolValue];
        NSString *goldString = [NSString stringWithFormat:@"明日签到可领%d金币",[WeakSelf todaySignInGold]];
        [WeakSelf.qiandaoBtn setTitle:goldString forState:UIControlStateDisabled];
        [WeakSelf refreshSignInButtonStatus:!isSignIn];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)signInRequest{
    
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"AddUserSign"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {


        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"签到成功"];
        [WeakSelf getSignConfig];


    } failure:^(id responseObject, NSError *error) {

    }];
}

- (void)checkCoinBoxRequest{
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"CheckCoinBox"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        WeakSelf.lastOperateTime = [WYCommonUtils dateFromUSDateString:[dataObject objectForKey:@"last_operate_time"]];
        if ([WeakSelf.lastOperateTime isEqual:[NSNull null]]) {
            WeakSelf.lastOperateTime = nil;
        }
        self->_isGetLastOperateTime = YES;
        NSTimeInterval spaceTime = BoxTimeInterval;
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:WeakSelf.lastOperateTime];
        WeakSelf.secondsCountDown = spaceTime-timeInterval;
        [WeakSelf refreshBoxViewStatus];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)openBoxRequest{
    
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"OpenCoinBox"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        [SVProgressHUD dismiss];
        int gold = [[dataObject objectForKey:@"data"] intValue];
        [MBProgressHUD showCustomGoldTipWithTask:@"开启宝箱" gold:[NSString stringWithFormat:@"+%d",gold]];
        WeakSelf.secondsCountDown = BoxTimeInterval;
        [WeakSelf refreshBoxViewStatus];
        [WeakSelf checkCoinBoxRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskLists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.taskLists[section];
    NSArray *array = dic[@"data"];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    NSDictionary *sectionDic = [self.taskLists objectAtIndex:indexPath.section];
    NSArray *sectionArray = sectionDic[@"data"];
    LETaskListModel *taskModel = [sectionArray objectAtIndex:indexPath.row];
    [cell updateCellData:taskModel];
    
    cell.longLine.hidden = YES;
    cell.shortView.hidden = YES;
    if (indexPath.section != 0) {
        cell.shortView.hidden = NO;
    }
    if (indexPath.row == sectionArray.count-1) {
        cell.shortView.hidden = YES;
        cell.longLine.hidden = NO;
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TaskCellHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"TaskCellHeader" owner:self options:nil] firstObject];

    NSDictionary *sectionDic = [self.taskLists objectAtIndex:section];
    header.leftLB.text = sectionDic[@"title"];
    header.leftIM.image = HitoImage(sectionDic[@"image"]);
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *sectionDic = [self.taskLists objectAtIndex:indexPath.section];
    NSArray *sectionArray = sectionDic[@"data"];
    LETaskListModel *taskModel = [sectionArray objectAtIndex:indexPath.row];
    
    switch (taskModel.taskType) {
        case LETaskCenterTypeGreenHandRead:
        {
//            [self.tabBarController setSelectedIndex:0];
            NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppReadingRewardWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken]];
            [self pushWebViewController:webUrl];
        }
            break;
        case LETaskCenterTypeReadInformation:
        {
            [self.tabBarController setSelectedIndex:0];
        }
            break;
        case LETaskCenterTypeHighComment:
        {
            [self.tabBarController setSelectedIndex:0];
        }
            break;
        case LETaskCenterTypeBindingWeixin:
        {
            [self sendAuthRequest];
        }
            break;
        case LETaskCenterTypeInvitationCode:
        {
            YQMController *yqm = [[YQMController alloc] init];
            yqm.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:yqm animated:YES];
        }
            break;
        case LETaskCenterTypeInvitationRecruit:
        {
            [MobClick event:kTaskCenterInvitationRecruitClick];
            NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppInviteActivityWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken]];
            [self pushWebViewController:webUrl];
        }
            break;
        case LETaskCenterTypeShowIncome:
        {
            MyWallet *wallet = [[MyWallet alloc] init];
            wallet.needShare = YES;
            wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wallet animated:YES];
        }
            break;
        case LETaskCenterTypeWakeApprentice:
        {
            NSString *webUrl = [NSString stringWithFormat:@"%@/%@?userId=%@&token=%@",[WYAPIGenerate sharedInstance].baseWebUrl,kAppInviteActivityWebURLPath,[LELoginUserManager userID],[LELoginUserManager authToken]];
            [self pushWebViewController:webUrl];
        }
            break;
        case LETaskCenterTypeShareTimeline:
        {
            [self shareImageToWXTimeline];
        }
            break;
        case LETaskCenterTypeReadPushInformation:
        {
            [self.tabBarController setSelectedIndex:0];
        }
            break;
        case LETaskCenterTypeQuestionnaire:
        {
//            [self pushWebViewController:@""];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -SBAction

- (IBAction)qiandaoAction:(UIButton *)sender {
    [MobClick event:kTaskCenterSignInClick];
    [self signInRequest];
}

- (IBAction)openBoxAction:(UITapGestureRecognizer *)sender {
    [MobClick event:kTaskCenterOpenBoxClick];
    if (self.secondsCountDown <= 0 && _isGetLastOperateTime) {
        [self openBoxRequest];
    }
}

#pragma mark -
#pragma mark - WXShaerStateDelegate
- (void)sendState:(int)state{
    if (state == 1) {
        LETaskListModel *taskModel = [[LELoginAuthManager sharedInstance] getTaskWithTaskType:LETaskCenterTypeShareTimeline];
        [[LELoginAuthManager sharedInstance] updateUserTaskStateRequestWith:taskModel.taskId success:^(BOOL success) {
            if (success) {
                [MBProgressHUD showCustomGoldTipWithTask:@"分享朋友圈" gold:[NSString stringWithFormat:@"+%d",[taskModel.coin intValue]]];
            }else{
                [SVProgressHUD showCustomInfoWithStatus:@"分享成功"];
            }
        }];
    }else if (state == 2){
        [SVProgressHUD showCustomInfoWithStatus:@"分享失败"];
    }
}

@end
