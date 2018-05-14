//
//  XLChannelHeaderView.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeStatus)(BOOL selected);

@interface XLChannelHeader : UICollectionReusableView

@property (copy,nonatomic) NSString *title;

@property (copy,nonatomic) NSString *subTitle;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) ChangeStatus changeStatus;

- (void)changeStatusBlock:(ChangeStatus)changeStatus;

@end
