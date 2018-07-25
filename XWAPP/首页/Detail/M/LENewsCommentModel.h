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
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *replyUserName;
@property (strong, nonatomic) NSString *replyuId;

@property (strong, nonatomic) NSArray *children;

@end

@protocol LEReplyCommentModel
@end
@interface LENewsCommentModel : NSObject

@property (strong, nonatomic) NSString *commentId;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *avatarUrl;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) int favourNum;
@property (assign, nonatomic) BOOL favour;

@property (strong, nonatomic) NSArray *comments;

//关于我的评论的字段
@property (strong, nonatomic) NSString *newsId;
@property (strong, nonatomic) NSString *newsUrl;
@property (strong, nonatomic) NSString *newsTitle;
@property (nonatomic, assign) int typeId;//0图文1视频

@end
