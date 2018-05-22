//
//  CommontHFView.h
//  XWAPP
//
//  Created by hys on 2018/5/11.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LECommontViewWithSendBlcok)(NSString *message);

@interface CommontHFView : UIView

@property (weak, nonatomic) IBOutlet UITextField *hufuTF;

@property (copy, nonatomic) LECommontViewWithSendBlcok commontViewWithSendBlcok;

@end
