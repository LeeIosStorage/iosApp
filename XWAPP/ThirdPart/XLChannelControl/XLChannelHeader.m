//
//  XLChannelHeaderView.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelHeader.h"

@interface XLChannelHeader ()
{
    UILabel *_titleLabel;
    
    UILabel *_subtitleLabel;
}
@end

@implementation XLChannelHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    CGFloat marginX = 15.0f;
    
    CGFloat labelWidth = 70;

    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, labelWidth, self.bounds.size.height)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium"size:16];
    [self addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + marginX * 2 , 0, 100, self.bounds.size.height)];
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
    _subtitleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium"size:12];
    [self addSubview:_subtitleLabel];
    
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(HitoScreenW - 70, 0, labelWidth, self.bounds.size.height)];
    [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [_rightBtn setSelected:NO];
    [_rightBtn setTitleColor:HitoColorFromRGB(0xff4b41) forState:UIControlStateNormal];
    [_rightBtn setTitleColor:HitoColorFromRGB(0xff4b41) forState:UIControlStateSelected];
    [_rightBtn.titleLabel setFont:HitoPFSCMediumOfSize(14)];
    [_rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightBtn];

}

- (void)rightAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _changeStatus(sender.selected);
}

- (void)changeStatusBlock:(ChangeStatus)changeStatus {
    _changeStatus = changeStatus;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subtitleLabel.text = subTitle;
}

@end
