//
//  WYShareManager.m
//  WangYu
//
//  Created by KID on 15/5/19.
//  Copyright (c) 2015年 KID. All rights reserved.
//

#import "WYShareManager.h"

static WYShareManager* wy_shareManager = nil;

@interface WYShareManager (){
    TencentOAuth *_tencentOAuth;
}
@property(nonatomic, strong) WYWeiboShareResultBlock shareBlock;

@end

@implementation WYShareManager

+ (WYShareManager*)shareInstance {
    @synchronized(self) {
        if (wy_shareManager == nil) {
            wy_shareManager = [[WYShareManager alloc] init];
        }
    }
    return wy_shareManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [WXApi registerApp:WX_ID enableMTA:YES];
        
#ifdef DEBUG
        [WeiboSDK enableDebugMode:YES];
#endif
//        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
//            
//        }
        [WeiboSDK registerApp:SINA_ID];
        
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_ID andDelegate:nil];
    }
    return self;
}

- (BOOL)shareToWXWithImage:(UIImage *)wxImage scene:(int)scene{
    if (!([WXApi isWXAppInstalled])) {
        //NSLog(@"not support or not install weixin");
        [SVProgressHUD showCustomInfoWithStatus:@"微信分享失败！"];
        return NO;
    }
    WXMediaMessage *msg = [WXMediaMessage message];
    if (scene == WXSceneTimeline) {
//        msg.description = msg.title;
    }

    NSData *imgData = nil;
    
    if (!wxImage) {
        wxImage = [UIImage imageNamed:@"LOGO"];
    }
    
    if (wxImage) {
        imgData = UIImageJPEGRepresentation(wxImage, 0.1);
        if (imgData.length > MAX_WX_IMAGE_SIZE) {//try again
            imgData = UIImageJPEGRepresentation(wxImage, WY_IMAGE_COMPRESSION_QUALITY/2);
        }
        
    }
    WXImageObject *imageObj = [WXImageObject object];
    NSData *tImageData = UIImageJPEGRepresentation(wxImage, 1);
    if (imgData && imgData.length < MAX_WX_IMAGE_SIZE) {
        [msg setThumbData:imgData];
    }
    imageObj.imageData = tImageData;
    msg.mediaObject = imageObj;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.message = msg;
    req.scene = scene;
    req.bText = NO;
    BOOL ret = [WXApi sendReq:req];
    return ret;
}

- (void)shareToQQWithImage:(UIImage *)qqImage{
    if (!([QQApiInterface isQQInstalled])) {
        [SVProgressHUD showCustomInfoWithStatus:@"QQ分享失败！"];
        return;
    }
    NSData *data;
    data = UIImagePNGRepresentation(qqImage);
    QQApiImageObject *imageObj = [[QQApiImageObject alloc]init];
    NSArray *array = [NSArray array];
    [array arrayByAddingObject:data];
    imageObj.data = data;
    imageObj.previewImageData = data;
    imageObj.imageDataArray = array;
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imageObj];
    [QQApiInterface sendReq:req];
}

- (BOOL)shareToWXWithScene:(int)scene title:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl image:(UIImage*)image isVideo:(BOOL)isVideo{
    
    if (!([WXApi isWXAppInstalled])) {
        //NSLog(@"not support or not install weixin");
        [SVProgressHUD showCustomInfoWithStatus:@"微信分享失败！"];
        return NO;
    } 
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = title;
    msg.description = description;
    
    if (msg.title.length > 512) {
        msg.title = [msg.title substringToIndex:512];
    }
    if (msg.description.length>1024) {
        msg.description = [msg.description substringToIndex:1024];
    }
    
    if (scene == WXSceneTimeline) {
        msg.description = msg.title;
//        if (msg.description.length > 0) {
//            msg.title = [msg.description substringToIndex:MIN(msg.description.length, 512)];
//        }
    }
    
    if (isVideo) {
        //分享视频
        WXVideoObject *video = [WXVideoObject object];
        video.videoUrl = webpageUrl;
        video.videoLowBandUrl = video.videoUrl;
        msg.mediaObject = video;
    }else{
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = webpageUrl;
        msg.mediaObject = ext;
    }
    
    NSData *imgData = nil;
    
    if (!image) {
        image = [UIImage imageNamed:@"LOGO"];
    }
    if (image) {
        imgData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
        if (imgData.length > MAX_WX_IMAGE_SIZE) {//try again
            imgData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY/2);
        }
        
    }
    if (imgData && imgData.length < MAX_WX_IMAGE_SIZE) {
        [msg setThumbData:imgData];
    }else{
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = msg;
    req.scene = scene;
    BOOL ret = [WXApi sendReq:req];
    LELog(@"shareToWX send ret:%d", ret);
    return ret;
}

