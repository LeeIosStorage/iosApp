//
//  UIImage+ProportionalFill.h
//
//  Created by Matt Gemmell on 20/08/2008.
//  Copyright 2008 Instinctive Code.
//

#import <UIKit/UIKit.h>

@interface UIImage (MGProportionalFill)

typedef enum {
    MGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} MGImageResizingMethod;

- (UIImage *)imageToFitSize:(CGSize)size method:(MGImageResizingMethod)resizeMethod;
- (UIImage *)imageCroppedToFitSize:(CGSize)size; // uses MGImageResizeCrop
- (UIImage *)imageScaledToFitSize:(CGSize)size; // uses MGImageResizeScale

- (UIImage *)coreWithBlurNumber:(CGFloat)blur;

/**
 *  压缩图片到指定大小并且返回图片数据
 *
 *  @param maxFileSize 指定大小
 *
 *  @return 图片数据
 */
- (NSData *)compressionImageToDataWithMaxFileSize:(NSInteger)maxFileSize;
- (NSData *)compressionImageToDataTargetWH:(CGFloat)targetWH maxFileSize:(NSInteger)maxFileSize;

+ (NSData *)imageData:(UIImage *)myimage;

@end
