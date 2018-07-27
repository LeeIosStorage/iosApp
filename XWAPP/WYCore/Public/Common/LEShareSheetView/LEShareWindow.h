//
//  LEShareWindow.h
//  XWAPP
//
//  Created by hys on 2018/5/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Share_Item_Name @"op"
#define Share_Item_Icon @"icon"
#define Share_Item_Action @"action"

@protocol LEShareWindowDelegate <NSObject>

@optional
-(void)shareWindowClickAt:(NSIndexPath *)indexPath action:(NSString *)action;

@end

@interface LEShareWindow : UIView

@property (weak, nonatomic) id <LEShareWindowDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *shareItemArray;

@property (strong, nonatomic) NSMutableArray *handleItemArray;

- (void)setCustomerSheet;

@end
