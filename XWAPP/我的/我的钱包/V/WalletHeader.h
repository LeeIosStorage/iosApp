//
//  WalletHeader.h
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBtnAction)(void);
typedef void(^RightBtnAction)(void);


@interface WalletHeader : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (nonatomic, copy) LeftBtnAction leftBlock;
@property (nonatomic, copy) RightBtnAction rightBlock;

- (void)leftBlockAction:(LeftBtnAction)leftBlock;
- (void)rightBlockAction:(RightBtnAction)rightBlock;

@end
