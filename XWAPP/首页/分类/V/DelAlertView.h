//
//  DelAlertView.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DelAlertViewShieldClickBlock)(NSArray *reasons);

@interface DelAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (assign, nonatomic) NSInteger count;

@property (copy, nonatomic) DelAlertViewShieldClickBlock delAlertViewShieldClickBlock;

@end
