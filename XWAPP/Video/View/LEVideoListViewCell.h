//
//  LEVideoListViewCell.h
//  XWAPP
//
//  Created by hys on 2018/7/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEVideoStatusView.h"

@protocol LEVideoListViewCellDelegate;

@interface LEVideoListViewCell : UITableViewCell

@property (weak, nonatomic) id <LEVideoListViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet LEVideoStatusView *statusView;

- (void)updateCellWithData:(id)data;

@end

@protocol LEVideoListViewCellDelegate <NSObject>
@optional
- (void)videoCellAvatarClickWithCell:(LEVideoListViewCell *)cell;

@end
