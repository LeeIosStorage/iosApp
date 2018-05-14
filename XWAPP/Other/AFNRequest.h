//
//  AFNRequest.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/26.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^Complete)(id jsonData);

@interface AFNRequest : NSObject

@property (nonatomic, copy) Complete complete;

+ (void)requst:(NSString *)requestURL parameters:(id)parameters complete:(Complete)complete;

@end
