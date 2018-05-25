//
//  LECommentDetailViewController.m
//  XWAPP
//
//  Created by hys on 2018/5/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LECommentDetailViewController.h"
#import "LECommentMoreCell.h"
#import "CommentCell.h"
#import "CommontHeaderView.h"
#import "LECommentFooterView.h"
#import "CommontHFView.h"

@interface LECommentDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
CommontHeaderViewDelegate
>
{
    CommentCell *_selectedCommentCell;
    LEReplyCommentModel *_currentReplyModel;
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) CommontHFView *huView;

@end

@implementation LECommentDetailViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)dealloc
{
    LELog(@"dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
    [self setTitle:@"评论详情"];
    
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
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    [self.tableView reloadData];
    
    UIWindow *window = HitoApplication;
    [window addSubview:self.huView];
    
}

#pragma mark -
#pragma mark - Request
- (void)sendCommentRequestWith:(NSString *)text{
    
    if (text.length == 0) {
        return;
    }
    
    [SVProgressHUD showCustomWithStatus:nil];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"commentSave"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    if (text.length) [params setObject:text forKey:@"content"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    NSString *parentId = _currentReplyModel.commentId;
    if (parentId) [params setObject:parentId forKey:@"parentId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"评论成功"];
        [WeakSelf.huView.hufuTF resignFirstResponder];
//        [WeakSelf getNewsCommentsRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (void)favourRequestWithCommentModel:(LENewsCommentModel *)commentModel headerView:(CommontHeaderView *)headerView section:(NSInteger)section{
    
    BOOL like = YES;
    if (commentModel.favour) {
        like = NO;
    }
//    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"DoLikeOrUnLike"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:commentModel.commentId forKey:@"commentId"];
    [params setObject:[NSNumber numberWithBool:like] forKey:@"doLike"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        commentModel.favour = !commentModel.favour;
        //        [WeakSelf.tableView reloadData];
        
        headerView.favourImageView.highlighted = !headerView.favourImageView.highlighted;
        if (headerView.favourImageView.highlighted) {
            [WYCommonUtils popOutsideWithDuration:0.5 view:headerView.favourImageView];
        }else{
            [WYCommonUtils popInsideWithDuration:0.4 view:headerView.favourImageView];
        }
        
        
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 40;
        _tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionHeaderHeight = 70;
        _tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        _tableView.estimatedSectionFooterHeight = 20;
        [_tableView registerClass:[CommontHeaderView class] forHeaderFooterViewReuseIdentifier:@"CommontHeaderView"];
        
//        [_tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    }
    return _tableView;
}

- (CommontHFView *)huView {
    if (!_huView) {
        _huView = [[[NSBundle mainBundle] loadNibNamed:@"CommontHFView" owner:self options:nil] firstObject];
        _huView.frame = CGRectMake(0, HitoScreenH-49, HitoScreenW, 49);
        HitoWeakSelf;
        _huView.commontViewWithSendBlcok = ^(NSString *message) {
            [WeakSelf sendCommentRequestWith:message];
        };
    }
    return _huView;
}

#pragma mark -
#pragma mark - NSNotification
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyBoardHeight = keyboardRect.size.height;
//    HitoWeakSelf;
    if (self.huView.hufuTF.isFirstResponder){
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:_selectedCommentCell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.huView.frame = CGRectMake(0, HitoScreenH - keyBoardHeight - 49, HitoScreenW, 49);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        self.huView.frame = CGRectMake(0, HitoScreenH-49, HitoScreenW, 49);
    }];
}

#pragma mark - UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.commentModel.comments.count == 0) {
        return self.commentModel.comments.count;
    }
    return self.commentModel.comments.count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.commentModel.comments.count) {
        static NSString *cellIdentifier = @"LECommentMoreCell";
        LECommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LECommentMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.commentModel.comments.count > 5) {
            [cell setCommentMoreCellType:LECommentMoreCellTypeALL];
            
        }else{
            [cell setCommentMoreCellType:LECommentMoreCellTypeNormal];
        }
        
        return cell;
    }
    
    LEReplyCommentModel *replyModel = self.commentModel.comments[indexPath.row];
    
    static NSString *cellIdentifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
//        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:nil options:nil];
//        cell = [cells objectAtIndex:0];
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell updateHeaderData:replyModel];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerIdentifier = @"CommontHeaderView";
    CommontHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[CommontHeaderView alloc] initWithReuseIdentifier:headerIdentifier];
    }
    
    [header updateHeaderData:self.commentModel];
    header.section = section;
    header.delegate = self;
    
    return header;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    static NSString *footerIdentifier = @"LECommentFooterView";
    LECommentFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    if (!footer) {
        footer = [[LECommentFooterView alloc] initWithReuseIdentifier:footerIdentifier];
    }
    return footer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == self.commentModel.comments.count) {
        return;
    }
    _currentReplyModel = self.commentModel.comments[indexPath.row];
    _selectedCommentCell = [tableView cellForRowAtIndexPath:indexPath];
    [_huView.hufuTF becomeFirstResponder];
    
    NSString *placeholder = @"回复：张三";
    _huView.hufuTF.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(13) color:kAppSubTitleColor];
    
    CGRect rect = [_selectedCommentCell convertRect:_selectedCommentCell.frame toView:self.view];
    
    if (rect.origin.y / 2 + rect.size.height>= HitoScreenH - 216) {
        
        
        if (_huView.hufuTF.isFirstResponder) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
            [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:_selectedCommentCell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

#pragma mark -
#pragma mark - CommontHeaderViewDelegate
- (void)commentHeaderWithFavourClick:(NSInteger)section headerView:(CommontHeaderView *)headerView{
    
    [self favourRequestWithCommentModel:self.commentModel headerView:headerView section:section];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_huView.hufuTF resignFirstResponder];
}

@end
