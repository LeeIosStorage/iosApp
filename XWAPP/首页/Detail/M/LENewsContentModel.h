//
//  LENewsContentModel.h
//  XWAPP
//
//  Created by hys on 2018/5/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEElementStyleBox.h"

@interface LENewsContentModel : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *videoUrl;

@property (strong, nonatomic) LEElementStyleBox *styleBox;

@end
