//
//  DetailController.h
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"
#import "LENewsDetailModel.h"

typedef void(^handleSuccessBlock)(NSMutableAttributedString *attributedString);

@interface DetailController : LESuperViewController

@property (strong, nonatomic) NSString *newsId;

@property (strong, nonatomic) LENewsDetailModel *newsDetailModel;

@property (strong, nonatomic) NSString        *beforeContent;
///大图数组
@property (strong, nonatomic) NSMutableArray  *imageItemsArray;

@property (assign, nonatomic) BOOL isFromPush;

- (instancetype)initWithNewsId:(NSString *)newsId;

- (void)showImageDetailWithImageView:(YYAnimatedImageView *)imageView;

@end

@interface DetailController (ContentControl)

- (void)parserContentWithHtmlString:(NSString *)htmlString handleSuccessBlcok:(handleSuccessBlock)successBlock;

- (CGFloat)getAttributedStringHeightWithString:(NSMutableAttributedString *)attributedString;

@end
