//
//  BaseOneCell.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusView.h"
#import "LENewsListModel.h"

@interface BaseOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet StatusView *statusView;

- (void)updateCellWithData:(LENewsListModel *)newsModel;

@end
