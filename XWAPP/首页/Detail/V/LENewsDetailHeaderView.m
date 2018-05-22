//
//  LENewsDetailHeaderView.m
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENewsDetailHeaderView.h"
#import "LENewsListModel.h"

@interface LENewsDetailHeaderView ()

@property (strong, nonatomic) YYLabel *titleLabel;
@property (strong, nonatomic) YYLabel *dateLabel;
@property (strong, nonatomic) YYLabel *sourceLabel;

@end

@implementation LENewsDetailHeaderView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    if (self == [super init]) {
        [self setupSubViews];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(21);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
}


#pragma mark -
#pragma mark - Public
- (CGFloat)updateWithData:(id)data{
    CGFloat height = 0;
    
    LENewsListModel *model = (LENewsListModel *)data;
    
    NSMutableAttributedString *attString = nil;
    if (model.title.length  > 0) {
        attString = [[NSMutableAttributedString alloc] initWithString:model.title];
    }
    NSRange range = NSMakeRange(0, attString.length);
    UIFont *font = HitoBoldSystemFontOfSize(25.0f);
    attString.font = font;
    attString.color = kAppTitleColor;
    attString.alignment = NSTextAlignmentLeft;
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];;
    paragraphStyle.lineSpacing = 6.f;
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
//    self.titleLabel.attributedText = attString;
    self.dateLabel.text = [WYCommonUtils dateDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:model.public_time]];
    self.sourceLabel.text = model.souce;
    
    //算高度不太准确
//    CGSize textSize = [attString boundingRectWithSize:CGSizeMake(HitoScreenW-12*2, HUGE) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//    [self.titleLabel sizeToFit];
//    CGFloat tmpH = [self.titleLabel sizeThatFits:CGSizeMake(HitoScreenW-12*2, MAXFLOAT)].height;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(HitoScreenW-12*2, HUGE)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attString];
    CGFloat contentHeight = textLayout.textBoundingSize.height;
    self.titleLabel.displaysAsynchronously = YES;
    self.titleLabel.ignoreCommonProperties = YES;
    self.titleLabel.textLayout = textLayout;
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.height.mas_equalTo(contentHeight);
    }];
    
    height += 12;
    height += contentHeight;
    height += 12;
    height += 14;
    
    self.height = height;
    
    return height;
}

#pragma mark -
#pragma mark - Set And Getters
- (YYLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[YYLabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (YYLabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[YYLabel alloc] init];
        _dateLabel.textColor = kAppSubTitleColor;
        _dateLabel.font = HitoPFSCRegularOfSize(12.0f);
    }
    return _dateLabel;
}

- (YYLabel *)sourceLabel{
    if (!_sourceLabel) {
        _sourceLabel = [[YYLabel alloc] init];
        _sourceLabel.textColor = kAppSubTitleColor;
        _sourceLabel.font = HitoPFSCRegularOfSize(12.0f);
    }
    return _sourceLabel;
}

@end
