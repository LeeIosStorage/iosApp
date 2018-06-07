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
    
}

@end
