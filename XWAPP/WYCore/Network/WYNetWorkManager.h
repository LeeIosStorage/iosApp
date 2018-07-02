//
//  WYNetWorkManager.h
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYNetworkHeader.h"
#import "WYAPIGenerate.h"

@interface WYNetWorkManager : NSObject

+ (instancetype)sharedManager UNAVAILABLE_ATTRIBUTE;

/**
 *  自动添加uid&token参数
 *
 *  @param caCheKey 最好以在config.json文件中请求Path的key作为caCheKey
 *  @param needCache 如果在返回结果中需要获取到缓存需要设置为YES，只有设置为YES才会开启缓存
 *  @return to provide lexical differentiation from download and upload tasks
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                    needCache:(BOOL)needCache
                     caCheKey:(NSString *)caCheKey
                   parameters:(id)parameters
                responseClass:(Class)classType
                      success:(WYRequestSuccessBlock)success
                      failure:(WYRequestFailureBlock)failure;

/**
 *  只添加token参数
 */
- (NSURLSessionDataTask *)GETWithOutUserID:(NSString *)URLString
                                 needCache:(BOOL)needCache
                                  caCheKey:(NSString *)caCheKey
                                parameters:(id)parameters
                             responseClass:(Class)classType
                                   success:(WYRequestSuccessBlock)success
                                   failure:(WYRequestFailureBlock)failure;

/**
 *  uid&token都不添加
 */
- (NSURLSessionDataTask *)GETWithOutUserIDToken:(NSString *)URLString
                                      needCache:(BOOL)needCache
                                       caCheKey:(NSString *)caCheKey
                                     parameters:(id)parameters
                                  responseClass:(Class)classType
                                        success:(WYRequestSuccessBlock)success
                                        failure:(WYRequestFailureBlock)failure;

/**
 *  POST请求
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                     needCache:(BOOL)needCache
                      caCheKey:(NSString *)caCheKey
                    parameters:(id)parameters
                 responseClass:(Class)classType
                needHeaderAuth:(BOOL)needHeaderAuth
                       success:(WYRequestSuccessBlock)success
                       failure:(WYRequestFailureBlock)failure;

/**
 *  上传文件的POST请求
 *  @param formFileName   for examples:@"pic"
 *  @param fileName       for examples:@"pic"
 *  @param mimeType       for examples:@"image/png"
 */
- (void)POST:(NSString *)URLString
formFileName:(NSString *)formFileName
    fileName:(NSString *)fileName
    fileData:(NSData *)fileData
    mimeType:(NSString *)mimeType
  parameters:(id )parameters
responseClass:(Class )classType
     success:(WYRequestSuccessBlock)success
     failure:(WYRequestFailureBlock)failure;

#pragma mark - App Store 版本号
- (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion ,NSString * newVersion , NSString * currentVersion))success failure:(void (^)(NSError *error))failure;

@end
