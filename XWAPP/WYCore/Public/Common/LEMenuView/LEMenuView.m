//
//  LEMenuView.m
//  XWAPP
//
//  Created by hys on 2018/7/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEMenuView.h"

@interface LEMenuView ()
{
    CGRect _rect;
}
@property (strong, nonatomic) UIView *menuView;

@end

@implementation LEMenuView

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc
{
    LELog(@"!!!!");
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _rect = frame;
        [self setup];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    self.frame = CGRectZero;
    [self addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self->_rect.origin.y);
        make.left.equalTo(self).offset(self->_rect.origin.x);
        make.size.mas_equalTo(self->_rect.size);
    }];
//    self.menuView.backgroundColor = kAppThemeColor;
    
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effe = [[UIVisualEffectView alloc] initWithEffect:blur];
//    effe.frame = CGRectMake(0, 0 , _rect.size.width, _rect.size.height);
//    [self.menuView insertSubview:effe atIndex:0];
    
    NSArray *itemArray = [NSArray arrayWithObjects:@"  发图文   ",@"  拍小视频",@"  上传视频", nil];
    
    for (int i = 0; i < itemArray.count; i ++) {
        NSString *item = itemArray[i];
        NSString *image = @"home_xiala_fatuwen";
        if (i == 1) image = @"home_xiala_paishipin";
        if (i == 2) image = @"home_xiala_shangchuan";
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:item forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"cfcfcf"] forState:UIControlStateNormal];
        [button.titleLabel setFont:HitoPFSCRegularOfSize(15)];
        button.tag = i;
        [button addTarget:self action:@selector(itemClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.menuView);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.menuView).offset(10+i*42);
        }];
        
        UIImageView *lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = [UIColor colorWithHexString:@"3f3f3f"];
        [self.menuView addSubview:lineImageView];
        [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.menuView).offset(13);
            make.right.equalTo(self.menuView).offset(-13);
            make.top.equalTo(button.mas_bottom);
            make.height.mas_equalTo(0.5);
        }];
    }
    
}

- (void)itemClickAction:(UIButton *)sender{
    if (self.menuViewClickBlock) {
        self.menuViewClickBlock(sender.tag);
    }
    [self dismiss];
}

#pragma mark -
#pragma mark - Public
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows[0];
    }
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)dismiss{
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark - Set And Getters
- (UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"home_tougaoxiala"] stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
        [_menuView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self->_menuView);
        }];
        
    }
    return _menuView;
}

@end
