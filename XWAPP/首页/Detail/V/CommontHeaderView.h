//
//  CommontHeaderView.h
//  XWAPP
//
//  Created by hys on 2018/5/10.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^FavourClickBlock)(UIButton *favourButton);

@protocol CommontHeaderViewDelegate;

@interface CommontHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *contentLB;

//@property (copy, nonatomic) FavourClickBlock favourClickBlock;

@property (weak, nonatomic) id <CommontHeaderViewDelegate> delegate;

@property (assign, nonatomic) NSInteger section;

@property (strong, nonatomic) UIImageView *favourImageView;

- (void)updateHeaderData:(id)data;

@end

@protocol CommontHeaderViewDelegate <NSObject>
@optional
- (void)commentHeaderWithFavourClick:(NSInteger)section headerView:(CommontHeaderView *)headerView;

@end
