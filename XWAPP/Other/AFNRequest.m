//
//  AFNRequest.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/26.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "AFNRequest.h"

@implementation AFNRequest


+ (void)requst:(NSString *)requestURL parameters:(id)parameters complete:(Complete)complete  {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:requestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        complete(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

@end
