//
//  HotCell.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "HotCell.h"
#import "LEHotNewsModel.h"

@interface HotCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@end

@implementation HotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.titleLabel removeFromSuperview];
    [self.contentView addSubview:self.titleLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(id)data{
    
    LEHotNewsModel *hotNewsModel = (LEHotNewsModel *)data;
    
    self.timeLabel.text = [WYCommonUtils dateHourToMinuteDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:hotNewsModel.public_time]];
    self.titleLabel.text = hotNewsModel.title;
    
    NSString *imageUrl = @"";
    if (hotNewsModel.cover.count > 0) {
        imageUrl = [hotNewsModel.cover objectAtIndex:0];
    }
    if (imageUrl.length > 0) {
        self.newsImageView.hidden = NO;
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:imageUrl] setImage:self.newsImageView setbitmapImage:nil];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-14);
            make.right.equalTo(self.newsImageView.mas_left).offset(-14);
            make.height.mas_equalTo(52.5);
        }];
    }else{
        self.newsImageView.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-14);
            make.right.equalTo(self.contentView.mas_right).offset(-12);
//            make.height.mas_equalTo(52.5);
        }];
    }
    
}

@end
