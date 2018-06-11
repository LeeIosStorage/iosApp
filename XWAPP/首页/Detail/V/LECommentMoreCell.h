//
//  LECommentMoreCell.h
//  XWAPP
//
//  Created by hys on 2018/5/19.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LECommentMoreClickBolck)();

typedef NS_ENUM(NSInteger, LECommentMoreCellType){
    LECommentMoreCellTypeNormal = 0,
    LECommentMoreCellTypeMore = 1,
    LECommentMoreCellTypeALL = 2,
};

@interface LECommentMoreCell : UITableViewCell

@property (assign, nonatomic) LECommentMoreCellType commentMoreCellType;

@property (copy, nonatomic) LECommentMoreClickBolck commentMoreClickBolck;

@end
