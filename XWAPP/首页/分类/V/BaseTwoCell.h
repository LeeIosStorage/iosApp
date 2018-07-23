//
//  BaseTwoCell.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusView.h"
#import "LENewsListModel.h"
#import "LENewsBottomInfoView.h"

@interface BaseTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet StatusView *statusView;

@property (strong, nonatomic) LENewsBottomInfoView *newsBottomInfoView;

@property (assign, nonatomic) LENewsListCellType cellType;

- (void)updateCellWithData:(LENewsListModel *)newsModel;

@end
