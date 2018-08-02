//
//  LENetworkStatusView.h
//  XWAPP
//
//  Created by hys on 2018/7/31.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ContinueClickedBlock)(void);

@interface LENetworkStatusView : UIView

@property (nonatomic, copy) ContinueClickedBlock continueClickedBlock;

- (void)refreshUIWith:(NSInteger)type;

@end
