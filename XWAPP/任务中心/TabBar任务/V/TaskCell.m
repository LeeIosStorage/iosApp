//
//  TaskCell.m
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellData:(LETaskListModel *)taskModel{
    
    self.leftLB.text = taskModel.taskTitle;
    self.rightLB.text = [NSString stringWithFormat:@"+%@",taskModel.coin];
    self.rightIM.image = HitoImage(@"task_jinbi");
    if (taskModel.coinType == 2) {
        self.rightIM.image = HitoImage(@"task_hongbao");
        self.rightLB.text = [NSString stringWithFormat:@"+%@元",taskModel.coin];
    }
}

@end
