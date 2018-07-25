//
//  DetailController+ContentControl.m
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "DetailController.h"
#import "TFHpple.h"
#import "LENewsContentModel.h"

#define imageStandardWidth (HitoScreenW - 24)

#define TagImage_Key      @"img"
#define Alt_key           @"alt"
#define DataSize_key      @"data-size"
#define DataImageUrl_key  @"data-src"
#define DataImageUrl2_key @"src"
#define TagVideo_key      @"script"

@implementation DetailController (ContentControl)

- (void)parserContentWithHtmlString:(NSString *)htmlString handleSuccessBlcok:(handleSuccessBlock)successBlock{
    
    __block NSMutableAttributedString *contentAttributed = [[NSMutableAttributedString alloc] init];
    
    if (htmlString.length == 0) {
        successBlock(contentAttributed);
        return;
    }
    
    self.imageItemsArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tmpImageArray = [NSMutableArray array];
    
    NSMutableParagraphStyle *paragraphStyle = [self getParagraphStyleByCustom];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [xpathParser searchWithXPathQuery:@"//p | //img"];
    
    
    HitoWeakSelf;
    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TFHppleElement class]]) {
            
            TFHppleElement *element = (TFHppleElement *)obj;
            NSMutableArray *childrenArray = [NSMutableArray arrayWithArray:element.children];
            
            //兼容<img />标签  去重
            NSString *dataImgUrl = [element objectForKey:DataImageUrl_key];
            if (dataImgUrl.length == 0) {
                dataImgUrl = [element objectForKey:DataImageUrl2_key];
            }
            if (childrenArray.count == 0 && [element.tagName isEqualToString:TagImage_Key] && ![tmpImageArray containsObject:dataImgUrl] && dataImgUrl.length > 0) {
                [childrenArray addObject:element];
            }
            
            NSMutableAttributedString *childAttributed = nil;
            for (TFHppleElement *childrenElement in childrenArray) {
                childAttributed = nil;
                //文字解析
                if ([[childrenElement content] length] > 0) {
                    if ([[[childrenElement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0) {
                        
                        //换行不显示
                        if ([[childrenElement content] isEqualToString:@"\n"]) {
                            continue;
                        }
                        //兼容标签重复解析的错误
                        if ([WeakSelf.beforeContent isEqualToString:[childrenElement content]]) {
                            continue;
                        }
                        
                        childAttributed = [WeakSelf mosaicContentWithContent:[childrenElement content]];
                        WeakSelf.beforeContent = [childrenElement content];
                        
                    }else{
//                        NSLog(@"is white space!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                        continue;
                    }
                }
                //图片解析
                if ([childrenElement.tagName isEqualToString:TagImage_Key]) {
                    
                    LENewsContentModel *contentModel = [[LENewsContentModel alloc] init];
                    LEElementStyleBox *box = [LEElementStyleBox createBox];
                    NSString *dataImgUrl = [childrenElement objectForKey:DataImageUrl_key];
                    if (dataImgUrl.length == 0) {
                        dataImgUrl = [childrenElement objectForKey:DataImageUrl2_key];
                    }
                    
                    [box setPropertyWithStyleDic:childrenElement.attributes];
//                    contentModel.content = altString;
                    contentModel.imageUrl = dataImgUrl;
                    contentModel.styleBox = box;
                    
                    if (contentModel.imageUrl.length > 0) {
                        [tmpImageArray addObject:contentModel.imageUrl];
                    }
                    
                    childAttributed = [WeakSelf mosaicImageAndVideoWithContentModel:contentModel];
                    
                }
                //视频解析
                if ([childrenElement.tagName isEqualToString:TagVideo_key]) {
                    
                }
                
                if (childAttributed) {
                    NSRange childRange = NSMakeRange(contentAttributed.length, childAttributed.length);
                    [contentAttributed appendAttributedString:childAttributed];
                    [contentAttributed addAttribute:NSParagraphStyleAttributeName value:(id)paragraphStyle range:childRange];
                }
            }
            
            if ([elements lastObject] == obj) {
                successBlock(contentAttributed);
                *stop = YES;
            }
        }
    }];
}

