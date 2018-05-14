//
//  TaskCell.h
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLB;
@property (weak, nonatomic) IBOutlet UILabel *rightLB;
@property (weak, nonatomic) IBOutlet UIImageView *rightIM;
@property (weak, nonatomic) IBOutlet UIView *longLine;
@property (weak, nonatomic) IBOutlet UIView *shortView;

@end
