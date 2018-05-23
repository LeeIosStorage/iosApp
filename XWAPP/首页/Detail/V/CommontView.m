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

@property (weak, nonatomic) IBOutlet UILabel *textViewPlaceholderLabel;

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
    
    if (textView.text.length > 0) {
        self.textViewPlaceholderLabel.hidden = YES;
    }else{
        self.textViewPlaceholderLabel.hidden = NO;
    }
    
    self.textViewText = textView.text;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentWithContentText:)]) {
        [self.delegate commentWithContentText:self.textViewText];
    }
}

@end
