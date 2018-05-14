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




@interface MyWallet ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerFirst;
@property (weak, nonatomic) IBOutlet UIView *headerSecond;
@property (weak, nonatomic) IBOutlet PNLineChart *chartView;

@property (nonatomic, strong) UIView *bottonView;


@end

@implementation MyWallet

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
    [self addBottonView];
}

- (void)addBottonView {
    
    _bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, HitoScreenH - 58 - 64, HitoScreenW, 58)];
    _bottonView.backgroundColor = HitoWhiteColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(12, 9, HitoActureWidth(137), 42);
//    [btn setBackgroundColor:HitoColorFromRGB(0Xff4b41)];
    [btn setTitleColor:HitoColorFromRGB(0xf9473d) forState:UIControlStateNormal];
    [btn setTitle:@"收入排行榜" forState:UIControlStateNormal];
    btn.titleLabel.font = HitoPFSCMediumOfSize(14);
    btn.layer.cornerRadius = 21;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = HitoColorFromRGB(0xf9473d).CGColor;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottonView addSubview:btn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(HitoActureWidth(165), 9, HitoActureWidth(198), 42);
    rightBtn.layer.cornerRadius = 21;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setBackgroundColor:HitoColorFromRGB(0xff4b41)];
    [rightBtn setTitleColor:HitoColorFromRGB(0xffffff) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = HitoPFSCMediumOfSize(14);
    [rightBtn setTitle:@"分享获得金币" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottonView addSubview:rightBtn];
    [self.tableView addSubview:_bottonView];
    
    //
    _bottonView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    _bottonView.layer.shadowOpacity = 0.8f;

    _bottonView.layer.shadowRadius = 4.0f;

    _bottonView.layer.shadowOffset = CGSizeMake(4,4);
}

- (void)btnAction:(UIButton *)sender {
    
}
- (void)rightBtnAction:(UIButton *)sender {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 1)];
    backView.backgroundColor = HitoColorFromRGB(0Xd9d9d9);
    self.navigationController.navigationBar.shadowImage = [self convertViewToImage:backView];
}

// get image
-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setView {

    self.title = @"我的钱包";
    self.tableView.rowHeight = 44;
    [self setAAChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAAChartView {

    [_chartView setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5"]];
    NSArray * data01Array = @[@60.1, @160.1, @126.4, @262.2, @186.2];

    
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = PNFreshGreen;
    data01.itemCount = _chartView.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    _chartView.chartData = @[data01];
    [_chartView strokeChart];
    _chartView.showSmoothLines = YES;
    _chartView.showCoordinateAxis = YES;

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletCell"];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WalletHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"WalletHeader" owner:self options:nil] firstObject];
    header.frame = CGRectMake(0, 0, HitoScreenW, 100);
    
    [header leftBlockAction:^{
        //
    }];
    
    [header rightBlockAction:^{
        //
    }];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 56;
}


#pragma mark - scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _bottonView.frame = CGRectMake(0, HitoScreenH - 64 - 58 + scrollView.contentOffset.y, HitoScreenW, 58);
}



@end
