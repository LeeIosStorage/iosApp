//
//  CommontHeaderView.m
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "CommontHeaderView.h"
#import "LENewsCommentModel.h"

@interface CommontHeaderView ()

@property (strong, nonatomic) UIImageView *headImageView;

@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UILabel *areaLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *favourLabel;
@property (strong, nonatomic) UIButton *favourButton;

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation CommontHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setupSubviews{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(12);
        make.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-20);
        
    }];
    
    [self addSubview:self.areaLabel];
    [self.areaLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];//不想变大
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nickNameLabel);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(7);
    }];
    
    [self addSubview:self.favourImageView];
    [self.favourImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.top.equalTo(self).offset(28);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    [self addSubview:self.favourLabel];
    [self.favourLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];//不想变小
    [self.favourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.favourImageView).offset(1);
        make.right.equalTo(self.favourImageView.mas_left).offset(-12);
    }];
    
    [self addSubview:self.favourButton];
    [self.favourButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.favourLabel);
        make.right.centerY.equalTo(self.favourImageView);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.areaLabel.mas_right).offset(16);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(7);
        make.right.equalTo(self.favourLabel.mas_left).offset(-5);
    }];
    
    
    [self addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(70);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(66);
        make.bottom.equalTo(self).offset(-10);
    }];
    
}

#pragma mark -
#pragma mark - IBActions
- (void)favourClickAction:(id)sender{
//    self.favourImageView.highlighted = !self.favourImageView.highlighted;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentHeaderWithFavourClick:headerView:)]) {
        [self.delegate commentHeaderWithFavourClick:self.section headerView:self];
    }
}

#pragma mark -
#pragma mark - Public
- (void)updateHeaderData:(id)data{
    
    LENewsCommentModel *commentModel = (LENewsCommentModel *)data;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:commentModel.avatarUrl] setImage:self.headImageView setbitmapImage:nil];
    self.nickNameLabel.text = commentModel.userName;
    self.areaLabel.text = commentModel.area;
    self.dateLabel.text = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:commentModel.date]];
    self.favourLabel.text = [NSString stringWithFormat:@"%d",commentModel.favourNum];
    self.favourImageView.highlighted = commentModel.favour;
    self.contentLabel.text = commentModel.content;
}

#pragma mark -
#pragma mark - Set And Getters
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = 22;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nickNameLabel{
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textColor = [UIColor colorWithHexString:@"3477c0"];
        _nickNameLabel.font = HitoPFSCRegularOfSize(14);
    }
    return _nickNameLabel;
}

- (UILabel *)areaLabel{
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc] init];
        _areaLabel.textColor = kAppSubTitleColor;
        _areaLabel.font = HitoPFSCRegularOfSize(12);
    }
    return _areaLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = kAppSubTitleColor;
        _dateLabel.font = HitoPFSCRegularOfSize(12);
    }
    return _dateLabel;
}

- (UILabel *)favourLabel{
    if (!_favourLabel) {
        _favourLabel = [[UILabel alloc] init];
        _favourLabel.textColor = [UIColor colorWithHexString:@"767676"];
        _favourLabel.font = HitoPFSCRegularOfSize(15);
    }
    return _favourLabel;
}

- (UIImageView *)favourImageView{
    if (!_favourImageView) {
        _favourImageView = [[UIImageView alloc] init];
        _favourImageView.image = [UIImage imageNamed:@"home_dianzan_nor"];
        _favourImageView.highlightedImage = [UIImage imageNamed:@"home_dianzan_pre"];
        _favourImageView.tag = 100;
    }
    return _favourImageView;
}

- (UIButton *)favourButton{
    if (!_favourButton) {
        _favourButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_favourButton addTarget:self action:@selector(favourClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favourButton;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = kAppTitleColor;
        _contentLabel.font = HitoPFSCRegularOfSize(16);
    }
    return _contentLabel;
}

@end
