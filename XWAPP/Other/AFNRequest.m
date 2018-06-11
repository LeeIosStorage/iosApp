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
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain",[NSString stringWithFormat:@"version/%@",app_Version], nil];
    AFJSONResponseSerializer *jsonResponseSerializer = [AFJSONResponseSerializer serializer];
    jsonResponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonResponseSerializer;
    
    [manager GET:requestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id responseDataObject = nil;
        if (responseObject) {
            responseDataObject = responseObject[@"content"];
            if ([responseDataObject isKindOfClass:[NSString class]]) {
                NSData *data = [responseDataObject dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                responseDataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }
        }
        complete(responseDataObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //
    }];
}

@end
