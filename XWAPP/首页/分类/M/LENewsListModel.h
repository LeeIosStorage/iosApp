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
@property (nonatomic, strong) NSArray *cover;
@property (nonatomic, assign) int type;

@property (nonatomic, strong) NSString *content;//正文

@property (nonatomic, strong) NSString *favoriteId;//收藏id

@end
