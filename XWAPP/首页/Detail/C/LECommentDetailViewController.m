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
#import "LELoginManager.h"

@interface LECommentDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
CommontHeaderViewDelegate
>
{
    CGRect _currentRect;
    
    LEReplyCommentModel *_currentReplyModel;
}

@property (assign, nonatomic) CGFloat keyBoardHeight;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) CommontHFView *huView;

@property (assign, nonatomic) int nextCursor;

@end

@implementation LECommentDetailViewController

#pragma mark -
#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.huView removeFromSuperview];
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
    
    _currentRect = CGRectZero;
    
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
    
//    UIWindow *window = HitoApplication;
    [self.view addSubview:self.huView];
    [self.huView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    
    [self setTextFieldAttributedPlaceholder];
    
    [self addMJ];
    
}

- (void)addMJ {
    //下拉刷新
    MJWeakSelf;
    self.tableView.mj_header = [LERefreshHeader headerWithRefreshingBlock:^{
        
        weakSelf.nextCursor = 1;
        [weakSelf getNewsCommentsRequest];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
    self.tableView.mj_footer = [LERefreshFooter footerWithRefreshingBlock:^{
        
        [weakSelf getNewsCommentsRequest];
    }];
    [self.tableView.mj_footer setHidden:YES];
    
}

- (void)setTextFieldAttributedPlaceholder{
    
    NSString *placeholder = @"回复：";
    if (_currentReplyModel){
        NSString *userName = _currentReplyModel.userName;
        if (userName.length == 0) userName = @"";
        placeholder = [NSString stringWithFormat:@"回复：%@",userName];
    }else {
        NSString *userName = _commentModel.userName;
        if (userName.length == 0) userName = @"";
        placeholder = [NSString stringWithFormat:@"回复：%@",userName];
    }
    _huView.hufuTF.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(13) color:kAppSubTitleColor];
    
}

- (void)outputRecursion:(NSArray *)comments result:(NSMutableArray *)result withReplyModel:(LEReplyCommentModel *)replyModel{
    
    for (LEReplyCommentModel *childrenModel in comments) {
        childrenModel.replyuId = replyModel.userId;
        childrenModel.replyUserName = replyModel.userName;
        [result addObject:childrenModel];
        if (childrenModel.children.count > 0) {
            [self outputRecursion:childrenModel.children result:result withReplyModel:childrenModel];
        }
    }
}

#pragma mark -
#pragma mark - Request
- (void)getNewsCommentsRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetComment"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    [params setObject:self.commentModel.commentId forKey:@"parentId"];
    
    [self.networkManager POST:requestUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        [WeakSelf.tableView.mj_header endRefreshing];
        [WeakSelf.tableView.mj_footer endRefreshing];
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LEReplyCommentModel class] json:[dataObject objectForKey:@"data"]];
        
        //重新计算评论array
        NSMutableArray *children = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[LEReplyCommentModel class]]) {
                LEReplyCommentModel *replyModel = (LEReplyCommentModel *)obj;
                [children addObject:replyModel];
                
                [WeakSelf outputRecursion:replyModel.children result:children withReplyModel:replyModel];
            }
            if ([array lastObject] == obj) {
                *stop = YES;
            }
        }];
        
