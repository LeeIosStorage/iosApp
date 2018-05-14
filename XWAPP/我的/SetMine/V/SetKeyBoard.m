//
//  SetKeyBoard.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SetKeyBoard.h"

@implementation SetKeyBoard

- (IBAction)clickSure:(UIButton *)sender {
    _sure();
}

- (IBAction)clickCancel:(UIButton *)sender {
    _cancel();
}

- (void)clickCancelBlock:(Cancel)cancel {
    _cancel = cancel;
}

- (void)clickSureBlock:(Sure)sure {
    _sure = sure;
}
@end
