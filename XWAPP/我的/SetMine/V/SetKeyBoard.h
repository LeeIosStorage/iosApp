//
//  SetKeyBoard.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^Cancel)(void);
typedef void(^Sure)(void);

@interface SetKeyBoard : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (nonatomic, copy) Cancel cancel;
@property (nonatomic, copy) Sure sure;

- (void)clickCancelBlock:(Cancel)cancel;
- (void)clickSureBlock:(Sure)sure;

@end

