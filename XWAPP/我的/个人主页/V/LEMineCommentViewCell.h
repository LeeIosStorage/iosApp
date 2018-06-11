//
//  LEMineCommentViewCell.h
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickNewsDetailBlock)(void);

@interface LEMineCommentViewCell : UITableViewCell

@property (copy, nonatomic) ClickNewsDetailBlock clickNewsDetailBlock;

- (void)updateViewCellData:(id)data;

@end
