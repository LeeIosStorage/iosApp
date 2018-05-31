//
//  YQMController.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "YQMController.h"

@interface YQMController ()
<
UITextFieldDelegate,
UIScrollViewDelegate
>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *affirmButton;

@end

@implementation YQMController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setView];
}

- (void)setView {
    self.title = @"输入邀请码";
    [self needTapGestureRecognizer];
    
    [self.mainScrollView removeFromSuperview];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Request
- (void)affirmRequest{
    
//    self.affirmButton.enabled = NO;
//    [SVProgressHUD showCustomWithStatus:nil];
//    HitoWeakSelf;
//    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@""];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:self.codeTextField.text forKey:@"code"];
//    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
//        
//        self.affirmButton.enabled = YES;
//        if (requestType != WYRequestTypeSuccess) {
//            return ;
//        }
//        [SVProgressHUD showCustomSuccessWithStatus:@"请求成功"];
//        
//    } failure:^(id responseObject, NSError *error) {
//        self.affirmButton.enabled = YES;
//    }];
    
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)affirmClickAction:(id)sender{
    self.codeTextField.text = [self.codeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.codeTextField.text.length == 0) {
        [SVProgressHUD showCustomInfoWithStatus:@"请输入邀请码"];
        return;
    }
    [self affirmRequest];
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.affirmButton.frame;
    CGPoint offset = self.mainScrollView.contentOffset;
    
    CGRect newFrame = [self.mainScrollView convertRect:frame toView:self.view];
    CGFloat offY = 216-(HitoScreenH - newFrame.origin.y - newFrame.size.height);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (offY > 0) {
        offset.y += offY;
        self.mainScrollView.contentOffset = offset;
    }
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGPoint offset = self.mainScrollView.contentOffset;
    offset.y = 0;
    self.mainScrollView.contentOffset = offset;
    [UIView commitAnimations];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.codeTextField resignFirstResponder];
}

@end
