//
//  LEShareSheetView.m
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEShareSheetView.h"
#import "LEShareWindow.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "WYShareManager.h"

@interface LEShareSheetView ()
<
LEShareWindowDelegate
>
{
}
@property (strong, nonatomic) LEShareWindow *shareSheet;

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDescription;
@property (nonatomic, strong) NSString *shareWebpageUrl;
@property (nonatomic, strong) UIImage *shareImage;

@end

@implementation LEShareSheetView

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc
{
//    LELog(@"%s",__func__);
    _owner = nil;
    _shareSheet = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark - Public
- (void)showShareAction{
    
    self.shareSheet.delegate = self;
    [self.shareSheet setCustomerSheet];
    
    [self shareContent];
}

- (void)shareContent{
    self.shareTitle = @"分享测试";
    self.shareDescription = @"测试描述信息";
    self.shareWebpageUrl = @"http://www.baidu.com";
    self.shareImage = nil;
}

#pragma mark -
#pragma mark - Private
-(void)shareToWX:(int)scene{
    [[WYShareManager shareInstance] shareToWXWithScene:WXSceneTimeline title:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage isVideo:_isVideo];
}

- (void)shareToWXTimeline{
    [self shareToWX:WXSceneTimeline];
}

- (void)shareToWXSession{
    [self shareToWX:WXSceneSession];
}

- (void)shareToQQ{
    
    [[WYShareManager shareInstance] shareToQQTitle:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage isVideo:_isVideo];
}

- (void)shareToWeibo{
    
    [[WYShareManager shareInstance] shareToWb:^(WBSendMessageToWeiboResponse *response) {
        
    } title:self.shareTitle description:self.shareDescription webpageUrl:self.shareWebpageUrl image:self.shareImage VC:_owner isVideo:_isVideo];
}

#pragma mark -
#pragma mark - Set And Getters
- (LEShareWindow *)shareSheet{
    if (!_shareSheet) {
        _shareSheet = [[LEShareWindow alloc] init];
        _shareSheet.delegate = self;
    }
    return _shareSheet;
}

#pragma mark -
#pragma mark - LEShareWindowDelegate
-(void)shareWindowClickAt:(NSIndexPath *)indexPath action:(NSString *)action{
    if (action) {
        SEL opAction = NSSelectorFromString(action);
        if ([self respondsToSelector:opAction]) {
            ((void(*)(id,SEL, id,id))objc_msgSend)(self, opAction, nil, nil);
        }
    }
}

@end
