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

@interface TaskCenterController ()
<
UITabBarControllerDelegate
>
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) NSTimer *countDownTimer;

@property (assign, nonatomic) int signInDay;

@property (assign, nonatomic) int secondsCountDown;

@end

@implementation TaskCenterController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    
    self.signInDay = 0;
    [self refreshDayViewStatus];
    
    self.secondsCountDown = 0;
    [self refreshBoxViewStatus];
    
    [self.qiandaoBtn setTitle:@"明日签到可领15金币" forState:UIControlStateDisabled];
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

#pragma mark -
#pragma mark - Private
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
            if (tag < self.signInDay) {
                imageview.highlighted = YES;
            }else{
                imageview.highlighted = NO;
            }
        }
    }
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

- (void)setTaskListData{

    [self.taskLists removeAllObjects];
    NSMutableArray *mutArray1 = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *mutArray2 = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 11; i ++ ) {
        
        LETaskListModel *taskModel = [LETaskListModel new];
        taskModel.taskId = [NSString stringWithFormat:@"%d",i + 1];
        taskModel.taskType = i+1;
        taskModel.taskStatus = 0;
        if (i < 3) {
            if (i == 0) {
                taskModel.taskTitle = @"新手阅读奖励";
                taskModel.taskDescription = @"新手阅读奖励新手阅读奖励新手阅读奖励新手阅读奖励新手阅读奖励";
                taskModel.coin = @"+100";
                taskModel.coinType = 0;
            }else if (i == 1){
                taskModel.taskTitle = @"绑定微信";
                taskModel.taskDescription = @"绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信绑定微信";
                taskModel.coin = @"+8元";
                taskModel.coinType = 1;
            }else if (i == 2){
                taskModel.taskTitle = @"输入邀请码得红包";
                taskModel.taskDescription = @"新输入邀请码得红包输入邀请码得红包手阅读奖输入邀请码得红包励新手阅读奖励新手阅读输入邀请码得红包奖励新手阅读奖励新手阅读奖励";
                taskModel.coin = @"+10元";
                taskModel.coinType = 1;
            }
            [mutArray1 addObject:taskModel];
        }else{
            if (i == 3) {
                taskModel.taskTitle = @"邀请收徒";
                taskModel.taskDescription = @"邀请收徒邀请收徒邀请收徒邀请收徒邀请收徒";
                taskModel.coin = @"+1000";
                taskModel.coinType = 0;
            }else if (i == 4){
                taskModel.taskTitle = @"晒晒收入";
                taskModel.taskDescription = @"晒晒收入晒晒收入奖励新手阅读奖励新手阅读奖励新手阅读奖励";
                taskModel.coin = @"+50";
                taskModel.coinType = 0;
            }else if (i == 5){
                taskModel.taskTitle = @"唤醒徒弟";
                taskModel.taskDescription = @"唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟唤醒徒弟";
                taskModel.coin = @"+30";
                taskModel.coinType = 0;
            }else if (i == 6){
                taskModel.taskTitle = @"分享到朋友圈";
                taskModel.taskDescription = @"分享到朋友圈奖励新手阅分享到朋友圈读奖励分享到朋友圈阅读奖励分享到朋友圈";
                taskModel.coin = @"+20";
                taskModel.coinType = 0;
            }else if (i == 7){
                taskModel.taskTitle = @"阅读资讯";
                taskModel.taskDescription = @"新阅读资讯手阅读奖励新阅读资讯奖励";
                taskModel.coin = @"+10";
                taskModel.coinType = 0;
            }else if (i == 8){
                taskModel.taskTitle = @"优质评论";
                taskModel.taskDescription = @"优质评论";
                taskModel.coin = @"+10";
                taskModel.coinType = 0;
            }else if (i == 9){
                taskModel.taskTitle = @"阅读推送咨询";
                taskModel.taskDescription = @"阅读推送咨询";
                taskModel.coin = @"+10";
                taskModel.coinType = 0;
            }else if (i == 10){
                taskModel.taskTitle = @"问券调查";
                taskModel.taskDescription = @"问券调查励问券调查问券调查问券调查问券调查";
                taskModel.coin = @"+200";
                taskModel.coinType = 0;
            }
            [mutArray2 addObject:taskModel];
        }
    }
    
    [self.taskLists addObject:mutArray1];
    [self.taskLists addObject:mutArray2];
    
    [self.tableView reloadData];
    
}

-(void)sendAuthRequest
{
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
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"uid"];
    requesUrl = [NSString stringWithFormat:@"%@uid=%@",requesUrl,[LELoginUserManager userID]];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf.tableView.mj_header endRefreshing];
        });
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        [WeakSelf refreshSignInButtonStatus:YES];
        [WeakSelf setTaskListData];
        
        
    } failure:^(id responseObject, NSError *error) {
        [WeakSelf.tableView.mj_header endRefreshing];
    }];
    
}

- (void)signInRequest{
    
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"uid"];
    requesUrl = [NSString stringWithFormat:@"%@uid=%@",requesUrl,[LELoginUserManager userID]];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {


        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"签到成功"];
        [WeakSelf refreshSignInButtonStatus:NO];
        WeakSelf.signInDay ++;
        [WeakSelf refreshDayViewStatus];


    } failure:^(id responseObject, NSError *error) {

    }];
}

- (void)openBoxRequest{
    
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetUserDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"uid"];
    requesUrl = [NSString stringWithFormat:@"%@uid=%@",requesUrl,[LELoginUserManager userID]];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        
        if (requestType != WYRequestTypeSuccess) {
            return;
        }
        [SVProgressHUD dismiss];
        WeakSelf.secondsCountDown = 50;
        [WeakSelf refreshBoxViewStatus];
        
    } failure:^(id responseObject, NSError *error) {
        WeakSelf.secondsCountDown = 20;
        [WeakSelf refreshBoxViewStatus];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.taskLists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.taskLists[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    NSArray *sectionArray = [self.taskLists objectAtIndex:indexPath.section];
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

    if (section == 0) {
        header.leftLB.text = @"新手任务";
        header.leftIM.image = HitoImage(@"task_xinshourenwu");
    } else {
        header.leftLB.text = @"日常任务";
        header.leftIM.image = HitoImage(@"task_richagnrenwu");
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArray = [self.taskLists objectAtIndex:indexPath.section];
    LETaskListModel *taskModel = [sectionArray objectAtIndex:indexPath.row];
    
    switch (taskModel.taskType) {
        case LETaskCenterTypeGreenHandRead:
        {
            [self.tabBarController setSelectedIndex:0];
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
            [self pushWebViewController:kAppInviteActivityWebURL];
        }
            break;
        case LETaskCenterTypeShowIncome:
        {
            MyWallet *wallet = [[MyWallet alloc] init];
            wallet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wallet animated:YES];
        }
            break;
        case LETaskCenterTypeWakeApprentice:
        {
            [self pushWebViewController:kAppInviteActivityWebURL];
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
            [self pushWebViewController:kAppInviteActivityWebURL];
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
    [self signInRequest];
}

- (IBAction)openBoxAction:(UITapGestureRecognizer *)sender {
    if (self.secondsCountDown <= 0) {
        [self openBoxRequest];
    }
}

@end
