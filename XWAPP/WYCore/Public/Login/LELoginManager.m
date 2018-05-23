//
//  LELoginManager.m
//  XWAPP
//
//  Created by hys on 2018/5/22.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LELoginManager.h"

@interface LELoginManager ()

@property (copy, nonatomic) LELoginSuccessBlock         loginSuccessBlock;
@property (copy, nonatomic) LELoginFailureBlock         loginFailureBlock;
@property (copy, nonatomic) LELoginCancelBlock          loginCancelBlock;
@property (strong, nonatomic) PhoneLogin     *loginViewController;

@property (weak, nonatomic) UIViewController *fromViewController;

@end

@implementation LELoginManager

+ (LELoginManager *)sharedInstance{
    
    static LELoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark -
#pragma mark - Public
- (void)showLoginViewControllerFromPresentViewController:(UIViewController *)fromViewController
                                        showCancelButton:(BOOL)showCancel
                                                 success:(LELoginSuccessBlock)success
                                                 failure:(LELoginFailureBlock)failure
                                                  cancel:(LELoginCancelBlock)cancel{
    if (!fromViewController) {
        cancel();
        return;
    }
    if (![fromViewController isKindOfClass:[UIViewController class]]) {
        cancel();
        return;
    }
    self.isShowLogin = YES;
    self.loginSuccessBlock = success;
    self.loginFailureBlock = failure;
    self.loginCancelBlock = cancel;
    
    PhoneLogin *phoneVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PhoneLogin"];
    if (!self.fromViewController) {
        self.fromViewController = fromViewController;
    }
    [fromViewController presentViewController:phoneVc animated:YES completion:^{
        
    }];
    
    self.loginViewController = phoneVc;
    HitoWeakSelf;
    phoneVc.loginSuccessBlock = ^(void) {
        [WeakSelf didLoginSuccess];
        [WeakSelf.loginViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    phoneVc.loginCancelBlock = ^{
        [WeakSelf doCancel];
        [WeakSelf.loginViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    };
    
}

- (BOOL)needUserLogin:(UIViewController *)fromViewController{
    
//    HitoWeakSelf;
    if (![LELoginUserManager hasAccoutLoggedin]) {
        __weak UIViewController *currentVC = fromViewController;
        [self showLoginViewControllerFromPresentViewController:fromViewController showCancelButton:YES success:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshUILoginNotificationKey object:nil];
            if ([currentVC isKindOfClass:[LESuperViewController class]]) {
                LESuperViewController *superVc = (LESuperViewController *)currentVC;
                [superVc refreshViewWithObject:nil];
            }
            
        } failure:^(NSString *errorMessage) {
            
        } cancel:^{
            
        }];
        return YES;
    }
    return NO;

}

#pragma mark -
#pragma mark - Private
- (void)didLoginSuccess {
    if (self.loginSuccessBlock) {
        self.isShowLogin = NO;
        self.loginSuccessBlock();
    }
}

- (void)doCancel
{
    if (self.loginCancelBlock) {
        self.isShowLogin = NO;
        self.loginCancelBlock();
    }
}

@end
