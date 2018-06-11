//
//  LEWalletHeaderView.h
//  XWAPP
//
//  Created by hys on 2018/6/4.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LEPutForwardBlock)(void);

@interface LEWalletHeaderView : UIView

@property (copy, nonatomic) LEPutForwardBlock putForwardBlock;

- (void)updateHeaderViewData:(id)data;

@end
