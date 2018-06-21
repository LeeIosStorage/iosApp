//
//  SetVC.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SetVC.h"
#import "SetCell.h"
#import "AboutUS.h"
#import "CompleteController.h"
#import "LEWebViewController.h"
#import "UIImageView+WebCache.h"
#import "LEChangePasswordViewController.h"
#import "UIImage+LEAdd.h"

@interface SetVC ()

HitoPropertyNSArray(dataSource);
@property (nonatomic, strong) UIView *bottonView;

@property (assign, nonatomic) unsigned long long cacheSize;

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyle];
    [self addBottonView];
    
    [self getCacheSize];
}

- (void)getCacheSize{
    //获取缓存文件大小
    self.cacheSize = UINT64_MAX;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned long long size = 0;
        size += [[SDImageCache sharedImageCache] getSize];
        HitoWeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            WeakSelf.cacheSize = size;
            [WeakSelf.tableView reloadData];
        });
    });
}

- (void)btnAction:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    HitoWeakSelf;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LELoginUserManager clearUserInfo];
        [WeakSelf.tabBarController setSelectedIndex:0];
        [WeakSelf.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)addBottonView {
    
    _bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, HitoScreenH - 58 - HitoTopHeight, HitoScreenW, 58)];
    _bottonView.backgroundColor = HitoWhiteColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(12, 9, HitoScreenW - 24, 40);
    [btn setBackgroundColor:HitoColorFromRGB(0Xff4b41)];
    [btn setTitleColor:HitoWhiteColor forState:UIControlStateNormal];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottonView addSubview:btn];
    [self.view addSubview:_bottonView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@[@"完善资料", @"修改密码", @"清除缓存", @"给乐头条评分", @"隐私协议"], @[@"关于我们"]];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)clearCacheAction{
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD showCustomWithStatus:nil];
    
    [[SDImageCache sharedImageCache] clearMemory];
    HitoWeakSelf;
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        [SVProgressHUD setCurrentDefaultStyle];
        [SVProgressHUD showCustomInfoWithStatus:@"缓存已清空"];
        WeakSelf.cacheSize = 0;
        [WeakSelf.tableView reloadData];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *arr = self.dataSource[section];
    return arr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    cell.leftLB.text = title;
    
    cell.rightLB.hidden = YES;
    if ([title isEqualToString:@"清除缓存"]) {
        cell.rightLB.hidden = NO;
        if (self.cacheSize != UINT64_MAX) {
            NSString* cacheSizeStr = @"";
            if (self.cacheSize > 1024*1024*1024) {
                cacheSizeStr = [NSString stringWithFormat:@"%.2f GB", self.cacheSize*1.0/(1024*1024*1024)];
            } else {
                cacheSizeStr = [NSString stringWithFormat:@"%.2f MB", self.cacheSize*1.0/(1024*1024)];
            }
            cell.rightLB.text = cacheSizeStr;
        }else{
            cell.rightLB.text = @"正在计算...";
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 8)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"关于我们"]) {
        
        AboutUS *about = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
        [self.navigationController pushViewController:about animated:YES];
        
    }else if ([title isEqualToString:@"隐私协议"]){
        
        LEWebViewController *webVc = [[LEWebViewController alloc] initWithURLString:kAppPrivacyProtocolURL];
        [self.navigationController pushViewController:webVc animated:YES];
        
    }else if ([title isEqualToString:@"清除缓存"]){
        
        [self clearCacheAction];
        
    }else if ([title isEqualToString:@"修改密码"]){
        
        LEChangePasswordViewController *changePasswordVc = [[LEChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:changePasswordVc animated:YES];
        
    }else if ([title isEqualToString:@"完善资料"]){
        CompleteController *complete = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CompleteController"];
        [self.navigationController pushViewController:complete animated:YES];
        
    }else if ([title isEqualToString:@"给乐头条评分"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1396367553"]];//https://itunes.apple.com/cn/app/id1396367553?mt=8
    }
    
}


#pragma mark - scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _bottonView.frame = CGRectMake(0, HitoScreenH - 64 - 58 + scrollView.contentOffset.y, HitoScreenW, 58);
}

@end
