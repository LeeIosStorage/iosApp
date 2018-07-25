//
//  LENewsListModel.h
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LENewsListModel : NSObject

@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *souce;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *public_time;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSArray *cover;
@property (nonatomic, assign) int commentCount;
@property (nonatomic, assign) int readCount;
@property (nonatomic, assign) int likeCount;
//@property (nonatomic, assign) BOOL canComment;
//@property (nonatomic, assign) BOOL unLikeEnable;
//@property (nonatomic, assign) int type;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isTop;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userHeadImg;
@property (nonatomic, assign) int attentionCount;

@property (nonatomic, assign) int typeId;//0图文1视频
@property (nonatomic, assign) BOOL isAttention;

//广告
@property (nonatomic, assign) BOOL is_ad;//是广告
@property (nonatomic, strong) NSString *adUrl;//广告链接
@property (nonatomic, assign) NSInteger adType;//广告类型

//详情
@property (nonatomic, strong) NSString *content;//正文

//收藏
@property (nonatomic, strong) NSString *favoriteId;//收藏id

@end
