//
//  StatusView.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "StatusView.h"
#import "UIView+Xib.h"

@interface StatusView ()


@end

@implementation StatusView

#if 1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self setupSelfNameXibOnSelf];
    
    self.tagLabel.layer.masksToBounds = YES;
    self.sourceLabel.layer.masksToBounds = YES;
    
    [self.sourceLabel removeFromSuperview];
    [self addSubview:self.sourceLabel];
    [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(15);
        make.centerY.equalTo(self.tagLabel.mas_centerY);
    }];
}

#endif

#if 0
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //加载同名xib并添加到self
        [self setupSelfNameXibOnSelf];
    }
    return self;
}
#endif

- (IBAction)deleAction:(UIButton *)sender {
    if (_deleeBlock) {
        _deleeBlock();
    }
}

- (void)deleblockAction:(DeleBlock)deleblock {
    _deleeBlock = deleblock;
}

- (IBAction)cancelAction:(UIButton *)sender {
    if (_deleeBlock) {
        _deleeBlock();
    }
}

- (void)updateSourceConstraints:(NSInteger)type{
    if (type == 0) {
        [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel.mas_right).offset(15);
            make.centerY.equalTo(self.tagLabel.mas_centerY);
        }];
    }else{
        [self.sourceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tagLabel.mas_left);
            make.centerY.equalTo(self.tagLabel.mas_centerY);
        }];
    }
}

- (void)updateCellWithData:(LENewsListModel *)newsModel{
    
    self.sourceLabel.hidden = NO;
    self.deleButton.hidden = NO;
    UIColor *tagColor = [UIColor colorWithHexString:@"f11b1b"];
    NSString *tagString = @"";
    if (newsModel.isHot) {
        tagString = @" 热门 ";
    }
    if (newsModel.isTop){
        tagString = @" 置顶 ";
    }
    if (newsModel.is_ad) {
        tagString = @" 广告 ";
        tagColor = [UIColor colorWithHexString:@"999999"];
        self.sourceLabel.hidden = YES;
        self.deleButton.hidden = YES;
    }
    self.tagLabel.textColor = tagColor;
    self.tagLabel.layer.cornerRadius = 3;
    self.tagLabel.layer.borderWidth = 0.5;
    self.tagLabel.layer.borderColor = tagColor.CGColor;
    self.tagLabel.text = tagString;
    
    [self updateSourceConstraints:(tagString.length == 0) ?1: 0];
    
    NSMutableString *statusString = [NSMutableString string];
//    if (newsModel.souce.length > 0) {
//        [statusString appendFormat:@"%@    ",newsModel.souce];
//    }
    int commentCount = newsModel.commentCount;
    if (commentCount > 0) {
        [statusString appendFormat:@"%d评    ",commentCount];
    }
    NSString *dateString = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:newsModel.public_time]];
    if (dateString.length > 0) {
        [statusString appendFormat:@"%@",dateString];
    }
    
    //test
//    [statusString appendFormat:@"  %@",newsModel.newsId];
    
    self.sourceLabel.text = statusString;
    
}

@end
