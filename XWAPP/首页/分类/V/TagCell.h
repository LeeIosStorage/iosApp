//
//  TagCell.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^RightAction)(UIButton *btn);


@interface TagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (nonatomic, copy) RightAction rightBlock;

- (void)rightAction:(RightAction)rightBlock;

@end
