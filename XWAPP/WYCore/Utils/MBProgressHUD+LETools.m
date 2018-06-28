//
//  MBProgressHUD+LETools.m
//  XWAPP
//
//  Created by hys on 2018/6/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "MBProgressHUD+LETools.h"

@implementation MBProgressHUD (LETools)

+ (void)showCustomGoldTipWithTask:(NSString *)task gold:(NSString *)gold{
    
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [MBProgressHUD hideHUDForView:view animated:NO];
    
    //自定义view
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = HitoRGBA(0,0,0,0.7);;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.minSize = CGSizeMake(132, 164);
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 132, 164)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"le_task_gold_tip"]];
    imageView.frame = CGRectMake(0, 164-114, 132, 114);
    [customView addSubview:imageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, 132-10, 20)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = HitoPFSCRegularOfSize(16);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = task;
    [customView addSubview:tipLabel];
    
    UILabel *goldLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 132-10, 35)];
    goldLabel.textColor = [UIColor colorWithHexString:@"ffce0a"];
    goldLabel.font = HitoPFSCRegularOfSize(30);
    goldLabel.textAlignment = NSTextAlignmentCenter;
    goldLabel.text = gold;
    [customView addSubview:goldLabel];
    
    [hud.bezelView addSubview:customView];
    
    hud.removeFromSuperViewOnHide = YES;
    NSTimeInterval delay = 1.5;
    [hud hideAnimated:YES afterDelay:delay];
    
}

@end
