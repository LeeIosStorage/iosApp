//
//  MineHeader.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineBottom.h"


typedef void(^LeftClick)(void);
typedef void(^CenterClick)(void);

@interface MineHeader : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allBottomViewTop;
@property (weak, nonatomic) IBOutlet MineBottom *leftMine;
@property (weak, nonatomic) IBOutlet MineBottom *centerMine;
@property (weak, nonatomic) IBOutlet MineBottom *rightMine;
@property (weak, nonatomic) IBOutlet UIImageView *backIM;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minImageBottom;

@property (nonatomic, copy) LeftClick leftClick;
@property (nonatomic, copy) CenterClick centerClick;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerBigView;

- (void)leftClickAction:(LeftClick)leftClick;
- (void)centerClickAction:(CenterClick)centerClick;

@end
