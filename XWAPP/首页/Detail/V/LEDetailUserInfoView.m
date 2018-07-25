//
//  LEDetailUserInfoView.m
//  XWAPP
//
//  Created by hys on 2018/7/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEDetailUserInfoView.h"
#import "LENewsListModel.h"

@interface LEDetailUserInfoView ()

@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIButton *avatarButton;

@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *fansLabel;

@property (strong, nonatomic) UIButton *attentionButton;

@end

@implementation LEDetailUserInfoView

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self addSubview:self.avatarButton];
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.avatarImageView);
    }];
    
    [self addSubview:self.attentionButton];
    [self.attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake(66, 29));
    }];
    
    [self addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(12);
        make.right.equalTo(self.attentionButton.mas_left).offset(-10);
        make.bottom.equalTo(self.avatarImageView.mas_centerY).offset(1);
    }];
    
    [self addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel);
        make.top.equalTo(self.avatarImageView.mas_centerY).offset(4);
    }];
    
    
    
    [self addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)updateViewWithData:(id)data{
    
    LENewsListModel *model = (LENewsListModel *)data;
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:model.userHeadImg] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@"LOGO"]];
    
    self.userNameLabel.text = model.souce;
    self.fansLabel.text = [NSString stringWithFormat:@"%@粉丝",[WYCommonUtils numberFormatWithNum:model.attentionCount]];
    self.attentionButton.selected = model.isAttention;
    self.attentionButton.backgroundColor = kAppThemeColor;
    if (self.attentionButton.selected) {
        self.attentionButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:75.0f/255.0f blue:65.0f/255.0f alpha:0.7f];
    }
}

#pragma mark -
#pragma mark - IBActions
- (void)attentionClickAction:(id)sender{
    if (self.attentionClickBlock) {
        self.attentionClickBlock();
    }
//    self.attentionButton.selected = !self.attentionButton.selected;
}

- (void)avatarClickAction:(id)sender{
    if (self.avatarClickBlock) {
        self.avatarClickBlock();
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UIButton *)avatarButton{
    if (!_avatarButton) {
        _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_avatarButton addTarget:self action:@selector(avatarClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}
- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = kAppTitleColor;
        _userNameLabel.font = HitoPFSCRegularOfSize(15);
    }
    return _userNameLabel;
}

- (UILabel *)fansLabel{
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _fansLabel.font = HitoPFSCRegularOfSize(12);
    }
    return _fansLabel;
}

- (UIButton *)attentionButton{
    if (!_attentionButton) {
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionButton setBackgroundColor:kAppThemeColor];
        [_attentionButton.titleLabel setFont:HitoPFSCRegularOfSize(14)];
        [_attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionButton addTarget:self action:@selector(attentionClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _attentionButton.layer.cornerRadius = 8;
        _attentionButton.layer.masksToBounds = YES;
    }
    return _attentionButton;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = HitoRGBA(228, 228, 228, 1.0);
    }
    return _lineImageView;
}

@end
