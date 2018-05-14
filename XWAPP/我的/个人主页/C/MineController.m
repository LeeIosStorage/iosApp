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




@interface MineController () <SDCycleScrollViewDelegate>


@property (nonatomic, strong) MineHeader *header;

@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTB];
    [self addMJ];
    [self setNaStyle];
    [self navAction];
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    _header.allBottomViewTop.constant = HitoActureHeight(40) / 3;
    _header.centerBigView.constant = HitoActureHeight(60) / 2;

    
}

#pragma mark - addTBHeaderView

- (void)addHeaderView {
    if (!_header) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"MineHeader" owner:self options:nil] firstObject];

        _header.leftMine.topLB.text = @"我的金币(个)";
        _header.centerMine.topLB.text = @"我的零钱(元)";
        _header.rightMine.topLB.text = @"阅读市场(分钟)";

        [_header leftClickAction:^{
            MyWallet *wallet = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyWallet"];
            [self.navigationController pushViewController:wallet animated:YES];
        }];
    }
    
    UIView *hh = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoActureHeight(173))];
    self.header.frame = hh.frame;
    [hh addSubview:self.header];
    self.tableView.tableHeaderView = hh;
}

#pragma mark - setTB

- (void)setTB {
    [self addHeaderView];
    //防止TABBAR灰色
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.tableView.backgroundColor= [UIColor clearColor];
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mine_back"]];
    self.tableView.backgroundView = imageView;
    
    //初始化数据
    _secondArr = @[@"每收一名徒弟赚3500金币，可立即领取提现", @"新手任务", @"输入邀请码", @"微信绑定"];
    _fourArr = @[@"我的关注", @"我的收藏", @"我的评论"];
    _imageArr = @[@"https://img3.duitang.com/uploads/item/201410/02/20141002100803_ndjUZ.jpeg", @"https://img3.duitang.com/uploads/item/201410/02/20141002100803_ndjUZ.jpeg", @"https://img3.duitang.com/uploads/item/201410/02/20141002100803_ndjUZ.jpeg", @"https://img3.duitang.com/uploads/item/201410/02/20141002100803_ndjUZ.jpeg"];
    
}


- (void)navAction {

    [_naView btnActionLeft:^{
        //
    }];
    [_naView btnActionRight:^{
        //
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:HitoImage(@"mine_background") forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (IBAction)leftBarButton:(UIBarButtonItem *)sender {
}

- (IBAction)rightBarButton:(UIBarButtonItem *)sender {
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
            return 4;
            break;
        case 2:
            return 1;
            break;
        default:
            return 3;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        MineFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineFirstCell"];
        return cell;
    } else if (indexPath.section == 1) {
        MineSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineSecondCell"];
        cell.leftLB.text = _secondArr[indexPath.row];
        return cell;
    } else if (indexPath.section == 2) {
        MineThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineThirdCell"];

        SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, HitoScreenW, cell.frame.size.height) delegate:self placeholderImage:HitoImage(@"mine_top_background")];
        cycle.imageURLStringsGroup = self.imageArr;
        [cell.centerView addSubview:cycle];
        return cell;
    } else {
        MineSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineSecondCell"];
        cell.leftLB.text = _fourArr[indexPath.row];
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
        return 59;
    } else {
        return 44;
    }
}




#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            
            
            
        });
        
        dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
            
            
            
        });
        
    }];
    //上啦加载
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        //
    }];
}

#pragma mark - sdcycleDelegate

#pragma mark - SDCycleScrollViewDelegate  轮播图的点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}





@end
