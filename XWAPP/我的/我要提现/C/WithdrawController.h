//
//  WithdrawController.h
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *zfbBtn;

@property (weak, nonatomic) IBOutlet UIButton *wxBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *zfbIM;
@property (weak, nonatomic) IBOutlet UIImageView *wxIM;
@property (weak, nonatomic) IBOutlet UIImageView *leftIM;
@property (weak, nonatomic) IBOutlet UIImageView *centerIM;
@property (weak, nonatomic) IBOutlet UIImageView *rightIM;

@end
