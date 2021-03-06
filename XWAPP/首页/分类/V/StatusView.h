//
//  StatusView.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/24.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LENewsListModel.h"

typedef void(^DeleBlock)(void);

@interface StatusView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelCollectButton;

@property (nonatomic, copy) DeleBlock deleeBlock;

- (void)deleblockAction:(DeleBlock)deleblock;

- (void)updateSourceConstraints:(NSInteger)type;

- (void)updateCellWithData:(LENewsListModel *)newsModel;

@end
