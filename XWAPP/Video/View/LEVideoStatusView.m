//
//  LEVideoStatusView.m
//  XWAPP
//
//  Created by hys on 2018/7/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEVideoStatusView.h"
#import "UIView+Xib.h"
#import "LENewsListModel.h"

@interface LEVideoStatusView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation LEVideoStatusView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
}

- (IBAction)avatarClickAction:(id)sender {
    if (self.avatarClickBlock) {
        self.avatarClickBlock();
    }
}
- (IBAction)attentionAction:(id)sender {
    if (self.attentionClickBlock) {
        self.attentionClickBlock();
    }
}
- (IBAction)commentAction:(id)sender {
    if (self.commentClickBlock) {
        self.commentClickBlock();
    }
}
- (IBAction)shareAction:(id)sender {
    if (self.shareClickBlock) {
        self.shareClickBlock();
    }
}


- (void)updateWithData:(id)data{
    LENewsListModel *model = (LENewsListModel *)data;
    self.nameLabel.text = model.nickName;
    
    self.attentionButton.selected = model.isAttention;
    if (model.isAttention) {
        [self.attentionButton setImage:nil forState:UIControlStateNormal];
    }else{
        [self.attentionButton setImage:[UIImage imageNamed:@"home_shipin_guanzhu"] forState:UIControlStateNormal];
    }
    
    NSString *commentCount = @"  评论";
    if (model.commentCount > 0) {
        commentCount = [NSString stringWithFormat:@"  %d",model.commentCount];
    }
    
    [self.commentButton setTitle:commentCount forState:UIControlStateNormal];
}

@end
