//
//  LEVideoShareView.h
//  XWAPP
//
//  Created by hys on 2018/7/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReplayClickedBlock)(void);
typedef void (^VideoShareClickedBlock)(NSInteger index);

@interface LEVideoShareView : UIView

@property (nonatomic, copy) ReplayClickedBlock  replayClickedBlock;

@property (nonatomic, copy) VideoShareClickedBlock  videoShareClickedBlock;

@end
