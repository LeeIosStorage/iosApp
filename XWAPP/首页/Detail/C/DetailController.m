//
//  DetailController.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "DetailController.h"
#import "CommontView.h"
#import "CommentCell.h"
#import "CommontHeaderView.h"
#import "CommontHFView.h"
@interface DetailController () <UIWebViewDelegate, UITextViewDelegate>
{
    CGFloat _keyBoardHeight;
}
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) CommontView *comView;
@property (nonatomic, strong) CommontHFView *huView;

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addWkWeb];
    [self setView];
}

- (CommontHFView *)huView {
    if (!_huView) {
        _huView = [[[NSBundle mainBundle] loadNibNamed:@"CommontHFView" owner:self options:nil] firstObject];
        _huView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 49);
    }
    return _huView;
}

- (void)addWkWeb {
    NSString *str = @"<html><body><h1>我的第一个标题</h1><p>我的第一个段落。</p></body></html>";
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, 10)];
    _webView.delegate = self;
    [_webView loadHTMLString:str baseURL:nil];
    self.tableView.tableHeaderView = _webView;
    [self.view addSubview:self.huView];
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setView {
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 24)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 24, 24)];
    codeImage.image = HitoImage(@"home_xiepinglun_nor");
    [codeView addSubview:codeImage];
    _commentTF.leftView = codeView;
    _commentTF.leftViewMode = UITextFieldViewModeAlways;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowOpacity = 0.8f;
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(4,4);
    
    self.tableView.tableFooterView = [UIView new];
    [[UITableViewHeaderFooterView appearance] setTintColor:HitoColorFromRGB(0Xf1f1f1)];
    
    [self keyBoardNoti];
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 70;
    
}

#pragma mark - UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CommontHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"CommontHeaderView" owner:self options:nil] firstObject];
    if (section == 2) {
        header.contentLB.text = @"水电费是否实际付款建立福建阿卡丽积分卡积分哈斯放假回家案发后就开始福建安徽师范几哈几号放假哎好烦几哈继父回家撒回复积分离开静安寺法律框架路口附近开房";
    }
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_huView.hufuTF becomeFirstResponder];
    
    CGRect rect = [cell convertRect:cell.frame toView:self.view];

    if (rect.origin.y / 2 + rect.size.height>= HitoScreenH - 216) {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0); 
        [_commentTF becomeFirstResponder];
        [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.huView.frame = CGRectMake(0, HitoScreenH - _keyBoardHeight - 49, HitoScreenW, 49);
        }];
    }
}

#pragma mark - textfielddelegate
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField {

    
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField {

}



#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {

}


- (IBAction)favoAction:(UIButton *)sender {
}


- (IBAction)commentAction:(UIButton *)sender {
}
- (IBAction)shareAction:(UIButton *)sender {
}

#pragma mark - 键盘
- (void)keyBoardNoti {
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    

    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    HitoWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        WeakSelf.comView.frame = CGRectMake(0, HitoScreenH - _keyBoardHeight - 107, HitoScreenW, 107);
    }];
}


- (void)keyboardDidShow:(NSNotification *)sender {

    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
}

- (IBAction)tapActionForBottomView:(UITapGestureRecognizer *)sender {
    UIWindow *window = HitoApplication;
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    _tempView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBV)];
    [_tempView addGestureRecognizer:tap];
    
    _comView = [[[NSBundle mainBundle] loadNibNamed:@"CommontView" owner:self options:nil] firstObject];
    _comView.comTextView.delegate = self;
    [_comView.comTextView becomeFirstResponder];
    _comView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 107);
    [_tempView addSubview:_comView];
    [window addSubview:_tempView];
//    [UIView animateWithDuration:0.3 animations:^{
//        _comView.frame = CGRectMake(0, HitoScreenH - _keyBoardHeight - 107, HitoScreenW, 107);
//    }];
}
- (void)removeBV {
    [_tempView removeFromSuperview];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_huView.hufuTF resignFirstResponder];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.huView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 49);
}


@end
