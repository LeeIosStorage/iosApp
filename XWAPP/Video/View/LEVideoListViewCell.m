//
//  LEVideoListViewCell.m
//  XWAPP
//
//  Created by hys on 2018/7/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoListViewCell.h"
#import "LENewsListModel.h"
#import "LEPlayerStatusView.h"
#import <JMRoundedCorner/UIView+RoundedCorner.h>

@interface LEVideoListViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIView *markContentView;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet LEPlayerStatusView *playerStatusView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *avatarView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation LEVideoListViewCell

- (void)setCellType:(LENewsListCellType)cellType{
    _cellType = cellType;
    if (cellType == LENewsListCellTypePersonal) {
        [self.contentView addSubview:self.newsBottomInfoView];
        [self.newsBottomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(0);
            make.height.equalTo(self.statusView.mas_height);
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.totalTimeLabel jm_setCornerRadius:10 withBackgroundColor:[UIColor colorWithRGB:0x000000 alpha:0.4]];
    
    [WYCommonUtils addShadowWithView:self.markImageView mode:0 size:CGSizeMake(HitoScreenW, 60)];
    
    HitoWeakSelf;
    self.statusView.avatarClickBlock = ^{
        [WeakSelf avatarAction:nil];
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)avatarAction:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCellAvatarClickWithCell:)]) {
        [self.delegate videoCellAvatarClickWithCell:self];
    }
}

- (void)updateCellWithData:(id)data{
    LENewsListModel *model = (LENewsListModel *)data;
    NSString *coverUrl = nil;
    if (model.cover.count > 0) {
        coverUrl = [model.cover objectAtIndex:0];
    }
    [WYCommonUtils setImageWithURL:[NSURL URLWithString:coverUrl] setImage:self.coverImageView setbitmapImage:nil];
    
    if (_cellType == LENewsListCellTypePersonal) {
        [self.newsBottomInfoView updateViewWithData:model];
        self.avatarView.hidden = YES;
    }else{
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:coverUrl] setImageView:self.avatarImageView setbitmapImage:[UIImage imageNamed:@"LOGO"] radius:25];
        self.avatarView.hidden = NO;
        self.avatarView.hidden = NO;
        [self.statusView updateWithData:model];
    }

    self.playerStatusView.playStatus = LEplayStatus_playing;
    [self.playerStatusView.playbutton setImage:[UIImage imageNamed:@"le_player_play_bottom_window"] forState:UIControlStateDisabled];
    self.playerStatusView.playbutton.enabled = NO;
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"   %@   ",@"02:39"];
    
    self.videoTitleLabel.text = model.title;
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
