//
//  WalletCell.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "WalletCell.h"
#import "LEGoldRecordModel.h"

@interface WalletCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *goldLabel;

@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UIImageView *lineImageView;

@end

@implementation WalletCell

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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup{
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(11);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(2);
    }];
    
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-13);
        make.top.equalTo(self.contentView.mas_centerY).offset(3);
    }];
    
    [self.contentView addSubview:self.lineImageView];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateWalletCellWithData:(id)data{
    
    LEGoldRecordModel *goldRecordModel = (LEGoldRecordModel *)data;
    self.titleLabel.text = goldRecordModel.title;
    NSString *goldString = [NSString stringWithFormat:@"%@ 金币",goldRecordModel.gold];
    if (goldRecordModel.recordType == 1) {
        goldString = [NSString stringWithFormat:@"%@ 元",goldRecordModel.gold];
    }
    self.goldLabel.text = goldString;
    self.dateLabel.text = [WYCommonUtils dateYearToSecondDiscriptionFromDate:[WYCommonUtils dateFromUSDateString:goldRecordModel.date]];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kAppTitleColor;
        _titleLabel.font = HitoPFSCRegularOfSize(16);
        
    }
    return _titleLabel;
}

- (UILabel *)goldLabel{
    if (!_goldLabel) {
        _goldLabel = [[UILabel alloc] init];
        _goldLabel.textColor = kAppThemeColor;
        _goldLabel.font = HitoPFSCMediumOfSize(16);
    }
    return _goldLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = kAppSubTitleColor;
        _dateLabel.font = HitoPFSCMediumOfSize(11);
    }
    return _dateLabel;
}

- (UIImageView *)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = LineColor;
    }
    return _lineImageView;
}

@end
