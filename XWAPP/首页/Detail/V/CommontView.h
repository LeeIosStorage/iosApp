//
//  CommontView.h
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommontViewDelegate;

@interface CommontView : UIView

@property (weak, nonatomic) IBOutlet UITextView *comTextView;

@property (weak, nonatomic) id <CommontViewDelegate> delegate;

@end

@protocol CommontViewDelegate <NSObject>
@optional
- (void)commentWithCancelClick;
- (void)commentWithSendClick:(NSString *)text;
- (void)commentWithContentText:(NSString *)text;

@end

