//
//  XLChannelItem.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelItem.h"

@interface XLChannelItem ()
{
    UILabel *_textLabel;
    
    CAShapeLayer *_borderLayer;
}
@end

@implementation XLChannelItem

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
//    self.userInteractionEnabled = true;
//    self.layer.cornerRadius = 5.0f;
//    self.backgroundColor = [self backgroundColor];
    


    
    _textLabel = [UILabel new];
    _textLabel.frame = self.bounds;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [self textColor];
    _textLabel.adjustsFontSizeToFitWidth = true;
    _textLabel.userInteractionEnabled = true;
    [self addSubview:_textLabel];
    
    _textLabel.layer.cornerRadius = 4.;//边框圆角大小
    _textLabel.layer.masksToBounds = YES;
    _textLabel.layer.borderColor = HitoColorFromRGB(0x999999).CGColor;//边框颜色
    _textLabel.layer.borderWidth = 1;//边框宽度
    
    _rightTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 12, -12, 24, 24)];
    _rightTopBtn.backgroundColor = [UIColor whiteColor];
    _rightTopBtn.layer.cornerRadius = 12;
    _rightTopBtn.layer.masksToBounds = YES;
    _rightTopBtn.layer.borderColor = HitoColorFromRGB(0x999999).CGColor;//边框颜色
    _rightTopBtn.layer.borderWidth = 0.5;
    
    [_rightTopBtn addTarget:self action:@selector(rightTopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightTopBtn];
    
    [self addBorderLayer];
}

- (void)rightTopAction:(UIButton *)sender {
    if (_rightTopAction) {
        _rightTopAction();
    }
}

- (void)rightTopBlockAction:(RightTopAction)rightTopAction {
    _rightTopAction = rightTopAction;
}

-(void)addBorderLayer{
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1;
    _borderLayer.lineDashPattern = @[@5, @3];
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [self backgroundColor].CGColor;
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = true;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event{
    
    /**
     *  事件转发 应用场景:子视图超出父视图的部分也响应事件
     */
    // 触摸点在视图范围内 则交由父类处理
    if ([self pointInside:point withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }
    
    NSArray<UIView *> * superViews = self.subviews;
    for (NSUInteger i = superViews.count; i > 0; i--) {
        
        UIView *subview = superViews[i - 1];
        CGPoint newPoint = [self convertPoint:point toView:subview];
        UIView *view = [subview hitTest:newPoint withEvent:event];
        if (view) {
            return view;
        }
    }
    return nil;
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
//    return YES;
//}

#pragma mark -
#pragma mark 配置方法

-(UIColor*)backgroundColor{
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}

#pragma mark -
#pragma mark Setter

-(void)setTitle:(NSString *)title
{
    _title = title;
    _textLabel.text = title;
}

-(void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.backgroundColor = [UIColor clearColor];
        _borderLayer.hidden = false;
    }else{
        self.backgroundColor = [self backgroundColor];
        _borderLayer.hidden = true;
    }
}

-(void)setIsFixed:(BOOL)isFixed{
    _isFixed = isFixed;
    if (isFixed) {
        _textLabel.textColor = [self lightTextColor];
    }else{
        _textLabel.textColor = [self textColor];
    }
}

@end
