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

- (void)setCellType:(LENewsListCellType)cellType{
    _cellType = cellType;
    if (cellType == LENewsListCellTypePersonal) {
        [self.contentView addSubview:self.newsBottomInfoView];
        [self.newsBottomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-3);
            make.height.mas_equalTo(38);
        }];
    }
}

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
    
    if (_cellType == LENewsListCellTypePersonal) {
        [self.newsBottomInfoView updateViewWithData:newsModel];
        self.statusView.hidden = YES;
    }else{
        self.statusView.hidden = NO;
        [self.statusView updateCellWithData:newsModel];
    }
    
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

#pragma mark -
#pragma mark - Set And Getters
- (LENewsBottomInfoView *)newsBottomInfoView{
    if (!_newsBottomInfoView) {
        _newsBottomInfoView = [[LENewsBottomInfoView alloc] init];
    }
    return _newsBottomInfoView;
}

@end
