//
//  WYNetworkHeader.h
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#ifndef WYNetworkHeader_h
#define WYNetworkHeader_h

static NSString *const kResponseObjectKeyObject = @"content";
static NSString *const kResponseObjectKeyCode = @"stateCode";
static NSString *const kResponseObjectKeyResult = @"result";

static NSString *const kParamUserInfoUID = @"userId";
static NSString *const kParamUserInfoAuthToken = @"token";

typedef NS_ENUM(NSInteger, WYRequestType) {
    WYRequestTypeSuccess = 100,
    WYRequestTypeTokenInvalid = -1,//token失效
    WYRequestTypeNotLogin = -4, //未登录
    WYRequestTypeFailed = 404, //主机地址未找到
    WYRequestTypeUnauthorized = 401, //未授权
    WYRequestTypeUnauthorized2 = 700,//token失效
};

typedef void(^WYRequestSuccessBlock)(WYRequestType requestType,NSString* message,BOOL isCache,id dataObject);
typedef void(^WYRequestFailureBlock)(id responseObject, NSError * error);
typedef void(^WYRequestProgressBlock)(NSProgress * _Nonnull uploadProgress);

#endif /* WYNetworkHeader_h */
