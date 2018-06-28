//
//  CommentCell.h
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LECommentCellDelegate;

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) id <LECommentCellDelegate> delegate;

- (void)updateHeaderData:(id)data;

@end

@protocol LECommentCellDelegate <NSObject>
@optional
- (void)CommentCellLongPressActionWithCell:(CommentCell *)cell;

@end
