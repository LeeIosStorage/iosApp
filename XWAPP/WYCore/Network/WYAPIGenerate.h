//
//  WYAPIGenerate.h
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kNetworkHostCacheKey;

static NSString* defaultNetworkHost =  @"api.hangzhouhaniu.com/rest";//线上
static NSString* defaultNetworkPreRelease = @"47.96.123.144:8080/rest";//预发布地址
static NSString* defaultNetworkHostTest = @"192.168.60.187:8080";//测试地址

static NSString* defaultWebHost = @"app.hangzhouhaniu.com/h5";//线上web
static NSString* defaultWebPreRelease = @"app.hangzhouhaniu.com/h5";//预发布web
static NSString* defaultWebHostTest = @"192.168.60.187:8080";//测试地址web

@interface WYAPIGenerate : NSObject
/**
 *  HOST
 */
@property (copy, nonatomic) NSString *netWorkHost;
/**
 *  设置默认的协议类型
 */
@property (nonatomic, strong) NSString *defaultProtocol;
/**
 *  获取服务器地址
 */
@property (nonatomic, readonly) NSString *baseURL;
/**
 *  获取Web的服务器地址
 */
@property (nonatomic, copy) NSString *baseWebUrl;

+ (WYAPIGenerate *)sharedInstance;

- (NSString*)API:(NSString*)apiName;

- (NSString*)API:(NSString*)apiName urlHost:(NSString *)urlHost;

@end
