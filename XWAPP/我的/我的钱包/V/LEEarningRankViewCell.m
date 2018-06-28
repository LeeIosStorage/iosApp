//
//  LEEarningRankViewCell.m
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEEarningRankViewCell.h"

@interface LEEarningRankViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *apprenticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation LEEarningRankViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.apprenticeLabel removeFromSuperview];
    [self.contentView addSubview:self.apprenticeLabel];
    [self.apprenticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-HitoActureHeight(137));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithData:(LEEarningRankModel *)rankModel{
    
    self.userIdLabel.text = rankModel.userId;
    self.apprenticeLabel.text = [NSString stringWithFormat:@"%d",rankModel.apprenticeCount];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[rankModel.balance floatValue]];
    
    self.topLabel.text = [NSString stringWithFormat:@"%ld",_row+1];
    self.topLabel.hidden = NO;
    self.topImageView.hidden = YES;
    if (_row < 3) {
        self.topLabel.hidden = YES;
        self.topImageView.hidden = NO;
        if (_row == 0) self.topImageView.image = [UIImage imageNamed:@"mine_img_num1"];
        else if (_row == 1) self.topImageView.image = [UIImage imageNamed:@"mine_img_num2"];
        else if (_row == 2) self.topImageView.image = [UIImage imageNamed:@"mine_img_num3"];
    }
    
    if ((_row+1)%2 == 0) {
        self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
