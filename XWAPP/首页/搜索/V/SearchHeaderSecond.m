//
//  SearchHeaderSecond.m
//  XWAPP
//
//  Created by hys on 2018/5/7.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "SearchHeaderSecond.h"

@implementation SearchHeaderSecond

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _click();
}

- (void)clickBtnSecond:(ClickSecond)click {
    _click = click;
}
@end
