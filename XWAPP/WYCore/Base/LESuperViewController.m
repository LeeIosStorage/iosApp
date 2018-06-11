//
//  LESuperViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"
#import "UIViewController+SetNavigationStyle.h"
#import "UIImage+LEAdd.h"

@interface LESuperViewController ()
<
UIGestureRecognizerDelegate
>

@property (strong, nonatomic) WYNetWorkManager *networkManager;

@property (strong, nonatomic) UIView *customTitleView;
@property (strong, nonatomic) UILabel *customTitleLabel;

@property (strong, nonatomic) UIView *emptyDataSetView;
@property (strong, nonatomic) UILabel *emptyTipLabel;
@property (strong, nonatomic) UIImageView *emptyTipImageView;

@end

@implementation LESuperViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    LELog(@"!!!!!");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(HitoScreenW, HitoTopHeight)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage imageWithColor:HitoColorFromRGB(0Xd9d9d9) size:CGSizeMake(HitoScreenW, 0.5)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kAppBackgroundColor;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
//    [self setNaStyle];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Public
- (void)setCustomTitle:(NSString *)customTitle{
    _customTitle = customTitle;
    
    self.navigationItem.titleView = self.customTitleView;
    _customTitleLabel.text = customTitle;
    
    _customTitleLabel.frame = self.navigationItem.titleView.bounds;
}

- (void)setRightButton:(UIButton *)rightButton{
    
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    _rightButton = rightButton;
}

- (void)setRightBarButtonItemWithTitle:(NSString *)title color:(UIColor *)color{
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClicked:)];
    rightBarButtonItem.tintColor = color;
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:HitoPFSCRegularOfSize(14)} forState:UIControlStateNormal];
    [rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:HitoPFSCRegularOfSize(14)} forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)needTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

- (void)refreshViewWithObject:(id)object
{
    
}

- (void)rightButtonClicked:(id)sender
{
    
}

- (void)showEmptyDataSetView:(BOOL)hidden title:(NSString *)title image:(UIImage *)image{
    UIView *view = self.view;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            view = subView;
            break;
        }
    }
    
    if (!hidden) {
        if (!self.emptyDataSetView.superview) {
            [view addSubview:self.emptyDataSetView];
            [self.emptyDataSetView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.width.mas_equalTo(HitoScreenW-12*2);
                make.top.equalTo(view).offset(100);
            }];
        }
        self.emptyTipLabel.text = title;
        self.emptyTipImageView.image = image;
        CGSize size = image.size;
        [self.emptyTipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
        
    }else{
        
    }
    self.emptyDataSetView.hidden = hidden;
}

#pragma mark -
#pragma mark - Private
- (void)viewTapped
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - Set And Getters
- (WYNetWorkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[WYNetWorkManager alloc] init];
    }
    return _networkManager;
}

- (UIView *)customTitleView{
    if (!_customTitleView) {
        _customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 44)];
//        _customTitleView.backgroundColor = [UIColor yellowColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:_customTitleView.bounds];
        _customTitleLabel = titleLabel;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = HitoPFSCRegularOfSize(17);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_customTitleView addSubview:titleLabel];
        
    }
    return _customTitleView;
}

- (UIView *)emptyDataSetView{
    if (!_emptyDataSetView) {
        _emptyDataSetView = [[UIView alloc] init];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        _emptyTipImageView = imageView;
        [_emptyDataSetView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.equalTo(self->_emptyDataSetView);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"666666"];
//        label.backgroundColor = kAppThemeColor;
        label.font = HitoPFSCRegularOfSize(15);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        _emptyTipLabel = label;
        [_emptyDataSetView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_emptyDataSetView);
            make.top.equalTo(imageView.mas_bottom).offset(15);
        }];
    }
    return _emptyDataSetView;
}

@end
