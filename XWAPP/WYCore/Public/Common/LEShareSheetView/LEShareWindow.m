//
//  LEShareWindow.m
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEShareWindow.h"

@interface LEShareWindow ()

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) UIView *containersView;

@property (strong, nonatomic) UILabel *shareTipLabel;

@property (strong, nonatomic) UIScrollView *shareScrollView;

@property (strong, nonatomic) UIImageView *lineImageView;

@property (strong, nonatomic) UIScrollView *handleScrollView;

@property (strong, nonatomic) UIView *cancelView;

@end

@implementation LEShareWindow

#pragma mark -
#pragma mark - Lifecycle

- (void)dealloc
{
//    LELog(@"%s",__func__);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
//    self.frame = [UIScreen mainScreen].bounds;
    
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClickAction:)];
    [self.maskView addGestureRecognizer:tap];
    
    [self addSubview:self.containersView];
    self.containersView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 164);
//    [self.containersView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom).offset(164);
//        make.height.mas_equalTo(164);
//    }];
    
    
    [self.containersView addSubview:self.shareTipLabel];
    [self.shareTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containersView);
        make.height.mas_equalTo(16);
    }];
    
    [self.containersView addSubview:self.shareScrollView];
    [self.shareScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containersView);
        make.top.equalTo(self.shareTipLabel.mas_bottom);
        make.height.mas_equalTo(88);
    }];
    
    [self.containersView addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containersView).offset(20);
        make.right.equalTo(self.containersView).offset(-20);
        make.top.equalTo(self.shareScrollView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.containersView addSubview:self.handleScrollView];
    [self.handleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containersView);
        make.top.equalTo(self.lineImageView.mas_bottom).offset(14);
        make.height.mas_equalTo(88);
    }];
    
    
    [self.containersView addSubview:self.cancelView];
    [self.cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containersView);
        make.top.equalTo(self.handleScrollView.mas_bottom);
//        make.height.mas_equalTo(45);
        make.bottom.equalTo(self.containersView);
    }];
    
}

- (void)addItemSize:(CGSize)itemSize left:(float)left tag:(int)tag params:(NSDictionary *)params scrollView:(UIScrollView *)scrollView{
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setImage:[UIImage imageNamed:params[Share_Item_Icon]] forState:UIControlStateNormal];
    itemButton.tag = tag;
    [scrollView addSubview:itemButton];
    [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(left);
        make.top.equalTo(scrollView);
        make.size.mas_equalTo(itemSize);
    }];
    
    UILabel *itemLabel = [[UILabel alloc] init];
    itemLabel.text = params[Share_Item_Name];
    itemLabel.textColor = kAppTitleColor;
    itemLabel.font = HitoPFSCRegularOfSize(12);
    itemLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(itemButton);
        make.top.equalTo(itemButton.mas_bottom).offset(6);
    }];
    
    if (scrollView == self.shareScrollView) {
        [itemButton addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
    }else if (scrollView == self.handleScrollView){
        [itemButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

#pragma mark -
#pragma mark - Public
- (void)setCustomerSheet{
    
    //分享
    if (_shareItemArray.count == 0 || !_shareItemArray) {
        _shareItemArray = [NSMutableArray array];
        [_shareItemArray addObject:@{Share_Item_Name: @"朋友圈", Share_Item_Icon:@"le_news_share_pengyouquan", Share_Item_Action:@"shareToWXTimeline"}];
        [_shareItemArray addObject:@{Share_Item_Name: @"微信好友", Share_Item_Icon:@"le_news_share_weixin", Share_Item_Action:@"shareToWXSession"}];
        [_shareItemArray addObject:@{Share_Item_Name: @"QQ好友", Share_Item_Icon:@"le_news_share_qq", Share_Item_Action:@"shareToQQ"}];
        [_shareItemArray addObject:@{Share_Item_Name: @"微博", Share_Item_Icon:@"le_news_share_weibo", Share_Item_Action:@"shareToWeibo"}];
        [_shareItemArray addObject:@{Share_Item_Name: @"复制链接", Share_Item_Icon:@"le_news_fuzhilianjie", Share_Item_Action:@"copylink"}];
    }
    
    CGSize itemSize = CGSizeMake(50, 50);
    float space = (HitoScreenW-23*2-44*_shareItemArray.count)/(_shareItemArray.count-1);
    if (_shareItemArray.count < 4) {
        space = 50;
    }
    space = 20;
    float left = 23;
    int tag = 0;
    for (NSDictionary *dic in _shareItemArray) {
        [self addItemSize:itemSize left:left tag:tag params:dic scrollView:self.shareScrollView];
        left += (itemSize.width+space);
        tag ++;
    }
    left += (23-space);
    if (left <= HitoScreenW) {
        left = HitoScreenW+1;
    }
    [self.shareScrollView setContentSize:CGSizeMake(left, 74)];
    
    //操作
    if (_handleItemArray.count == 0 || !_handleItemArray) {
        _handleItemArray = [NSMutableArray array];
//        [_handleItemArray addObject:@{Share_Item_Name: @"收藏", Share_Item_Icon:@"le_news_shoucang", Share_Item_Action:@"collectAction"}];
        [_handleItemArray addObject:@{Share_Item_Name: @"举报", Share_Item_Icon:@"le_news_jubao", Share_Item_Action:@"reportAction"}];
    }
    left = 23;
    tag = 0;
    for (NSDictionary *dic in _handleItemArray) {
        [self addItemSize:itemSize left:left tag:tag params:dic scrollView:self.handleScrollView];
        left += (itemSize.width+space);
        tag ++;
    }
    left += (23-space);
    if (left <= HitoScreenW) {
        left = HitoScreenW+1;
    }
    [self.handleScrollView setContentSize:CGSizeMake(left, 74)];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.backgroundColor = kAppMaskOpaqueBlackColor;
        self.containersView.frame = CGRectMake(0, HitoScreenH-236-14, HitoScreenW, 236+14);
    }];
    
    UIWindow *keyWindow = HitoApplication;
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}

#pragma mark -
#pragma mark - IBActions
- (void)itemAction:(id)sender{
    
    [self cancelClickAction:nil];
    UIButton *button = (UIButton *)sender;
    NSDictionary *dic = _shareItemArray[button.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWindowClickAt:action:)]) {
        [self.delegate shareWindowClickAt:indexPath action:dic[Share_Item_Action]];
    }
}

