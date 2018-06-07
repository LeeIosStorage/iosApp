//
//  LEEarningRankViewCell.h
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEEarningRankModel.h"

@interface LEEarningRankViewCell : UITableViewCell

@property (assign, nonatomic) NSInteger row;

- (void)updateCellWithData:(LEEarningRankModel *)rankModel;

@end
