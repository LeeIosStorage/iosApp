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

@implementation DetailController (ContentControl)

- (void)parserContentWithHtmlString:(NSString *)htmlString handleSuccessBlcok:(handleSuccessBlock)successBlock{
    
    __block NSMutableAttributedString *contentAttributed = [[NSMutableAttributedString alloc] init];
    
    self.imageItemsArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableParagraphStyle *paragraphStyle = [self getParagraphStyleByCustom];
    
    NSData *htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements = [xpathParser searchWithXPathQuery:@"//p"];
    
    HitoWeakSelf;
    [elements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TFHppleElement class]]) {
            
            LENewsContentModel *contentModel = [[LENewsContentModel alloc] init];
            //先预留设置信息
            LEElementStyleBox *box = [LEElementStyleBox createBox];
            
            TFHppleElement *element = (TFHppleElement *)obj;
            NSArray *childrenArray = element.children;
//            TFHppleElement *firstChildren = element.firstChild;
            
            NSMutableAttributedString *childAttributed = nil;
            for (TFHppleElement *childrenElement in childrenArray) {
                childAttributed = nil;
                if ([[childrenElement content] length] > 0) {
                    if ([[[childrenElement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0) {
                        
                        //兼容标签重复解析的错误
                        if ([WeakSelf.beforeContent isEqualToString:[childrenElement content]]) {
                            break;
                        }
                        
                        childAttributed = [WeakSelf mosaicContentWithContent:[childrenElement content]];
                        WeakSelf.beforeContent = [childrenElement content];
                        
                    }else{
                        NSLog(@"is white space");
                        break;
                    }
                }
                if ([childrenElement.tagName isEqualToString:TagImage_Key]) {
//                    NSString *altString = [childrenElement objectForKey:Alt_key];
//                    NSString *dataSize = [childrenElement objectForKey:DataSize_key];
                    NSString *dataImgUrl = [childrenElement objectForKey:DataImageUrl_key];
                    
                    [box setPropertyWithStyleDic:childrenElement.attributes];
//                    contentModel.content = altString;
                    contentModel.imageUrl = dataImgUrl;
                    contentModel.styleBox = box;
                    
                    childAttributed = [WeakSelf mosaicImageAndVideoWithContentModel:contentModel];
                    
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
    contentAttributedString.font = [UIFont systemFontOfSize:16.0f];
    contentAttributedString.alignment = NSTextAlignmentLeft;
    
    [attributedText appendAttributedString:contentAttributedString];
    [attributedText appendString:@"\n"];
    
    return attributedText;
    
}

- (NSMutableAttributedString *)mosaicImageAndVideoWithContentModel:(LENewsContentModel *)contentModel{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    if (contentModel.content.length > 0) {
        NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc] initWithString:contentModel.content];
        contentAttributedString.color = kAppTitleColor;
        contentAttributedString.font = [UIFont systemFontOfSize:16.0f];
        contentAttributedString.alignment = NSTextAlignmentLeft;
        [attributedText appendAttributedString:contentAttributedString];
    }
    if (contentModel.imageUrl.length > 0) {
        UIView *bgView = [UIView new];
        bgView.backgroundColor = [UIColor clearColor];
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
        CGFloat scale = contentModel.styleBox.height/contentModel.styleBox.width;
        contentModel.styleBox.width = imageStandardWidth;
        contentModel.styleBox.height = imageStandardWidth*scale;
        imageView.size = CGSizeMake(contentModel.styleBox.width, contentModel.styleBox.height);
        
        imageView.userInteractionEnabled = YES;
        [WYCommonUtils setImageWithURL:[NSURL URLWithString:contentModel.imageUrl] setImage:imageView setbitmapImage:[UIImage imageWithColor:[UIColor colorWithRed:227.f / 255.f green:227.f / 255.f blue:227.f / 255.f alpha:1.f]]];
        
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
        contentHeight = 50.f;
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
