//
//  WYCustomActionSheet.h
//  WangYu
//
//  Created by Leejun on 15/10/23.
//  Copyright © 2015年 KID. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WYCustomActionSheetBlcok) (NSInteger buttonIndex);

@interface WYCustomActionSheet : UIControl

@property (strong, nonatomic) UIColor *titleColor;

- (instancetype)initWithTitle:(NSString *)title actionBlock:(WYCustomActionSheetBlcok) actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

- (void)showInView:(UIView *)superView;

@end
