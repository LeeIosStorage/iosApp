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
    self.titleLabel.layer.masksToBounds = YES;
    
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
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
    
    [self.statusView updateCellWithData:newsModel];
    
    if (imageUrl.length == 0) {
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
