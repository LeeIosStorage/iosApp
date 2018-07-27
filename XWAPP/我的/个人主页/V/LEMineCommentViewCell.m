//
//  LEMineCommentViewCell.m
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEMineCommentViewCell.h"
#import "LENewsCommentModel.h"

@interface LEMineCommentViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;

@end

@implementation LEMineCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headImageView.layer.cornerRadius = 17;
    _headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)newsDetailClickAction:(id)sender{
    if (self.clickNewsDetailBlock) {
        self.clickNewsDetailBlock();
    }
}

#pragma mark -
#pragma mark - Public
- (void)updateViewCellData:(id)data{
    
    LENewsCommentModel *commentModel = (LENewsCommentModel *)data;
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:commentModel.avatarUrl] setImage:self.headImageView setbitmapImage:[UIImage imageNamed:@"LOGO"]];
    NSString *userName = commentModel.userName;

    self.nickNameLabel.text = userName;
    NSString *areaAndDateString = @"";
    NSString *dateString = [WYCommonUtils dateYearToSecondDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:commentModel.date]];
    if (dateString.length > 0) {
        areaAndDateString = [NSString stringWithFormat:@"%@%@",areaAndDateString,dateString];
    }
    self.dateLabel.text = areaAndDateString;
    self.contentLabel.text = commentModel.content;
    
    NSString *newsUrl = nil;
    if (commentModel.cover.count > 0) {
        newsUrl = commentModel.cover[0];
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:newsUrl] setImage:self.newsImageView setbitmapImage:nil];
    self.newsTitleLabel.text = commentModel.newsTitle;
}

@end
