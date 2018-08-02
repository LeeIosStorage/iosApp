//
//  LESignInRulesView.m
//  XWAPP
//
//  Created by hys on 2018/7/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESignInRulesView.h"

@interface LESignInRulesView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) UIView *rulesView;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation LESignInRulesView

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    LELog(@"!!!!!");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    HitoWeakSelf;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [WeakSelf dismiss];
    }];
    [self addGestureRecognizer:tap];
    
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@"乐币奖励具体数量以活动页面为准"];
    [self.dataSource addObject:@"本签到7天为一个周期，后续连续签到从第1天重新计算，如此循环"];
    [self.dataSource addObject:@"若发现任何作弊行为，乐资讯有权取消用户已获得的奖励金币和物品"];
    
    CGSize size = CGSizeMake(342, 299);
    if (size.width > HitoScreenW) {
        CGFloat scale = size.width/375.0;
        size.width = size.width*scale;
        size.height = size.height*scale;
    }
    [self addSubview:self.rulesView];
    [self.rulesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(200);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(size);
    }];
    
    [self.rulesView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rulesView);
    }];
    
    [self.rulesView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(92, 45, 44, 45));
    }];
    
    [self.tableView reloadData];
    
}

- (void)show{
    UIWindow *keyWindow = HitoApplication;
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = kAppMaskOpaqueBlackColor;
    }];
}

- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark - Set And Getters
- (UIView *)rulesView{
    if (!_rulesView) {
        _rulesView = [[UIView alloc] init];
        
    }
    return _rulesView;
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"task_tankuang"];
    }
    return _bgImageView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 59;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDatasource
static int tip_label_tag = 201, ruleLabel_tag = 202;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LESignInRulesViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.tag = tip_label_tag;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor colorWithHexString:@"ffc300"];
        tipLabel.layer.masksToBounds = YES;
        tipLabel.layer.cornerRadius = 7.5;
        tipLabel.font = HitoPFSCRegularOfSize(13);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView).offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *ruleLabel = [[UILabel alloc] init];
        ruleLabel.tag = ruleLabel_tag;
        ruleLabel.textColor = [UIColor colorWithHexString:@"ffa200"];
        ruleLabel.numberOfLines = 0;
        ruleLabel.font = HitoPFSCRegularOfSize(15);
        [cell.contentView addSubview:ruleLabel];
        [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(12);
            make.top.equalTo(cell.contentView).offset(7);
            make.bottom.equalTo(cell.contentView).offset(-10);
            make.right.equalTo(cell.contentView);
        }];
        
    }
    
    UILabel *tipLabel = (UILabel *)[cell.contentView viewWithTag:tip_label_tag];
    UILabel *ruleLabel = (UILabel *)[cell.contentView viewWithTag:ruleLabel_tag];
    tipLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    ruleLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

@end
