//
//  SheetAlert.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Cancel)(void);
typedef void(^Camera)(void);
typedef void(^Album)(void);

@interface SheetAlert : UIView

@property(nonatomic, copy) Cancel cancel;
@property(nonatomic, copy) Camera camera;
@property(nonatomic, copy) Album album;

- (void)clickCancel:(Cancel)cancel;
- (void)clickCamera:(Camera)camera;
- (void)clickAlbum:(Album)album;

@end
