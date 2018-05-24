//
//  WYShareManager.h
//  WangYu
//
//  Created by KID on 15/5/19.
//  Copyright (c) 2015年 KID. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"

typedef void(^WYWeiboShareResultBlock)(WBSendMessageToWeiboResponse *response);
@protocol WXShaerStateDelegate;

@interface WYShareManager : NSObject <WXApiDelegate,WeiboSDKDelegate,QQApiInterfaceDelegate>

@property(nonatomic, strong) WBSendMessageToWeiboResponse* shareResponse;
+ (WYShareManager*)shareInstance;

//分享到微信
- (BOOL)shareToWXWithScene:(int)scene title:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl image:(UIImage*)image isVideo:(BOOL)isVideo;
//分享到微博
- (void)shareToWb:(WYWeiboShareResultBlock)result title:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl image:(UIImage*)image VC:(id)VC isVideo:(BOOL)isVideo;
//分享到QQ
- (void)shareToQQTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl image:(UIImage*)image isVideo:(BOOL)isVideo;
//分享图片到微信
- (BOOL)shareToWXWithImage:(UIImage *)wxImage scene:(int)scene;
//分享图片到QQ
- (void)shareToQQWithImage:(UIImage *)qqImage;
@property (weak, nonatomic) id<WXShaerStateDelegate> delegate;
@end

@protocol WXShaerStateDelegate <NSObject>
@optional
- (void)sendState:(int)state;

@end
