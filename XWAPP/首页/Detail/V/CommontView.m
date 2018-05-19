//
//  CommontView.m
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "CommontView.h"

@interface CommontView ()
<
UITextViewDelegate
>

@property (strong, nonatomic) NSString *textViewText;

@end

@implementation CommontView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.comTextView.delegate = self;
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)cancelAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentWithCancelClick)]) {
        [self.delegate commentWithCancelClick];
    }
}

- (IBAction)sureAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentWithSendClick:)]) {
        [self.delegate commentWithSendClick:self.textViewText];
    }
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidChange:(UITextView *)textView{
    self.textViewText = textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentWithContentText:)]) {
        [self.delegate commentWithContentText:self.textViewText];
    }
}

@end
