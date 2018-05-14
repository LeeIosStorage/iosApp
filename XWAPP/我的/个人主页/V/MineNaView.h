//
//  MineNaView.h
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBlock)(void);
typedef void(^RightBlock)(void);

@interface MineNaView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (nonatomic, copy) LeftBlock leftBlock;
@property (nonatomic, copy) RightBlock rightBlock;

- (void)btnActionLeft:(LeftBlock)leftBlock;
- (void)btnActionRight:(RightBlock)rightBlock;

@end
