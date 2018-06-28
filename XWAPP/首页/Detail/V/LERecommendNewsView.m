//
//  LERecommendNewsView.m
//  XWAPP
//
//  Created by hys on 2018/6/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LERecommendNewsView.h"
#import "LENewsListModel.h"

@interface LERecommendNewsView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation LERecommendNewsView

#pragma mark -
#pragma mark - Lifecycle
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
    self.backgroundColor = kAppBackgroundColor;
    self.recommendNewsArray = [NSMutableArray array];

    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)refreshUI{
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Set And Getters
- (void)setRecommendNewsArray:(NSMutableArray *)recommendNewsArray{
    _recommendNewsArray = [NSMutableArray arrayWithArray:recommendNewsArray];
    [self refreshUI];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = 70;
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDatasource
static int titleLabel_tag = 201, imageView_tag = 202;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RecommendNewsViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = kAppBackgroundColor;
        UILabel *label = [[UILabel alloc] init];
        label.tag = titleLabel_tag;
        label.textColor = kAppTitleColor;
        label.font = HitoPFSCRegularOfSize(18);
        label.numberOfLines = 2;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(12);
            make.right.equalTo(cell.contentView).offset(-12);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        lineImageView.tag = imageView_tag;
        [cell.contentView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(12);
            make.right.equalTo(cell.contentView).offset(-12);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:titleLabel_tag];
    UIImageView *lineImageView = (UIImageView *)[cell.contentView viewWithTag:imageView_tag];
    
    LENewsListModel *model = self.recommendNewsArray[indexPath.row];
    label.text = model.title;
    
    lineImageView.hidden = NO;
    if (indexPath.row == self.recommendNewsArray.count-1) {
        lineImageView.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectRowAtIndex) {
        self.didSelectRowAtIndex(indexPath.row);
    }
}

@end
