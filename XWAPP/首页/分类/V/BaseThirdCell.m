//
//  BaseThirdCell.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "BaseThirdCell.h"

@interface BaseThirdCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView2;

@end

@implementation BaseThirdCell

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
    NSString *imageUrl1 = nil;
    NSString *imageUrl2 = nil;
    if (newsModel.cover.count > 0) {
        imageUrl = [newsModel.cover objectAtIndex:0];
    }
    if (newsModel.cover.count > 1){
        imageUrl1 = [newsModel.cover objectAtIndex:1];
    }
    if (newsModel.cover.count > 2){
        imageUrl2 = [newsModel.cover objectAtIndex:2];
    }
    
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:imageUrl] setImage:self.coverImageView setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:imageUrl1] setImage:self.coverImageView1 setbitmapImage:nil];
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:imageUrl2] setImage:self.coverImageView2 setbitmapImage:nil];
    
    self.statusView.tagLabel.text = @"热门";
    self.statusView.sourceLabel.text = newsModel.souce;
    self.statusView.commentCountLabel.text = [NSString stringWithFormat:@"%d评论",0];
    self.statusView.timeLabel.text = [WYCommonUtils dateDiscriptionFromNowBk:[WYCommonUtils dateFromUSDateString:newsModel.public_time]];
    
}

@end
