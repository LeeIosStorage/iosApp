//
//  BaseTwoCell.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "BaseTwoCell.h"

@interface BaseTwoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation BaseTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(LENewsListModel *)newsModel{
    
    self.titleLabel.text = newsModel.title;
    NSString *imageUrl = nil;
    if (newsModel.cover.count > 0) {
        imageUrl = [newsModel.cover objectAtIndex:0];
    }
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:imageUrl] setImage:self.coverImageView setbitmapImage:nil];
    
    UIColor *tagColor = [UIColor colorWithHexString:@"f11b1b"];
    NSString *tagString = @"";
    if (newsModel.is_hot) {
        tagString = @" 热门 ";
    }else if (newsModel.is_top){
        tagString = @" 置顶 ";
    }
    self.statusView.tagLabel.textColor = tagColor;
    self.statusView.tagLabel.layer.cornerRadius = 3;
    self.statusView.tagLabel.layer.borderWidth = 0.5;
    self.statusView.tagLabel.layer.borderColor = tagColor.CGColor;
    self.statusView.tagLabel.text = tagString;
    
    [self.statusView updateSourceConstraints:(tagString.length == 0) ?1: 0];
    
    NSMutableString *statusString = [NSMutableString string];
    if (newsModel.souce.length > 0) {
        [statusString appendFormat:@"%@",newsModel.souce];
    }
    int commentCount = newsModel.commentCount;
    if (commentCount > 0) {
        [statusString appendFormat:@"    %d评",commentCount];
    }
    NSString *dateString = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:newsModel.public_time]];
    if (dateString.length > 0) {
        [statusString appendFormat:@"    %@",dateString];
    }
    self.statusView.sourceLabel.text = statusString;
    
    if (newsModel.cover.count == 0) {
        [self.coverImageView removeFromSuperview];
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.statusView.mas_top).offset(-8);
            make.height.mas_equalTo(0).priorityHigh;
        }];
    }else{
//        self.coverImageView.backgroundColor = kAppThemeColor;
        [self.coverImageView removeFromSuperview];
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(13);
            make.right.equalTo(self.contentView).offset(-13);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.statusView.mas_top).offset(-8);
            make.height.equalTo(self.coverImageView.mas_width).multipliedBy(0.5).priorityHigh;
        }];
    }
    
}

@end
