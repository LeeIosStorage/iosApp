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
- (void)refreshViewWithObject:(id)object
{
    
}

- (void)setCustomTitle:(NSString *)customTitle{
    _customTitle = customTitle;
    
    self.navigationItem.titleView = self.customTitleView;
    _customTitleLabel.text = customTitle;
    
    _customTitleLabel.frame = self.navigationItem.titleView.bounds;
}

- (void)needTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
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

@end
