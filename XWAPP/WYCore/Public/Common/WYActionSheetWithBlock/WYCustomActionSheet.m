//
//  WYCustomActionSheet.m
//  WangYu
//
//  Created by Leejun on 15/10/23.
//  Copyright © 2015年 KID. All rights reserved.
//

#import "WYCustomActionSheet.h"

#define SCREEN_WIDTH (CGRectGetWidth([UIScreen mainScreen].bounds))
#define SCREEN_HEIGHT (CGRectGetHeight([UIScreen mainScreen].bounds))

const CGFloat kWYCellHeight = 44.f;
const CGFloat kWYSeparatorHeight = 8.f;
const CGFloat kWYAnimationDuration = .3f;

@interface WYCustomActionSheet()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UIButton *_cancleButton;
    UILabel *_titleLabel;
    
    UIImageView *_bgImageView;
    UIView *_sheetView;
}

@property (nonatomic, strong) WYCustomActionSheetBlcok clickBlock;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancleTitle;
@property (nonatomic, copy) NSString *destructiveTitle;
@property (nonatomic, strong) NSMutableArray *otherTitles;

@end

@implementation WYCustomActionSheet

- (void)dealloc{
    LELog(@"%@ dealloc!!!",NSStringFromClass([self class]));
}

- (instancetype)initWithTitle:(NSString *)title actionBlock:(WYCustomActionSheetBlcok) actionBlock cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    
    self = [super init];
    if (self) {
        _clickBlock = actionBlock;
        _title = title;
        _cancleTitle = cancelButtonTitle;
        _destructiveTitle = destructiveButtonTitle;
        _otherTitles = [NSMutableArray arrayWithArray:otherButtonTitles];
        
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self addTarget:self action:@selector(hideActionSheet) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    _sheetView = [[UIView alloc] init];
    _sheetView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_sheetView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _tableView.backgroundColor = _sheetView.backgroundColor;
    _tableView.rowHeight = kWYCellHeight;
    
    _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton.backgroundColor = _sheetView.backgroundColor;
    [_cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIFont *cancleButtonFont = [UIFont systemFontOfSize:18];
    UIColor *cancleButtonColor = [UIColor blackColor];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:_cancleTitle attributes:@{NSFontAttributeName:cancleButtonFont,NSForegroundColorAttributeName:cancleButtonColor,}];
    [_cancleButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
    [_cancleButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_cancleButton addTarget:self action:@selector(cancelButtonDragInsideClicked) forControlEvents:UIControlEventTouchDragInside];
    [_cancleButton addTarget:self action:@selector(cancelButtonDragOutsideClicked) forControlEvents:UIControlEventTouchDragOutside];
    [_cancleButton addTarget:self action:@selector(cancelButtonDownClicked) forControlEvents:UIControlEventTouchDown];
    [_sheetView addSubview:_cancleButton];
    
    CGRect frame = {0};
    CGFloat tmpFrameY = 0.f;
    if (_title.length) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.userInteractionEnabled = YES;
        [_sheetView addSubview:_titleLabel];
        
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        _titleLabel.font = titleFont;
        _titleLabel.textColor = [UIColor colorWithHexString:@"9a9a9a"];
        _titleLabel.attributedText = [WYCommonUtils getAttributedStringWithString:_title lineSpacing:4 alignment:NSTextAlignmentCenter];
        
        CGSize textSize = [WYCommonUtils sizeWithAttributedText:_title lineSpacing:4 font:titleFont width:SCREEN_WIDTH-24];
        if (textSize.height > 300) {
            textSize.height = 300;
        }
        
        frame = _titleLabel.frame;
        frame.origin.x = 12;
        frame.origin.y = 18;
        frame.size.width = SCREEN_WIDTH-24;
        frame.size.height = textSize.height;
        _titleLabel.frame = frame;
        
        tmpFrameY = textSize.height + 18*2;
    }
    
    if (_destructiveTitle) {
        _otherTitles = [NSMutableArray arrayWithArray:_otherTitles];
        [_otherTitles addObject:_destructiveTitle];
    }
    
    CGFloat screenHeight = SCREEN_HEIGHT - 30;
    CGFloat totalHeight = _otherTitles.count * kWYCellHeight + kWYCellHeight + kWYSeparatorHeight + tmpFrameY;
    BOOL moreThanScreen = totalHeight > screenHeight;
    CGFloat sheetHeight = moreThanScreen ? screenHeight : totalHeight;
    
    if (!moreThanScreen) {
        _tableView.bounces = NO;
    }else {
        _tableView.bounces = YES;
    }
    [_sheetView addSubview:_tableView];
    frame = _tableView.frame;
    frame.origin.x = 0;
    frame.origin.y = tmpFrameY;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = sheetHeight - tmpFrameY - kWYSeparatorHeight - kWYCellHeight;
    _tableView.frame = frame;
    
    
    //中间分割区域
    UIView *partitionView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height, SCREEN_WIDTH, kWYSeparatorHeight)];
    partitionView.backgroundColor = LineColor;
    [_sheetView addSubview:partitionView];
    
    
    frame = _cancleButton.frame;
    frame.origin.x = 0;
    frame.origin.y = _tableView.frame.origin.y + _tableView.frame.size.height + kWYSeparatorHeight;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = kWYCellHeight;
    _cancleButton.frame = frame;
    
    
    frame = _sheetView.frame;
    frame.origin.x = 0;
    frame.origin.y = SCREEN_HEIGHT;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = sheetHeight;
    _sheetView.frame = frame;
    
//    _sheetView.transform = CGAffineTransformMakeTranslation(0, sheetHeight);
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex >=0 && buttonIndex < _otherTitles.count) {
        return [[_otherTitles objectAtIndex:buttonIndex] description];
    }
    return _cancleTitle;
}

- (void)showInView:(UIView *)superView{
    
    [superView.window addSubview:self];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
//    [UIView animateWithDuration:kWYAnimationDuration animations:^{
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//        CGRect sframe = _sheetView.frame;
//        sframe.origin.y -= sframe.size.height;
//        _sheetView.frame = sframe;
//    }];
    [self animateContentViewToHeight:0];
}

-(void) animateContentViewToHeight:(CGFloat) height
{
    [UIView animateWithDuration:kWYAnimationDuration delay:0.1 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:0 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
//        _sheetView.transform = CGAffineTransformMakeTranslation(0, height);
        CGRect sframe = self->_sheetView.frame;
        sframe.origin.y -= sframe.size.height;
        self->_sheetView.frame = sframe;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideActionSheet
{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        CGRect sframe = self->_sheetView.frame;
        sframe.origin.y += sframe.size.height;
        self->_sheetView.frame = sframe;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
    
}

-(void)cancelButtonDownClicked{
    _cancleButton.backgroundColor = LineColor;
}
-(void)cancelButtonDragInsideClicked{
    _cancleButton.backgroundColor = LineColor;
}
-(void)cancelButtonDragOutsideClicked{
    _cancleButton.backgroundColor = _sheetView.backgroundColor;
}

- (void)cancelButtonClicked
{
    if (self.clickBlock)
        self.clickBlock(_otherTitles.count);
    [self hideActionSheet];
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _otherTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * kCellIdf = @"kCellIdf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdf];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdf];
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topImageView.backgroundColor = LineColor;
        [cell addSubview:topImageView];
        cell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
        selectedBackgroundView.backgroundColor = LineColor;
        cell.selectedBackgroundView = selectedBackgroundView;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = _otherTitles[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    if (_destructiveTitle && indexPath.row == _otherTitles.count-1) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickBlock)
        self.clickBlock(indexPath.row);
    [self hideActionSheet];
}

@end
