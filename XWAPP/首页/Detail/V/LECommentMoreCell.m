//
//  LECommentMoreCell.m
//  XWAPP
//
//  Created by hys on 2018/5/19.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LECommentMoreCell.h"

@interface LECommentMoreCell ()

@property (strong, nonatomic) UIView *containerView;

@property (strong, nonatomic) UIButton *moreButton;

@end

@implementation LECommentMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)moreClickAction:(id)sender{
    if (self.commentMoreClickBolck) {
        self.commentMoreClickBolck();
    }
}

- (void)setCommentMoreCellType:(LECommentMoreCellType )commentMoreCellType{
    _commentMoreCellType = commentMoreCellType;
    
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 71, 0, 12));
        if (commentMoreCellType == LECommentMoreCellTypeMore || commentMoreCellType == LECommentMoreCellTypeALL) {
            make.height.mas_equalTo(41);
        }else{
            make.height.mas_equalTo(8);
        }
    }];
    
    if (commentMoreCellType == LECommentMoreCellTypeMore || commentMoreCellType == LECommentMoreCellTypeALL) {
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"查看更多评论 >" forState:UIControlStateNormal];
        [_moreButton setTitleColor:[UIColor colorWithHexString:@"0851af"] forState:UIControlStateNormal];
        _moreButton.enabled = YES;
        if (commentMoreCellType == LECommentMoreCellTypeALL) {
            [_moreButton setTitle:@"已加载全部" forState:UIControlStateNormal];
            [_moreButton setTitleColor:[UIColor colorWithHexString:@"767676"] forState:UIControlStateNormal];
            _moreButton.enabled = NO;
        }
        
    }else{
        _moreButton.hidden = YES;
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = kAppBackgroundColor;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"查看更多评论 >" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"0851af"] forState:UIControlStateNormal];
        [button.titleLabel setFont:HitoPFSCRegularOfSize(14)];
        [button addTarget:self action:@selector(moreClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreButton = button;
        [_containerView addSubview:button];
        __weak typeof(_containerView) containerViewWeak = _containerView;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerViewWeak);
            make.bottom.equalTo(containerViewWeak).offset(-2);
        }];
    }
    return _containerView;
}

@end
