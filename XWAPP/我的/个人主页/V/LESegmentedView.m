//
//  LESegmentedView.m
//  XWAPP
//
//  Created by hys on 2018/6/5.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESegmentedView.h"
#import "LERedpointView.h"
#import "HotUpButton.h"

#define SegmentedItemOffTag 100
#define SegmentedCountButtonOffTag 200
#define SegmentedCountLabelOffTag 300

@interface LESegmentedView ()

@property (strong, nonatomic) UIImageView *moveImageView;

@property (assign, nonatomic) CGFloat itemWidth;

@end

@implementation LESegmentedView

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
    self.backgroundColor = [UIColor whiteColor];
}

- (void)updateRedCountWith:(int)count index:(NSInteger)index{
    UIView *itemView = [self viewWithTag:SegmentedItemOffTag + index];
    LERedpointView *redpointView = (LERedpointView *)[itemView viewWithTag:SegmentedCountLabelOffTag];
    [redpointView setText:count];
}

- (void)setSegmentedWithArray:(NSArray *)array{
    
    [self removeAllSubviews];
    
    int count = (int)array.count;
    CGFloat width = HitoScreenW/count;
    _itemWidth = width;
    for (int i = 0; i < count; i++) {
        NSDictionary *dic = array[i];
        [self addItemWithIndex:i width:width dic:dic];
    }
    
    [self addSubview:self.moveImageView];
    [self.moveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, 3));
        make.bottom.equalTo(self);
    }];
    
    UIView *itemView = [self viewWithTag:SegmentedItemOffTag + 0];
    HotUpButton *button = (HotUpButton *)[itemView viewWithTag:SegmentedCountButtonOffTag];
    [self selectItemAction:button];
    
}

- (void)addItemWithIndex:(int)index width:(CGFloat)width dic:(NSDictionary *)dic{
    
    UIView *itemView = [[UIView alloc] init];
    itemView.tag = SegmentedItemOffTag + index;
    [self addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(width);
        make.left.equalTo(self).offset(width*index);
    }];
    
    NSString *title = dic[LESegmentedTitle];
    NSString *imageName = dic[LESegmentedImage];
    NSString *hImageName = dic[LESegmentedHImage];
    if (hImageName.length == 0) {
        hImageName = imageName;
    }
    if (imageName.length > 0) {
        title = [NSString stringWithFormat:@" %@",title];
    }
    HotUpButton *button = [HotUpButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"111111"] forState:UIControlStateNormal];
    [button setTitleColor:kAppThemeColor forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hImageName] forState:UIControlStateSelected];
    [button.titleLabel setFont:HitoPFSCRegularOfSize(15)];
    [button addTarget:self action:@selector(selectItemAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = SegmentedCountButtonOffTag;
    [itemView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(itemView);
    }];
    
    LERedpointView *redpointView = [[LERedpointView alloc] init];
    redpointView.tag = SegmentedCountLabelOffTag;
    [redpointView setText:0];
    [itemView addSubview:redpointView];
    [redpointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).offset(2);
        make.centerY.equalTo(button.mas_top).offset(3);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
}

- (void)selectItemAction:(UIButton *)sender{
    
    if (sender.selected) {
        return;
    }
    int index = (int)sender.superview.tag;
    for (UIView *view in self.subviews) {
        for (id object in view.subviews) {
            if ([object isKindOfClass:[HotUpButton class]]) {
                HotUpButton *button = (HotUpButton *)object;
                button.selected = NO;
                if (view.tag == index) {
                    button.selected = YES;
                    [self.moveImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self).offset((index-SegmentedItemOffTag)*self->_itemWidth);
                    }];
                }
            }
        }
    }
    
    if (self.segmentedSelectItem) {
        self.segmentedSelectItem(index-SegmentedItemOffTag);
    }
    
}

#pragma mark -
#pragma mark - Set And Getters
- (UIImageView *)moveImageView{
    if (!_moveImageView) {
        _moveImageView = [[UIImageView alloc] init];
        _moveImageView.backgroundColor = [UIColor colorWithHexString:@"ff6113"];
    }
    return _moveImageView;
}

@end
