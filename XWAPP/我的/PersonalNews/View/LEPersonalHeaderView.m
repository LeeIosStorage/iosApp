//
//  LEPersonalHeaderView.m
//  XWAPP
//
//  Created by hys on 2018/7/20.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEPersonalHeaderView.h"
#import "LEUserInfoModel.h"

@interface LEPersonalHeaderView ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIButton *attentionButton;

@property (strong, nonatomic) UIView *infoView;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UIButton *fansNumButton;
@property (strong, nonatomic) UIButton *readNumButton;
@property (strong, nonatomic) UIButton *newsNumButton;

@end

@implementation LEPersonalHeaderView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    self.backgroundColor = HitoRGBA(48, 48, 48, 1.0);
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-44);
        make.height.mas_equalTo(134);
    }];
    
    [self addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.contentView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.attentionButton.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
    [self.contentView addSubview:self.introLabel];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.infoView.mas_bottom);
        make.bottom.equalTo(self.contentView).offset(-6);
    }];
}

#pragma mark -
#pragma mark - Public
- (void)updateViewWithData:(id)data{
    
    LEUserInfoModel *userInfo = (LEUserInfoModel *)data;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:userInfo.userHeadImg] setImage:self.avatarImageView setbitmapImage:[UIImage imageNamed:@"LOGO"]];
    NSString *intro = userInfo.introduction;
    if (intro.length == 0) {
        intro = @"这人比较懒,还没留下个人简介~";
    }
    self.introLabel.text = intro;
    
    [self.fansNumButton setTitle:[NSString stringWithFormat:@"粉丝%@",[WYCommonUtils numberFormatWithNum:userInfo.attentionCount]] forState:UIControlStateNormal];
    [self.readNumButton setTitle:[NSString stringWithFormat:@"阅读%@",[WYCommonUtils numberFormatWithNum:userInfo.readCount]] forState:UIControlStateNormal];
    [self.newsNumButton setTitle:[NSString stringWithFormat:@"发表%@篇",[WYCommonUtils numberFormatWithNum:userInfo.newsCount]] forState:UIControlStateNormal];
    
    self.attentionButton.hidden = NO;
    if ([[userInfo.userId description] isEqualToString:[LELoginUserManager userID]]) {
        self.attentionButton.hidden = YES;
    }
}

#pragma mark -
#pragma mark - IBActions
- (void)attentionClickAction:(id)sender{
    if (self.attentionClickBlock) {
        self.attentionClickBlock();
    }
    self.attentionButton.selected = !self.attentionButton.selected;
    self.attentionButton.backgroundColor = kAppThemeColor;
    if (self.attentionButton.selected) {
        self.attentionButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:75.0f/255.0f blue:65.0f/255.0f alpha:0.7f];
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = HitoRGBA(228, 228, 228, 1.0);
        [_contentView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_contentView);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [attentionButton setBackgroundColor:kAppThemeColor];
        [attentionButton.titleLabel setFont:HitoPFSCRegularOfSize(14)];
        [attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [attentionButton setTitle:@"已关注" forState:UIControlStateSelected];
        [attentionButton addTarget:self action:@selector(attentionClickAction:) forControlEvents:UIControlEventTouchUpInside];
        attentionButton.layer.cornerRadius = 8;
        attentionButton.layer.masksToBounds = YES;
        _attentionButton = attentionButton;
        [_contentView addSubview:attentionButton];
        [attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_contentView).offset(11);
            make.right.equalTo(self->_contentView).offset(-12);
            make.size.mas_equalTo(CGSizeMake(66, 29));
        }];
        
    }
    return _contentView;
}

- (UIImageView *)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 35;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.borderWidth = 3;
        _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _avatarImageView;
}

- (UIView *)infoView{
    if (!_infoView) {
        _infoView = [[UIView alloc] init];
        
        CGFloat width = HitoScreenW/3;
        for (int i = 0; i < 3; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor colorWithHexString:@"0c0c0c"] forState:UIControlStateNormal];
            button.titleLabel.font = HitoPFSCRegularOfSize(16);
            [_infoView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self->_infoView);
                make.width.mas_equalTo(width);
                make.left.equalTo(self->_infoView).offset(width*i);
            }];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor colorWithHexString:@"1b1b1b"];
            [_infoView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(button);
                make.centerY.equalTo(button.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(0.5, 15));
            }];
            
            if (i == 0) {
                _fansNumButton = button;
                [_fansNumButton setTitle:@"粉丝0" forState:UIControlStateNormal];
            }else if (i == 1){
                _readNumButton = button;
                [_fansNumButton setTitle:@"阅读0" forState:UIControlStateNormal];
            }else if (i == 2){
                _newsNumButton = button;
                [_fansNumButton setTitle:@"发表0篇" forState:UIControlStateNormal];
                imageView.hidden = YES;
            }
        }
    }
    return _infoView;
}

- (UILabel *)introLabel{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _introLabel.font = HitoPFSCRegularOfSize(14);
    }
    return _introLabel;
}

@end
