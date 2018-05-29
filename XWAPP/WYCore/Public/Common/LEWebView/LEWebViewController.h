//
//  LEWebViewController.h
//  XWAPP
//
//  Created by hys on 2018/5/29.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"

@interface LEWebViewController : LESuperViewController

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURLString:(NSString *)urlString;

@end
