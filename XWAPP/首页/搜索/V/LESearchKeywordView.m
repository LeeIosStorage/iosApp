//
//  LESearchKeywordView.m
//  XWAPP
//
//  Created by hys on 2018/6/28.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESearchKeywordView.h"

@interface LESearchKeywordView ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) NSMutableArray *keywordArray;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation LESearchKeywordView

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
    self.keywordArray = [NSMutableArray array];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)updateViewWithData:(NSArray *)array{
    self.keywordArray = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - Set And Getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 40;
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDatasource
static int titleLabel_tag = 201;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keywordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"keywordCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kAppTitleColor;
        label.font = HitoPFSCRegularOfSize(16);
        label.tag = titleLabel_tag;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(12);
            make.centerY.equalTo(cell.contentView);
        }];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(0);
            make.right.equalTo(cell.contentView).offset(0);
            make.bottom.equalTo(cell.contentView);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:titleLabel_tag];
    NSDictionary *dic = [self.keywordArray objectAtIndex:indexPath.row];
    
    NSString *word = dic[@"word"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:word];
    NSRange range = [word rangeOfString:self.searchText];
    if (range.length > 0) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:kAppThemeColor range:range];
    }
    
    label.attributedText = attributedString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchKeywordBlcok) {
        NSDictionary *dic = [self.keywordArray objectAtIndex:indexPath.row];
        NSString *word = dic[@"word"];
        self.searchKeywordBlcok(word);
    }
}

@end
