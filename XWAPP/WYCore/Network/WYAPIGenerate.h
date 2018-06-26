//
//  WYAPIGenerate.h
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const kNetworkHostCacheKey;

static NSString* defaultNetworkHost =  @"47.96.123.144:5001";//线上
static NSString* defaultNetworkPreRelease = @"120.78.63.229:5001";//预发布地址
static NSString* defaultNetworkHostTest = @"192.168.60.170:5001";//测试地址

static NSString* defaultWebHost = @"47.96.123.144";//线上web
static NSString* defaultWebPreRelease = @"120.78.63.229";//预发布web
static NSString* defaultWebHostTest = @"192.168.60.170";//测试地址web

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

@end
