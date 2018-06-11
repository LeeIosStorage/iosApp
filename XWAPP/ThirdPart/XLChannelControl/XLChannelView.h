//
//  XLChannelView.h
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChannelSelectBlock)(NSInteger index);

@interface XLChannelView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic, strong) NSMutableArray *unUseTitles;

@property (nonatomic, copy) ChannelSelectBlock channelSelectBlock;

-(void)reloadData;

@end