- (void)handleAction:(id)sender{
    
    [self cancelClickAction:nil];
    UIButton *button = (UIButton *)sender;
    NSDictionary *dic = _handleItemArray[button.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:1];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareWindowClickAt:action:)]) {
        [self.delegate shareWindowClickAt:indexPath action:dic[Share_Item_Action]];
    }
}

- (void)cancelClickAction:(id)sender{
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark - Set And Getters
- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = HitoRGBA(0, 0, 0, 0);
    }
    return _maskView;
}

- (UIView *)containersView{
    if (!_containersView) {
        _containersView = [[UIView alloc] init];
        _containersView.backgroundColor = [UIColor whiteColor];
    }
    return _containersView;
}

- (UILabel *)shareTipLabel{
    if (!_shareTipLabel) {
        _shareTipLabel = [[UILabel alloc] init];
        _shareTipLabel.textColor = kAppTitleColor;
        _shareTipLabel.font = HitoPFSCRegularOfSize(14);
//        _shareTipLabel.text = @"选择分享平台";
        _shareTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shareTipLabel;
}

- (UIScrollView *)shareScrollView{
    if (!_shareScrollView) {
        _shareScrollView = [[UIScrollView alloc] init];
        _shareScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _shareScrollView;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = LineColor;
    }
    return _lineImageView;
}

- (UIScrollView *)handleScrollView{
    if (!_handleScrollView) {
        _handleScrollView = [[UIScrollView alloc] init];
        _handleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _handleScrollView;
}

- (UIView *)cancelView{
    if (!_cancelView) {
        _cancelView = [[UIView alloc] init];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = LineColor;
        [_cancelView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_cancelView).offset(20);
            make.right.equalTo(self->_cancelView).offset(-20);
            make.top.equalTo(self->_cancelView);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:kAppTitleColor forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:HitoPFSCRegularOfSize(15)];
        [cancelButton addTarget:self action:@selector(cancelClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_cancelView);
            make.size.mas_equalTo(CGSizeMake(100, 44));
        }];
    }
    return _cancelView;
}

@end
