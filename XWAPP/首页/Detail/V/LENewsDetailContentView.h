//
//  LENewsDetailContentView.h
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LENewsDetailContentView : UIView

@property (strong, nonatomic) YYLabel *contentLabel;

- (void)updateWithData:(id)data;

@end
