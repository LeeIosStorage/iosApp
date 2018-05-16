//
//  WYNetWorkManager.m
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import "WYNetWorkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "WYNetWorkExceptionHandling.h"
#import "YTCache.h"



@implementation WYNetWorkManager

+ (instancetype)sharedManager
{
    static WYNetWorkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                    needCache:(BOOL)needCache
                     caCheKey:(NSString *)caCheKey
                   parameters:(id)parameters
                responseClass:(Class)classType
                      success:(WYRequestSuccessBlock)success
                      failure:(WYRequestFailureBlock)failure{
    
    return [self GET:URLString outUserId:NO outToken:NO needCache:needCache caCheKey:caCheKey parameters:parameters responseClass:classType success:success failure:failure];
}

- (NSURLSessionDataTask *)GETWithOutUserID:(NSString *)URLString
                                 needCache:(BOOL)needCache
                                  caCheKey:(NSString *)caCheKey
                                parameters:(id)parameters
                             responseClass:(Class)classType
                                   success:(WYRequestSuccessBlock)success
                                   failure:(WYRequestFailureBlock)failure{
    
    return [self GET:URLString outUserId:YES outToken:NO needCache:needCache caCheKey:caCheKey parameters:parameters responseClass:classType success:success failure:failure];
}

- (NSURLSessionDataTask *)GETWithOutUserIDToken:(NSString *)URLString
                                      needCache:(BOOL)needCache
                                       caCheKey:(NSString *)caCheKey
                                     parameters:(id)parameters
                                  responseClass:(Class)classType
                                        success:(WYRequestSuccessBlock)success
                                        failure:(WYRequestFailureBlock)failure{
    return [self GET:URLString outUserId:YES outToken:YES needCache:needCache caCheKey:caCheKey parameters:parameters responseClass:classType success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                    outUserId:(BOOL)outUserId
                    outToken:(BOOL)outToken
                    needCache:(BOOL)needCache
                     caCheKey:(NSString *)caCheKey
                   parameters:(id)parameters
                responseClass:(Class)classType
                      success:(WYRequestSuccessBlock)success
                      failure:(WYRequestFailureBlock)failure
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setHttpHeader:manager];
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString outUserId:outUserId outToken:outToken];
    
    YYCache *cache = [YTCache sharedCache].commonCache;
    
    //缓存处理
    if (needCache && URLString && success) {
        id cacheObject = [cache objectForKey:caCheKey];
        if (cacheObject) {
            //model对象
            if (classType) {
                //不是需要的类型，不返回缓存
                if ([cacheObject isKindOfClass:classType]) {
                    success(WYRequestTypeSuccess, nil, YES, cacheObject);
                } else if ([cacheObject isKindOfClass:[NSArray class]]) {
                    //数组对象
                    NSArray *cacheObjestArray = (NSArray *)cacheObject;
                    if (cacheObjestArray && [cacheObjestArray count] > 0) {
                        id modelObject = [cacheObjestArray firstObject];
                        if ([modelObject isKindOfClass:classType]) {
                            success(WYRequestTypeSuccess, nil, YES, cacheObject);
                        }
                    }
                }
            } else {
                success(WYRequestTypeSuccess, nil, YES, cacheObject);
            }
        }
    }
    //WYLog(@"开始请求");
    NSURLSessionDataTask *task = nil;
    
//    WS(weakSelf)
    task = [manager GET:requestURLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\n url = %@\n responseObject=%@",task.currentRequest.URL,responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //[self handleResponseObject:responseObject];
        }
        NSString *message = nil;
        NSInteger status = WYRequestTypeFailed;
        id responseDataObject = nil;
        if (responseObject) {
            message = [responseObject objectForKey:kResponseObjectKeyResult];
            NSNumber* statusCode = [responseObject objectForKey:kResponseObjectKeyCode];
            if (statusCode) {
                status = statusCode.integerValue;
            }
            responseDataObject = responseObject[kResponseObjectKeyObject];
            //此处有两种情况发生，正常的是json，非正常是一个常规string
            if ([responseDataObject isKindOfClass:[NSString class]]) {
                NSData *data = [responseDataObject dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                responseDataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }
        }
        
        if (success) {
            if ([WYNetWorkExceptionHandling judgeReuqestStatus:status URLString:URLString] && classType && responseDataObject) {
                if ([responseDataObject isKindOfClass:[NSArray class]]) {
                    
                    NSArray *array = [NSArray modelArrayWithClass:classType json:responseDataObject];
                    
                    if (needCache) {
                        [cache setObject:array forKey:caCheKey];
                    }
                    success(status,message,NO,array);
                } else {
                    NSDictionary *dic = [NSDictionary modelDictionaryWithClass:classType json:responseObject];
                    
                    id model = dic[kResponseObjectKeyObject];
                    
                    if (needCache) {
                        [cache setObject:model forKey:caCheKey];
                        
                    }
                    success(status,message,NO,model);
                }
            } else {
                
                if (needCache) {
                    [cache setObject:responseDataObject forKey:caCheKey];
                }
                success(status,message,NO,responseDataObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure error: %@",error);
        if (failure) {
            failure(nil, error);
        }
    }];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                     needCache:(BOOL)needCache
                      caCheKey:(NSString *)caCheKey
                    parameters:(id)parameters
                 responseClass:(Class)classType
                       success:(WYRequestSuccessBlock)success
                       failure:(WYRequestFailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setHttpHeader:manager];
    
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString outUserId:NO outToken:NO];
    NSLog(@"POST  url   %@",requestURLString);
    YYCache *cache = [YTCache sharedCache].commonCache;
    //缓存处理
    if (needCache && URLString && success) {
        id cacheObject = [cache objectForKey:caCheKey];
        if (cacheObject) {
            //model对象
            if (classType) {
                //不是需要的类型，不返回缓存
                if ([cacheObject isKindOfClass:classType]) {
                    success(WYRequestTypeSuccess, nil, YES, cacheObject);
                } else if ([cacheObject isKindOfClass:[NSArray class]]) {
                    //数组对象
                    NSArray *cacheObjestArray = (NSArray *)cacheObject;
                    if (cacheObjestArray && [cacheObjestArray count] > 0) {
                        id modelObject = [cacheObjestArray firstObject];
                        if ([modelObject isKindOfClass:classType]) {
                            success(WYRequestTypeSuccess, nil, YES, cacheObject);
                        }
                    }
                }
            } else {
                success(WYRequestTypeSuccess, nil, YES, cacheObject);
            }
        }
    }
    
    NSURLSessionDataTask *task = [manager POST:requestURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"\nPOST url = %@\n",task.currentRequest.URL);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //[self handleResponseObject:responseObject];
        }
        NSString *message = nil;
        NSInteger status = WYRequestTypeFailed;
        id responseDataObject = nil;
        if (responseObject) {
            message = [responseObject objectForKey:kResponseObjectKeyResult];
            NSNumber* statusCode = [responseObject objectForKey:kResponseObjectKeyCode];
            if (statusCode) {
                status = statusCode.integerValue;
            }
            responseDataObject = responseObject[kResponseObjectKeyObject];
            //此处有两种情况发生，正常的是json，非正常是一个常规string
            if ([responseDataObject isKindOfClass:[NSString class]]) {
                NSData *data = [responseDataObject dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                responseDataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }
        }
        
        if (success) {
            if ([WYNetWorkExceptionHandling judgeReuqestStatus:status URLString:URLString] && classType && responseDataObject) {
                if ([responseDataObject isKindOfClass:[NSArray class]]) {
                    
                    NSArray *array = [NSArray modelArrayWithClass:classType json:responseDataObject];
                    
                    if (needCache) {
                        [cache setObject:array forKey:URLString];
                    }
                    success(status,message,NO,array);
                } else {
                    NSDictionary *dic = [NSDictionary modelDictionaryWithClass:classType json:responseObject];
                    
                    id model = dic[kResponseObjectKeyObject];
                    
                    if (needCache) {
                        [cache setObject:model forKey:URLString];
                        
                    }
                    success(status,message,NO,model);
                }
            } else {
                
                success(status,message,NO,responseDataObject);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure error: %@",error);
        if (failure) {
            failure(nil, error);
        }
    }];
    
    return task;
}

- (void)POST:(NSString *)URLString
formFileName:(NSString *)formFileName
    fileName:(NSString *)fileName
    fileData:(NSData *)fileData
    mimeType:(NSString *)mimeType
  parameters:(id )parameters
responseClass:(Class )classType
     success:(WYRequestSuccessBlock)success
     failure:(WYRequestFailureBlock)failure{
    
    if (!fileData) {
        return;
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString outUserId:NO outToken:NO];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:formFileName fileName:fileName mimeType:mimeType];
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *message = nil;
        NSError *parserError = nil;
        NSInteger status = WYRequestTypeFailed;
        NSDictionary *jsonValue = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&parserError];
        id responseDataObject = nil;
        if (jsonValue) {
            message = [jsonValue objectForKey:kResponseObjectKeyResult];
            NSNumber* statusCode = [jsonValue objectForKey:kResponseObjectKeyCode];
            if (statusCode) {
                status = statusCode.integerValue;
            }
            responseDataObject = jsonValue[kResponseObjectKeyObject];
            //此处有两种情况发生，正常的是json，非正常是一个常规string
            if ([responseDataObject isKindOfClass:[NSString class]]) {
                NSData *data = [responseDataObject dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                responseDataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }
        }
        
        if (success) {
            if ([WYNetWorkExceptionHandling judgeReuqestStatus:status URLString:URLString] && classType && responseDataObject) {
                if ([responseDataObject isKindOfClass:[NSArray class]]) {
                    
                    NSArray *array = [NSArray modelArrayWithClass:classType json:responseDataObject];
                    
                    
                    success(status,message,NO,array);
                } else {
                    NSDictionary *dic = [NSDictionary modelDictionaryWithClass:classType json:responseObject];
                    
                    id model = dic[kResponseObjectKeyObject];
                    
                    
                    success(status,message,NO,model);
                }
            } else {
                
                success(status,message,NO,responseDataObject);
            }
        }
    }];
    
    [uploadTask resume];
}

#pragma mark --- Utils Method

-(void)setHttpHeader:(AFHTTPSessionManager*) manger
{
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain",[NSString stringWithFormat:@"version/%@",app_Version], nil];
}

- (NSString *)urlStringAddCommonParamForSourceURLString:(NSString *)urlString outUserId:(BOOL)outUserId outToken:(BOOL)outToken
{
    if (!urlString) {
        return nil;
    }
    
    NSMutableString *addString = [NSMutableString string];
    //添加uid
    NSString *uid = nil;
    if (![urlString containsString:kParamUserInfoUID] && uid && !outUserId) {
        [addString appendFormat:@"%@=%@", kParamUserInfoUID, uid];
    }
    
    //添加token
    NSString *token = nil;
    if (![urlString containsString:kParamUserInfoAuthToken] && token && !outToken) {
        [addString appendFormat:@"&%@=%@", kParamUserInfoAuthToken, token];
    }
    
    NSString *resultUrlString = [urlString stringByAppendingString:addString];
    return resultUrlString;
}

@end