//        WeakSelf.commentModel = [[LENewsCommentModel alloc] init];
        
        NSMutableArray *comments = [NSMutableArray arrayWithArray:WeakSelf.commentModel.comments];
        if (WeakSelf.nextCursor == 1) {
            comments = [NSMutableArray array];
        }
        [comments addObjectsFromArray:children];
        WeakSelf.commentModel.comments = comments;
        
        
        if (!isCache) {
            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                [WeakSelf.tableView.mj_footer setHidden:YES];
            }else{
                [WeakSelf.tableView.mj_footer setHidden:NO];
                WeakSelf.nextCursor ++;
            }
        }
        
        [WeakSelf.tableView reloadData];
        
    } failure:^(id responseObject, NSError *error) {
        
        [WeakSelf.tableView.mj_header endRefreshing];
        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)sendCommentRequestWith:(NSString *)text{
    
    [_huView.hufuTF resignFirstResponder];
    if ([[LELoginManager sharedInstance] needUserLogin:self]) {
        return;
    }
    
    if (text.length == 0 || text.length > COMMENT_MAX_COUNT) {
        [SVProgressHUD showCustomInfoWithStatus:@"评论内容须在1到255字之内"];
        return;
    }
    
    [SVProgressHUD showCustomWithStatus:nil];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"commentSave"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    if (text.length) [params setObject:text forKey:@"content"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    NSString *parentId = _currentReplyModel.commentId;
    if (parentId.length == 0) parentId = _commentModel.commentId;
    if (parentId) [params setObject:parentId forKey:@"parentId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomSuccessWithStatus:@"评论成功"];
        WeakSelf.huView.hufuTF.text = nil;
        [WeakSelf getNewsCommentsRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (void)favourRequestWithCommentModel:(LENewsCommentModel *)commentModel headerView:(CommontHeaderView *)headerView section:(NSInteger)section{
    
    if ([[LELoginManager sharedInstance] needUserLogin:self]) {
        return;
    }
    
    BOOL like = YES;
    if (commentModel.favour) {
        like = NO;
    }
//    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"DoLikeOrUnLike"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:commentModel.commentId forKey:@"commentId"];
    [params setObject:[NSNumber numberWithBool:like] forKey:@"doLike"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        commentModel.favour = !commentModel.favour;
        //        [WeakSelf.tableView reloadData];
        
        headerView.favourImageView.highlighted = !headerView.favourImageView.highlighted;
        if (headerView.favourImageView.highlighted) {
            [WYCommonUtils popOutsideWithDuration:0.5 view:headerView.favourImageView];
            commentModel.favourNum ++;
        }else{
            [WYCommonUtils popInsideWithDuration:0.4 view:headerView.favourImageView];
            commentModel.favourNum --;
        }
        if (commentModel.favourNum <= 0) {
            commentModel.favourNum = 0;
        }
        headerView.favourLabel.text = [NSString stringWithFormat:@"%d",commentModel.favourNum];
        
        
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
//        _huView.frame = CGRectMake(0, HitoScreenH-49, HitoScreenW, 49);
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
    self.keyBoardHeight = keyboardRect.size.height;
//    HitoWeakSelf;
    if (self.huView.hufuTF.isFirstResponder){
        
        if (_currentRect.origin.y > 0) {
            CGPoint offset = self.tableView.contentOffset;
            offset.y = _currentRect.origin.y + _currentRect.size.height - (self.view.bounds.size.height - _keyBoardHeight - 49);
            [self.tableView setContentOffset:offset animated:YES];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.huView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-self.keyBoardHeight);
            }];
            [self.huView.superview layoutIfNeeded];
//            self.huView.frame = CGRectMake(0, HitoScreenH - self.keyBoardHeight - 49, HitoScreenW, 49);
        }];
    }
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    
    _currentReplyModel = nil;
    _currentRect = CGRectZero;
    [self setTextFieldAttributedPlaceholder];
    
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        [self.huView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
        [self.huView.superview layoutIfNeeded];
//        self.huView.frame = CGRectMake(0, HitoScreenH-49, HitoScreenW, 49);
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
        
        if (self.tableView.mj_footer.hidden) {
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
    if ([WYCommonUtils isEqualWithUserId:_currentReplyModel.userId]) {
        _currentReplyModel = nil;
        [SVProgressHUD showCustomInfoWithStatus:@"不能回复自己"];
        return;
    }
    
    _currentRect = [tableView rectForRowAtIndexPath:indexPath];
    
    [_huView.hufuTF becomeFirstResponder];
    
    [self setTextFieldAttributedPlaceholder];
    
    if (_huView.hufuTF.isFirstResponder) {
        
        CGPoint offset = self.tableView.contentOffset;
        offset.y = _currentRect.origin.y + _currentRect.size.height - (self.view.bounds.size.height - _keyBoardHeight - 49);
        [self.tableView setContentOffset:offset animated:YES];
        HitoWeakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            [WeakSelf.huView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).offset(-WeakSelf.keyBoardHeight);
            }];
            [WeakSelf.huView.superview layoutIfNeeded];
//            WeakSelf.huView.frame = CGRectMake(0, HitoScreenH - WeakSelf.keyBoardHeight - 49, HitoScreenW, 49);
        }];
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