- (void)shareToWb:(WYWeiboShareResultBlock)result title:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl image:(UIImage*)image VC:(id)VC isVideo:(BOOL)isVideo{
    if (!([WeiboSDK isWeiboAppInstalled])) {
 
        [SVProgressHUD showCustomInfoWithStatus:@"微博分享失败！"];
        return;
    }

    self.shareBlock = result;
    
    //带图片分享
    WBImageObject *msg = [WBImageObject object];
    NSData *imgData = nil;
    if (!image) {
        image = [UIImage imageNamed:@"LOGO"];
    }
    if (image) {
        imgData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
        if (imgData.length > MAX_WX_IMAGE_SIZE) {//try again
            imgData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY/2);
        }
    }
    if (imgData && imgData.length < MAX_WX_IMAGE_SIZE) {
        msg.imageData = imgData;
    }else{
    }
    
    WBMessageObject *sendMsg = [WBMessageObject message];
    NSString* shareTitle = [NSString stringWithFormat:@"%@  %@ %@",title,@"(分享自@乐资讯)",webpageUrl];
    sendMsg.text = shareTitle;
    
    if (imgData) {
        sendMsg.imageObject = msg;
    }
    
    /*****多媒体
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString(title, nil);
    webpage.description = @"O(∩_∩)O哈哈~";
    webpage.thumbnailData = imgData;
    webpage.webpageUrl = webpageUrl;//webpageUrl长度不能超过255
    sendMsg.mediaObject = webpage;
    sendMsg.text = @"O(∩_∩)O哈哈~";
     */
    
    /**视频
    if (isVideo) {
        WBNewVideoObject *videoObject = [WBNewVideoObject object];
        NSURL *videoUrl = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"apm" ofType:@"mov"]];
        videoObject.delegate = self;
        [videoObject addVideo:videoUrl];
        message.videoObject = videoObject;
    }else{
        sendMsg.imageObject = msg;
    }
     */
    
    
    
    //不能SSO分享
//    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest request];
//    request.message = sendMsg;
    
    //SSO分享
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = Sina_RedirectURL;
    authRequest.scope = @"all";
    NSString *vcStr = NSStringFromClass([VC class]);
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:sendMsg authInfo:authRequest access_token:nil];
    request.userInfo = @{@"ShareMessageFrom":vcStr};
    
    BOOL ret = [WeiboSDK sendRequest:request];
    LELog(@"shareToWb send ret:%d", ret);
}

- (void)shareToQQTitle:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl image:(UIImage*)image isVideo:(BOOL)isVideo{
    if (!([QQApiInterface isQQInstalled])) {
        [SVProgressHUD showCustomInfoWithStatus:@"QQ分享失败！"];
        return;
    }
    
    if (title.length > 128) {
        title = [title substringToIndex:128];
    }
    if (description.length>512) {
        description = [description substringToIndex:512];
    }
    
    NSData *imgData = nil;
    if (!image) {
        image = [UIImage imageNamed:@"LOGO"];
    }
    if (image) {
        imgData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
        if (imgData.length > MAX_WX_IMAGE_SIZE/32) {//try again
            imgData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY/2);
        }
    }
    
//    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:title];//分享纯文字
//    QQApiImageObject* contenObj = [QQApiImageObject objectWithData:imgData previewImageData:imgData title:title description:description];//图片分享
    QQApiNewsObject* contenObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webpageUrl] title:title description:description previewImageData:imgData];//链接分享
//    QQApiAudioObject* contenObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:webpageUrl] title:title description:description previewImageData:imgData];
//    contenObj.targetContentType = QQApiURLTargetTypeAudio;
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:contenObj];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    LELog(@"shareToQQ send ret:%d", sent);
}

#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
    }else if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        if (self.shareBlock) {
            self.shareResponse = (WBSendMessageToWeiboResponse *)response;
            self.shareBlock((WBSendMessageToWeiboResponse *)response);
            self.shareResponse = nil;
        }
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            //[WYProgressHUD AlertSuccess:@"分享微博成功"];
            [self shareTaskWithTitle:@"分享微博成功"];
        }else{
            [SVProgressHUD showCustomInfoWithStatus:@"分享微博失败"];
        }
    }
}

#pragma mark - QQApiInterfaceDelegate
- (void)onReq:(QQBaseReq *)req
{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)onResp:(id)resp
{
    if ([resp isKindOfClass:[QQBaseResp class]]) {
        QQBaseReq *resp1 = (QQBaseReq *)resp;
        switch (resp1.type)
        {
            case ESENDMESSAGETOQQRESPTYPE:
            {
                SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp1;
                if ([sendResp.result intValue] == EQQAPISENDSUCESS) {
                    // [WYProgressHUD AlertSuccess:@"分享QQ成功"];
                    [self shareTaskWithTitle:@"分享QQ成功"];
                }else{
                    [SVProgressHUD showCustomInfoWithStatus:@"分享QQ失败"];
                    //                [self performSelector:@selector(shareAlertWithTitle:) withObject:@"分享QQ失败" afterDelay:1.0];
                }
                break;
            }
            default:
            {
                break;
            }
        }
    }else if ([resp isKindOfClass:[BaseResp class]]){
        BaseResp *resp1 = (BaseResp *)resp;
        if([resp1 isKindOfClass:[SendMessageToWXResp class]]){
            
            NSString *strMsg = [NSString stringWithFormat:@"Wx发送消息结果:%d", resp1.errCode];
            NSLog(@"send ret:%@", strMsg);
            switch (resp1.errCode) {
                case WXSuccess:{
                    //                [WYProgressHUD AlertSuccess:@"分享微信成功"];
                    if ([self.delegate respondsToSelector:@selector(sendState:)]){
                        [self.delegate sendState:1];
                    }else{
                      [self shareTaskWithTitle:@"分享微信成功"];
                    }
                }
                    break;
                    
                default:
        
                if ([self.delegate respondsToSelector:@selector(sendState:)]){
                    [self.delegate sendState:2];
                }else{
                    [SVProgressHUD showCustomInfoWithStatus:@"分享微信失败"];
                }
                    break;
            }
        }else if ([resp1 isKindOfClass:[SendAuthResp class]]){
            
        }
    }
    
}
- (void)isOnlineResponse:(NSDictionary *)response{
    
}

#pragma mark - custom
-(void)shareAlertWithTitle:(NSString *)title{
    [SVProgressHUD showCustomInfoWithStatus:title];
}

- (void)shareTaskWithTitle:(NSString *)title{
    [SVProgressHUD showCustomInfoWithStatus:title];
}

@end