- (NSMutableAttributedString *)mosaicContentWithContent:(NSString *)content{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:content];
    contentAttributedString.color = kAppTitleColor;
    contentAttributedString.font = [UIFont systemFontOfSize:18.0f];
    contentAttributedString.alignment = NSTextAlignmentLeft;
    
    [attributedText appendAttributedString:contentAttributedString];
    [attributedText appendString:@"\n"];
    
    return attributedText;
    
}

- (NSMutableAttributedString *)mosaicImageAndVideoWithContentModel:(LENewsContentModel *)contentModel{
    
    NSMutableAttributedString *attributedText = nil;
    
//    if (contentModel.content.length > 0) {
//        if (!attributedText) {
//            attributedText = [[NSMutableAttributedString alloc] init];
//        }
//        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:contentModel.content];
//        contentAttributedString.color = kAppTitleColor;
//        contentAttributedString.font = [UIFont systemFontOfSize:16.0f];
//        contentAttributedString.alignment = NSTextAlignmentLeft;
//        [attributedText appendAttributedString:contentAttributedString];
//    }
    if (contentModel.imageUrl.length > 0) {
        if (!attributedText) {
            attributedText = [[NSMutableAttributedString alloc] init];
        }
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor clearColor];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        CGFloat scale = contentModel.styleBox.height/contentModel.styleBox.width;
        if (isnan(scale)) {
            scale = 0.5;
        }
        contentModel.styleBox.width = imageStandardWidth;
        contentModel.styleBox.height = imageStandardWidth*scale;
        imageView.size = CGSizeMake(contentModel.styleBox.width, contentModel.styleBox.height);
        
        imageView.userInteractionEnabled = YES;
//        [WYCommonUtils setImageWithURL:[NSURL URLWithString:contentModel.imageUrl] setImage:imageView setbitmapImage:[UIImage imageWithColor:[UIColor colorWithRed:227.f / 255.f green:227.f / 255.f blue:227.f / 255.f alpha:1.f]]];
        [imageView setImageWithURL:[NSURL URLWithString:contentModel.imageUrl] placeholder:[UIImage imageWithColor:[UIColor colorWithRed:227.f / 255.f green:227.f / 255.f blue:227.f / 255.f alpha:1.f]] options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            
        }];
        
        HitoWeakSelf;
        [self.imageItemsArray addObject:contentModel];
        imageView.tag = self.imageItemsArray.count - 1 + 10;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [WeakSelf showImageDetailWithImageView:imageView];
        }];
        [imageView addGestureRecognizer:tap];
        
        bgView.frame = CGRectMake(0, 0, imageStandardWidth, imageView.size.height);
        [bgView addSubview:imageView];
        imageView.center = bgView.center;
        
        NSMutableAttributedString *imageAttributed = [NSMutableAttributedString attachmentStringWithContent:bgView contentMode:UIViewContentModeCenter attachmentSize:bgView.frame.size alignToFont:[UIFont systemFontOfSize:16.0f] alignment:YYTextVerticalAlignmentCenter];
        
        [attributedText appendAttributedString:imageAttributed];
        [attributedText appendString:@"\n"];
    }
    
    return attributedText;
}

- (CGFloat)getAttributedStringHeightWithString:(NSMutableAttributedString *)attributedString{
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(self.view.frame.size.width, HUGE)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    CGFloat contentHeight = textLayout.textBoundingSize.height;
    self.newsDetailModel.textLayout = textLayout;
    if (contentHeight < 50.f) {
        contentHeight = 10.f;
        return contentHeight;
    }else{
        return contentHeight + 20.f;
    }
    return 0;
}

///整体段落文本设置
- (NSMutableParagraphStyle *)getParagraphStyleByCustom
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.f;
    paragraphStyle.paragraphSpacing = 12.f;
    paragraphStyle.firstLineHeadIndent = 12.0f;///首行缩进
    //文本的左右边距
    paragraphStyle.headIndent = 12.f;
    paragraphStyle.tailIndent = -12.f;
    return paragraphStyle;
}

@end
