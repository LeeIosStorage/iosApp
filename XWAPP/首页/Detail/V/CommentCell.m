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
    NSString *content = commentModel.content;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3477c0"] range:NSMakeRange(0, 2)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3477c0"] range:NSMakeRange(4, 2)];
    
    self.contentLabel.attributedText = attributedString;
}

@end
