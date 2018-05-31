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

#pragma mark -
#pragma mark - Set And Getters
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@[@"新手阅读奖励", @"绑定微信", @"输入邀请码得红包"], @[@"邀请收徒", @"晒晒收入", @"唤醒徒弟", @"分享到朋友圈", @"阅读资讯", @"优质评论", @"阅读推送咨询", @"问券调查"]];
    }
    return _dataArr;
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
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    cell.leftLB.text = self.dataArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            cell.longLine.hidden = NO;
        } else if (indexPath.row == 1) {
            cell.rightIM.image = HitoImage(@"task_hongbao");
        }
    } else {

        cell.shortView.hidden = NO;
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
    YQMController *yqm = [[YQMController alloc] init];
    yqm.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yqm animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
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
