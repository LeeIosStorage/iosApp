//
//  TagHeaderView.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnBlock)(UIButton *btn);

@interface TagHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, copy) BtnBlock btnBlock;

- (void)action:(BtnBlock)btnBlock;

@end
