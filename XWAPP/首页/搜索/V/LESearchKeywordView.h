//
//  LESearchKeywordView.h
//  XWAPP
//
//  Created by hys on 2018/6/28.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchKeywordBlcok) (NSString *text);

@interface LESearchKeywordView : UIView

@property (strong, nonatomic) SearchKeywordBlcok searchKeywordBlcok;

@property (strong, nonatomic) NSString *searchText;

- (void)updateViewWithData:(NSArray *)array;

@end
