//
//  SearchHeader.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Click)(void);

@interface SearchHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic, copy) Click click;

- (void)clickBtn:(Click)click;

@end
