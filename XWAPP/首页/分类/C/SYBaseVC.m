//
//  SYBaseVC.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SYBaseVC.h"
#import "BaseOneCell.h"
#import "BaseTwoCell.h"
#import "BaseThirdCell.h"
#import "RefrestInfoView.h"
#import "DelAlertView.h"

#import "DetailController.h"
#import "SYDetailController.h"

@interface SYBaseVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SYBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTB];
    [self addMJ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setTB {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseOneCell" bundle:nil] forCellReuseIdentifier:@"BaseOneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseTwoCell" bundle:nil] forCellReuseIdentifier:@"BaseTwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BaseThirdCell" bundle:nil] forCellReuseIdentifier:@"BaseThirdCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [UIView new];
}


#pragma mark - TBDelegate&Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MJWeakSelf;
    if (indexPath.row < 3) {
        BaseOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseOneCell"];
        
        [cell.statusView deleblockAction:^{
            [weakSelf deleNew:indexPath curCell:cell];
        }];
        
        
        return cell;
    } else if (indexPath.row < 7) {
        BaseTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseTwoCell"];
        [cell.statusView deleblockAction:^{
            [weakSelf deleNew:indexPath curCell:cell];
        }];
        
        return cell;
    } else {
        BaseThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseThirdCell"];
        [cell.statusView deleblockAction:^{
            [weakSelf deleNew:indexPath curCell:cell];
        }];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - 删除按钮
- (void)deleNew:(NSIndexPath *)indexPath curCell:(UITableViewCell *)cell {
    _indexPath = indexPath;
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:indexPath];
    CGRect rect = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    CGRect rect1 = [self.tableView convertRect:rectInTableView toView:[UIApplication sharedApplication].delegate.window];
    //判断cell是否全部显示
    if (rect.origin.y < 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + rect.origin.y) animated:YES];

        
    } else if ((NSInteger)(rect.origin.y + rect.size.height + 160) > (NSInteger)(self.tableView.frame.size.height)) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + rect.origin.y + rect.size.height + 160 - self.tableView.frame.size.height) animated:YES];
    } else {
        [self addTempView:rect1];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:_indexPath];
    CGRect rect1 = [self.tableView convertRect:rectInTableView toView:[UIApplication sharedApplication].delegate.window];
    [self addTempView:rect1];
}

- (void)addTempView:(CGRect)rect {
    //添加蒙层
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    v.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    DelAlertView *delView = [[[NSBundle mainBundle] loadNibNamed:@"DelAlertView" owner:self options:nil] firstObject];
    delView.count = 0;
    delView.frame = CGRectMake(rect.origin.x, rect.origin.y, HitoScreenW, 160);

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
    cell.frame = rect;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [v addGestureRecognizer:tap];
    [UIView animateWithDuration:0.2 animations:^{
        NSLog(@"%f", rect.origin.y);
        delView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, HitoScreenW, 160);
    }];
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:v];
    [v addSubview:delView];
    [v addSubview:cell];
    
}

- (void)removeView:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
        [self.tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - mj
- (void)addMJ {
    //下拉刷新
    
    MJWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            RefrestInfoView *refrest = [[[NSBundle mainBundle] loadNibNamed:@"RefrestInfoView" owner:self options:nil] firstObject];
            refrest.titleLB.text = [NSString stringWithFormat:@"丨乐%@丨已为你更新 %d条信息", weakSelf.tagTitle, 10];
            self.tableView.tableHeaderView = refrest;
            
            
        });
        
        dispatch_time_t delayTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime1, dispatch_get_main_queue(), ^{
            
            self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
            
            
        });
        
    }];
    //上啦加载
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        //
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
