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
    [self setHttpHeader:manager needHeaderAuth:NO];
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
        
        LELog(@"\n url = %@\n responseObject=%@",task.currentRequest.URL,responseObject);
        
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
        LELog(@"failure error: %@",error);
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
                needHeaderAuth:(BOOL)needHeaderAuth
                       success:(WYRequestSuccessBlock)success
                       failure:(WYRequestFailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlPath = [[NSURL URLWithString:URLString] path];
    if ([urlPath isEqualToString:@"/api/user/SaveUserDetail"]) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
//    manager.securityPolicy.allowInvalidCertificates = YES;
    [self setHttpHeader:manager needHeaderAuth:needHeaderAuth];
    
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString outUserId:NO outToken:NO];
    LELog(@"POST  url   %@",requestURLString);
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
        
        LELog(@"\nPOST url = %@\n responseObject=%@",task.currentRequest.URL,responseObject);
        
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
            if (!message && status != WYRequestTypeSuccess) {
                message = responseObject[kResponseObjectKeyObject];
                if (message.length > 0) {
                    [WYNetWorkExceptionHandling showProgressHUDWith:message URLString:URLString];
                }
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
        LELog(@"failure error: %@",error);
        
        NSInteger statusCode = [error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        if (statusCode != WYRequestTypeUnauthorized) {
            [SVProgressHUD showCustomErrorWithStatus:HitoFaiNetwork];
        }
        [WYNetWorkExceptionHandling judgeReuqestStatus:statusCode URLString:URLString];
        if (failure) {
            failure(nil, error);
        }
    }];
    
    return task;
}

- (void)POST:(NSString *)URLString
formFileName:(NSString *)formFileName
    fileName:(NSString *)fileName
    fileData:(NSArray *)fileData
    mimeType:(NSString *)mimeType
  parameters:(id )parameters
responseClass:(Class )classType
     success:(WYRequestSuccessBlock)success
    progress:(WYRequestProgressBlock)progress
     failure:(WYRequestFailureBlock)failure{
    
    if (!fileData) {
        return;
    }
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
//    AFHTTPResponseSerializer
    AFJSONResponseSerializer *jsonReponseSerializer = [AFJSONResponseSerializer serializer];
    jsonReponseSerializer.acceptableContentTypes = nil;
    manager.responseSerializer = jsonReponseSerializer;
    
    NSString *requestURLString = [self urlStringAddCommonParamForSourceURLString:URLString outUserId:NO outToken:NO];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSData *data in fileData) {
            [formData appendPartWithFileData:data name:formFileName fileName:fileName mimeType:mimeType];
        }
    } error:nil];
    //将Token封装入请求头
    if ([LELoginUserManager authToken]) {
        //        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",[LELoginUserManager authToken]];
        [request setValue:authorization forHTTPHeaderField:@"Authorization"];
//        [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    }
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *message = nil;
//        NSError *parserError = nil;
        NSInteger status = WYRequestTypeFailed;
//        NSDictionary *jsonValue = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&parserError];
        LELog(@"\nPOST url = %@\n responseObject=%@",response.URL,responseObject);
        id responseDataObject = nil;
        if (responseObject) {
            message = [responseObject objectForKey:kResponseObjectKeyResult];
            NSNumber* statusCode = [responseObject objectForKey:kResponseObjectKeyCode];
            if (statusCode) {
                status = statusCode.integerValue;
            }
            
            if (!message && status != WYRequestTypeSuccess) {
                message = responseObject[kResponseObjectKeyObject];
                if (message.length > 0) {
                    [WYNetWorkExceptionHandling showProgressHUDWith:message URLString:URLString];
                }
            }
            
            responseDataObject = responseObject[kResponseObjectKeyObject];
            //此处有两种情况发生，正常的是json，非正常是一个常规string
            if ([responseDataObject isKindOfClass:[NSString class]]) {
//                NSData *data = [responseDataObject dataUsingEncoding:NSUTF8StringEncoding];
//                NSError *error = nil;
//                responseDataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
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

-(void)setHttpHeader:(AFHTTPSessionManager*)manger needHeaderAuth:(BOOL)needHeaderAuth
{
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"html/json",@"text/plain",[NSString stringWithFormat:@"version/%@",app_Version], nil];
    
    
    //将Token封装入请求头
    if ([LELoginUserManager authToken] && needHeaderAuth) {
        NSString *authorization = [NSString stringWithFormat:@"Bearer %@",[LELoginUserManager authToken]];
        [manger.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
        
    }
    
}

- (NSString *)urlStringAddCommonParamForSourceURLString:(NSString *)urlString outUserId:(BOOL)outUserId outToken:(BOOL)outToken
{
    if (!urlString) {
        return nil;
    }
    
    NSMutableString *addString = [NSMutableString string];
    //添加uid
    NSString *uid = [LELoginUserManager userID];
    uid = nil;
    if (![urlString containsString:kParamUserInfoUID] && uid && !outUserId) {
        [addString appendFormat:@"%@=%@", kParamUserInfoUID, uid];
    }
    
    //添加token
    NSString *token = [LELoginUserManager authToken];
    token = nil;
    if (![urlString containsString:kParamUserInfoAuthToken] && token && !outToken) {
        [addString appendFormat:@"&%@=%@", kParamUserInfoAuthToken, token];
    }
    
    NSString *resultUrlString = [urlString stringByAppendingString:addString];
    return resultUrlString;
}

#pragma mark - App Store 版本号
- (void)checkUpdateWithAppID:(NSString *)appID success:(void (^)(NSDictionary *resultDic , BOOL isNewVersion ,NSString * newVersion , NSString * currentVersion))success failure:(void (^)(NSError *error))failure{

    success(nil,YES, nil,nil);
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//
//    //1404835477 乐资讯
//    NSString *encodingUrl = [[@"http://itunes.apple.com/cn/lookup?id=" stringByAppendingString:Itunes_APPID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//1113268900
//
//    [manager GET:encodingUrl parameters:nil progress:^(NSProgress *_Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//
//        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//        //获取AppStore的版本号
//        NSString *versionStr = @"0.0.0";
//        NSArray *results = [resultDic objectForKey:@"results"];
//        if (results.count > 0) {
//            versionStr = [[results objectAtIndex:0] valueForKey:@"version"];
//        }
//
//        NSString *versionStr_int = [versionStr stringByReplacingOccurrencesOfString:@"."withString:@""];
//        int version = [versionStr_int intValue];
//        //获取本地的版本号
//        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
//        NSString * currentVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
//
//        NSString *currentVersion_int=[currentVersion stringByReplacingOccurrencesOfString:@"."withString:@""];
//        int current = [currentVersion_int intValue];
//
//        if(current > version){
//            success(resultDic,YES, versionStr,currentVersion);
//        }else{
//            success(resultDic,NO ,versionStr,currentVersion);
//        }
//    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        failure(error);
//    }];
}

@end
