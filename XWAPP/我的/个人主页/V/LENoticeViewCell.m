//
//  LENoticeViewCell.m
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LENoticeViewCell.h"

@interface LENoticeViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet YYLabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation LENoticeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = kAppBackgroundColor;
    
    [self.desLabel removeFromSuperview];
    [self.contentView addSubview:self.desLabel];
    self.desLabel.numberOfLines = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(LEMessageModel *)messageModel{
    
    self.titleLabel.text = messageModel.title;
    
    NSMutableAttributedString *desAttString = nil;
    if (messageModel.messageType == LEMessageTypeSystem) {
        
        NSString *rateText = [NSString stringWithFormat:@"昨日汇率：%@\n",messageModel.rate];
        NSString *goldText = [NSString stringWithFormat:@" %@ 金币",messageModel.gold];
        CGFloat cny = ([messageModel.gold floatValue]*[messageModel.rate floatValue])/1000.0;
        NSString *cnyText = [NSString stringWithFormat:@"%.2f 元",cny];
        NSString *desString = [NSString stringWithFormat:@"%@您昨天赚取的%@，已经帮您兑换成零钱：%@。继续加油哦~",rateText,goldText,cnyText];
        
        desAttString = [[NSMutableAttributedString alloc] initWithString:desString];
        [desAttString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:kAppTitleColor} range:NSMakeRange(0, desAttString.length)];
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"c22121"]};
        [desAttString addAttributes:attributes range:NSMakeRange(0, rateText.length)];
        
        attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ffa800"]};
        [desAttString addAttributes:attributes range:[desString rangeOfString:goldText]];

        attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"c22121"]};
        [desAttString addAttributes:attributes range:[desString rangeOfString:cnyText]];
        
    }else if (messageModel.messageType == LEMessageTypeNone){
        
        desAttString = [[NSMutableAttributedString alloc] initWithString:messageModel.des];
        [desAttString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:kAppTitleColor} range:NSMakeRange(0, desAttString.length)];
    }
    [desAttString addAttribute:NSParagraphStyleAttributeName value:(id)[self getParagraphStyleByCustom] range:NSMakeRange(0, desAttString.length)];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(HitoScreenW-12*2, HUGE)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:desAttString];
    self.desLabel.displaysAsynchronously = YES;
    self.desLabel.ignoreCommonProperties = YES;
    self.desLabel.textLayout = textLayout;
    self.desLabel.left = 12;
    self.desLabel.width = HitoScreenW-12*2;
    self.desLabel.height = textLayout.textBoundingSize.height;
    
    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(13);
        make.bottom.equalTo(self.tipLabel.mas_top).offset(-13);
        make.height.mas_offset(textLayout.textBoundingSize.height);
    }];
    
}

- (NSMutableParagraphStyle *)getParagraphStyleByCustom
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.f;
//    paragraphStyle.paragraphSpacing = 12.f;//段落
    paragraphStyle.firstLineHeadIndent = 12.0f;
    paragraphStyle.headIndent = 12.f;
    paragraphStyle.tailIndent = -12.f;
    return paragraphStyle;
}

@end
