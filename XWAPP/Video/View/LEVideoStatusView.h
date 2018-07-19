//
//  LEVideoStatusView.h
//  XWAPP
//
//  Created by hys on 2018/7/17.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AvatarClickBlock)(void);
typedef void(^AttentionClickBlock)(void);
typedef void(^CommentClickBlock)(void);
typedef void(^ShareClickBlock)(void);

@interface LEVideoStatusView : UIView

@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (copy, nonatomic) AvatarClickBlock avatarClickBlock;
@property (copy, nonatomic) AttentionClickBlock attentionClickBlock;
@property (copy, nonatomic) CommentClickBlock commentClickBlock;
@property (copy, nonatomic) ShareClickBlock shareClickBlock;

- (void)updateWithData:(id)data;

@end
