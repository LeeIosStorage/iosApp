//
//  LESuperViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/15.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LESuperViewController.h"
#import "UIViewController+SetNavigationStyle.h"

@interface LESuperViewController ()

@property (strong, nonatomic) WYNetWorkManager *networkManager;

@end

@implementation LESuperViewController

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

#pragma mark -
#pragma mark - Set And Getters
- (WYNetWorkManager *)networkManager{
    if (!_networkManager) {
        _networkManager = [[WYNetWorkManager alloc] init];
    }
    return _networkManager;
}


@end
