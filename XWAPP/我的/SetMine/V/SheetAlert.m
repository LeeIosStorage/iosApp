//
//  SheetAlert.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SheetAlert.h"

@implementation SheetAlert

- (IBAction)albumAction:(UIButton *)sender {
    _album();
}

- (IBAction)cameraAction:(UIButton *)sender {
    _camera();
}

- (IBAction)cancelAction:(UIButton *)sender {
    _cancel();
}

- (void)clickCancel:(Cancel)cancel {
    _cancel = cancel;
}
- (void)clickCamera:(Camera)camera {
    _camera = camera;
}
- (void)clickAlbum:(Album)album {
    _album = album;
}

@end
