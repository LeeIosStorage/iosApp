//
//  CommontHFView.m
//  XWAPP
//
//  Created by hys on 2018/5/11.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "CommontHFView.h"

@interface CommontHFView ()
<
UITextFieldDelegate
>

@end

@implementation CommontHFView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.hufuTF.delegate = self;
}

- (IBAction)sendAction:(id)sender{
    if (self.commontViewWithSendBlcok) {
        self.commontViewWithSendBlcok(self.hufuTF.text);
    }
}

@end
