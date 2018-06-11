//
//  LENoticeViewCell.h
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEMessageModel.h"

@interface LENoticeViewCell : UITableViewCell

- (void)updateCellWithData:(LEMessageModel *)messageModel;

@end
