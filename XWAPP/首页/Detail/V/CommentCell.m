//
//  CommentCell.m
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "CommentCell.h"
#import "LENewsCommentModel.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateHeaderData:(id)data{
    
    LEReplyCommentModel *commentModel = (LEReplyCommentModel *)data;
    self.contentLabel.text = commentModel.content;
}

@end
