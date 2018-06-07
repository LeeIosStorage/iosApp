//
//  LEMessageModel.h
//  XWAPP
//
//  Created by hys on 2018/6/6.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LEMessageType) {
    LEMessageTypeNone = 0,
    LEMessageTypeSystem = 1,
//    LEMessageTypeNone = 2,
};

@interface LEMessageModel : NSObject

@property (strong, nonatomic) NSString *messageId;
@property (assign, nonatomic) LEMessageType messageType;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *des;
@property (strong, nonatomic) NSString *rate;
@property (strong, nonatomic) NSString *gold;

@end
