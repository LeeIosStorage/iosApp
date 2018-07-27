//
//  LEShareSheetView.h
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENewsListModel.h"
#import "LEShareModel.h"

@protocol LEShareSheetViewDelegate <NSObject>
@optional
- (void)shareSheetCollectAction;

@end

@interface LEShareSheetView : NSObject

@property (nonatomic, weak) UIViewController<LEShareSheetViewDelegate> *owner;

@property (nonatomic, assign) BOOL isVideo;//是否是视频分享

@property (nonatomic, strong) LEShareModel *shareModel;//通用分享model

@property (nonatomic, strong) LENewsListModel *newsModel;//资讯分享

//分享框
- (void)showShareAction;

@end
