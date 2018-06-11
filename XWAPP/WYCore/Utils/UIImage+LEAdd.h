//
//  UIImage+LEAdd.h
//  XWAPP
//
//  Created by hys on 2018/5/16.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LEAdd)

- (UIImage *)imageCompressForTargetSize:(CGSize)size;

//颜色生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
