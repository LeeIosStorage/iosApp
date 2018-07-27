//
//  WYAPIGenerate.m
//  WangYu
//
//  Created by Leejun on 2017/10/16.
//  Copyright © 2017年 KID. All rights reserved.
//

#import "WYAPIGenerate.h"

NSString* const kNetworkHostCacheKey = @"kNetworkHostCacheKey";

static NSString* const apiFileName = @"NetWorkConfig";
static NSString* const apiFileExtension = @"json";

@interface WYAPIGenerate ()
{
    NSDictionary * cachedDictionary;
}
@end

@implementation WYAPIGenerate

+ (WYAPIGenerate *)sharedInstance
{
    static WYAPIGenerate *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (NSDictionary *)apiDictionary
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:apiFileName ofType:apiFileExtension];
    if (!filePath) {
        
    }
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return dic;
}

- (void)setNetWorkHost:(NSString *)netWorkHost
{
    _netWorkHost = netWorkHost;
    if ([_netWorkHost isEqualToString:defaultNetworkHost]) {
        self.baseWebUrl = [NSString stringWithFormat:@"%@://%@",self.defaultProtocol,defaultWebHost];
    } else if ([_netWorkHost isEqualToString:defaultNetworkPreRelease]) {
        self.baseWebUrl = [NSString stringWithFormat:@"%@://%@",self.defaultProtocol,defaultWebPreRelease];
    } else if ([_netWorkHost isEqualToString:defaultNetworkHostTest]) {
        self.baseWebUrl = [NSString stringWithFormat:@"%@://%@",self.defaultProtocol,defaultWebHostTest];
    }
}

- (NSString *)defaultProtocol {
    if (!_defaultProtocol) {
        return @"http";
    }
    return _defaultProtocol;
}

- (NSString *)baseURL{
    const NSString *host = self.netWorkHost;
    return [NSString stringWithFormat:@"%@://%@",self.defaultProtocol,host];
}


- (NSString*)API:(NSString*)apiName
{
    return [self API:apiName urlHost:nil];
    
}

- (NSString*)API:(NSString*)apiName urlHost:(NSString *)urlHost{
    
    if (!apiName || apiName.length == 0) {
        return nil;
    }
    NSDictionary* configDict = nil;
    if (!cachedDictionary) {
        configDict = [[self class] apiDictionary];
    }else {
        configDict = cachedDictionary;
    }
    
    NSDictionary *dic = [configDict objectForKey:apiName];
    NSString* apiProtocol = nil;
    if (!self.netWorkHost) {
        self.netWorkHost = defaultNetworkHost;
    }
    const NSString *host = self.netWorkHost;
    
    apiProtocol=[dic objectForKey:@"protocol"] ? [dic objectForKey:@"protocol"]:@"http";
    if ([apiProtocol isEqual:@"http"]) {
        host = self.netWorkHost;
    }
    
    if (urlHost.length > 0) {
        host = urlHost;
    }
    
    //拼接主机地址
    NSString *apiUrl = [NSString stringWithFormat:@"%@://%@",apiProtocol,host];
    ///拼接路径
    NSString *module = dic[@"module"];
    if (module && ![module isEqual:[NSNull null]]) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@",module];
    }
    
    NSString *control = dic[@"control"];
    if (control && ![control isEqual:[NSNull null]]) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", control];
    }
    
    NSString *action = dic[@"action"];
    if (action && ![action isEqual:[NSNull null]]) {
        apiUrl = [apiUrl stringByAppendingFormat:@"/%@", action];
    }
    
    apiUrl = [apiUrl stringByAppendingString:@"?"];
    
    return apiUrl;
    
}

@end
