//
//  SearchHeaderSecond.h
//  XWAPP
//
//  Created by hys on 2018/5/7.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickSecond)(void);
@interface SearchHeaderSecond : UICollectionReusableView


@property (nonatomic, copy) ClickSecond click;

- (void)clickBtnSecond:(ClickSecond)click;

@end
