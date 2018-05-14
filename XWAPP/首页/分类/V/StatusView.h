//
//  StatusView.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleBlock)(void);

@interface StatusView : UIView

@property (nonatomic, copy) DeleBlock deleeBlock;


- (void)deleblockAction:(DeleBlock)deleblock;


@end
