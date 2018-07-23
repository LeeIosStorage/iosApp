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
    self.coverImageView1.clipsToBounds = YES;
    self.coverImageView1.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView2.clipsToBounds = YES;
    self.coverImageView2.contentMode = UIViewContentModeScaleAspectFill;
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
    
    if (_cellType == LENewsListCellTypePersonal) {
        [self.newsBottomInfoView updateViewWithData:newsModel];
        self.statusView.hidden = YES;
    }else{
        self.statusView.hidden = NO;
        [self.statusView updateCellWithData:newsModel];
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
