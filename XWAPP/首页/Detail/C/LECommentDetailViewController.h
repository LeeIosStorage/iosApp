//
//  LECommentDetailViewController.h
//  XWAPP
//
//  Created by hys on 2018/5/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"
#import "LENewsCommentModel.h"

@interface LECommentDetailViewController : LESuperViewController

@property (strong, nonatomic) LENewsCommentModel *commentModel;

@property (strong, nonatomic) NSString *newsId;

@end
