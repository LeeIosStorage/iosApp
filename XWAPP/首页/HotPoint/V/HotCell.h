//
//  HotCell.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)updateCellWithData:(id)data;

@end
