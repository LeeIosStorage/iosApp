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

@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 71, 0, 12));
    }];
    
    [self.containerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 12, 0, 12));
    }];
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    }
    return _containerView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = HitoPFSCRegularOfSize(14);
        _contentLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }
    return _contentLabel;
}

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
    NSString *userName = commentModel.userName;
    if (userName.length == 0) userName = @"匿名用户";
    NSString *replyUserName = commentModel.replyUserName;
    if (replyUserName.length == 0) replyUserName = @"";
    
    NSString *contentString = nil;
    if (replyUserName.length > 0) {
        contentString = [NSString stringWithFormat:@"%@回复%@：%@",userName,replyUserName,content];
    }else{
        contentString = [NSString stringWithFormat:@"%@：%@",userName,content];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3477c0"] range:NSMakeRange(0, userName.length)];
    if (replyUserName.length > 0) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"3477c0"] range:NSMakeRange(userName.length+2, replyUserName.length)];
    }
    
    self.contentLabel.attributedText = attributedString;
}

@end
