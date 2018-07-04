//
//  LESettingTableCell.m
//  XWAPP
//
//  Created by hys on 2018/7/4.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESettingTableCell.h"

@interface LESettingTableCell ()

@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) UIImageView *lineImageView;

@end

@implementation LESettingTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup{
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(13);
        make.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = HitoPFSCRegularOfSize(15);
        _titleLabel.textColor = kAppTitleColor;
    }
    return _titleLabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"task_jiantou"];
    }
    return _rightImageView;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = LineColor;
    }
    return _lineImageView;
}

@end
