//
//  XLChannelControl.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelControl.h"
#import "XLChannelView.h"

@interface XLChannelControl ()
{
    UINavigationController *_nav;
    
    XLChannelView *_channelView;
    
    ChannelBlock _block;
    
    NSMutableArray *_inUseTitles;
}

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation XLChannelControl

+(XLChannelControl*)shareControl{
    static XLChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[XLChannelControl alloc] init];
    });
    return control;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self buildChannelView];
    }
    return self;
}

-(void)buildChannelView{
    
    self.currentIndex = -1;
    _channelView = [[XLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    __weak typeof(self) weakSelf = self;
    _channelView.channelSelectBlock = ^(NSInteger index) {
        weakSelf.currentIndex = index;
        [weakSelf backMethod];
    };
    
    _nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    _nav.navigationBar.tintColor = [UIColor blackColor];
    _nav.topViewController.title = @"频道定制";
    _nav.topViewController.view = _channelView;
    _nav.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
}

-(void)backMethod
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self->_nav.view.frame;
        frame.origin.y = - self->_nav.view.bounds.size.height;
        self->_nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [self->_nav.view removeFromSuperview];
    }];
    
    BOOL needRefresh = YES;
    if ([_channelView.inUseTitles isEqual:_inUseTitles]) {
        needRefresh = NO;
    }
    
    _block(_channelView.inUseTitles,_channelView.unUseTitles,self.currentIndex,needRefresh);
}

-(void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles finish:(ChannelBlock)block{
    self.currentIndex = -1;
    _block = block;
    _channelView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _channelView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_channelView reloadData];

    CGRect frame = _nav.view.frame;
    frame.origin.y = - _nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    [UIView animateWithDuration:0.3 animations:^{
        self->_nav.view.alpha = 1;
        self->_nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}

@end
