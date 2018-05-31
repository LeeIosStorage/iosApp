//
//  LEShareSheetView.h
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENewsListModel.h"

@protocol LEShareSheetViewDelegate <NSObject>
@optional

@end

@interface LEShareSheetView : NSObject

@property (nonatomic, weak) UIViewController<LEShareSheetViewDelegate> *owner;

@property (nonatomic, assign) BOOL isVideo;//是否是视频分享

@property (nonatomic, strong) LENewsListModel *newsModel;

//分享框
- (void)showShareAction;

@end
