//
//  LENewsCommentModel.h
//  XWAPP
//
//  Created by hys on 2018/5/19.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEReplyCommentModel : NSObject

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *content;

@end

@protocol LEReplyCommentModel
@end
@interface LENewsCommentModel : NSObject

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) int favourNum;
@property (assign, nonatomic) BOOL favour;

@property (strong, nonatomic) NSArray <LEReplyCommentModel> *comments;

@end
