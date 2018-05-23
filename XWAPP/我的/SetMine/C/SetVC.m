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

@interface SetVC ()

HitoPropertyNSArray(dataSource);
@property (nonatomic, strong) UIView *bottonView;

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyle];
    [self addBottonView];;
    

}

- (void)btnAction:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [LELoginUserManager clearUserInfo];
        [self.tabBarController setSelectedIndex:0];
    }];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)addBottonView {
    
    _bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, HitoScreenH - 58 - 64, HitoScreenW, 58)];
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
    [self.tableView addSubview:_bottonView];
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



- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@[@"完善资料", @"修改密码", @"清除缓存", @"给乐头条评分", @"隐私协议"], @[@"关于我们"]];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell" forIndexPath:indexPath];
    cell.leftLB.text = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        AboutUS *about = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutUS"];
        [self.navigationController pushViewController:about animated:YES];
    } else {
        if (indexPath.row == 0) {
            CompleteController *complete = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CompleteController"];
            [self.navigationController pushViewController:complete animated:YES];
        } else if (indexPath.row == 1) {
            //修改密码
        } else if (indexPath.row == 2) {
            //清除缓存
        } else if (indexPath.row == 3) {
            //去评分
        } else {
            //隐私协议
        }
    }
}


#pragma mark - scrollerDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _bottonView.frame = CGRectMake(0, HitoScreenH - 64 - 58 + scrollView.contentOffset.y, HitoScreenW, 58);
}

@end
