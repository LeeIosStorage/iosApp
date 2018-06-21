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
#import "LENewsDetailContentView.h"
#import "LENewsDetailHeaderView.h"
#import "YYPhotoGroupView.h"
#import "LENewsContentModel.h"
#import "LENewsCommentHeadView.h"
#import "LECommentFooterView.h"
#import "LECommentMoreCell.h"
#import "LENewsCommentModel.h"
#import "LEShareSheetView.h"
#import "LEShareWindow.h"
#import "LECommentDetailViewController.h"
#import "LELoginManager.h"
#import "LELoginAuthManager.h"

@interface DetailController ()
<UIWebViewDelegate,
UITextViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
CommontViewDelegate,
CommontHeaderViewDelegate,
LEShareSheetViewDelegate
>
{
    CGRect _currentRect;
    
    LEReplyCommentModel *_currentReplyModel;
    LENewsCommentModel *_currentCommentModel;
    
    LEShareSheetView *_shareSheetView;
    
    BOOL _isCollect;
}

@property (assign, nonatomic) CGFloat keyBoardHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (strong, nonatomic) LENewsDetailHeaderView *newsDetailHeaderView;
@property (strong, nonatomic) LENewsDetailContentView *newsDetailContentView;
@property (strong, nonatomic) LENewsCommentHeadView *newsCommentHeadView;

@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) CommontView *comView;
@property (nonatomic, strong) CommontHFView *huView;

@property (strong, nonatomic) NSMutableArray *commentLists;
@property (assign, nonatomic) int nextCursor;

@end

@implementation DetailController

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_huView removeFromSuperview];
}

- (instancetype)initWithNewsId:(NSString *)newsId{
    self = [super init];
    if (self) {
        _newsId = newsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self getNewsDetailRequest];
    [self checkFavoriteNewsRequest];
    [self getNewsCommentsRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshViewWithObject:(id)object{
    [self checkFavoriteNewsRequest];
}

#pragma mark -
#pragma mark - Public
- (void)showImageDetailWithImageView:(YYAnimatedImageView *)imageView{
    
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
    
    for (NSUInteger i = 0, max = self.imageItemsArray.count; i < max; i++) {
        LENewsContentModel *model = self.imageItemsArray[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        YYAnimatedImageView *willThumbView = [self.newsDetailContentView viewWithTag:i + 10];
        item.thumbView = willThumbView;
        item.largeImageURL = [NSURL URLWithString:model.imageUrl];
        item.largeImageSize = CGSizeMake(model.styleBox.width, model.styleBox.height);
        [items addObject:item];
        if (i == imageView.tag - 10) {
            fromView = imageView;
        }
    }
    YYPhotoGroupView *groupView = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [groupView presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:^{
        
    }];
    
}

#pragma mark -
#pragma mark - Private
- (void)setupSubViews{
    
//    self.view.backgroundColor = kAppThemeColor;
    
    self.nextCursor = 1;
    self.commentLists = [[NSMutableArray alloc] init];
    
    UIView *codeView = [[UIView alloc] initWithFrame:CGRectMake(0, 8.5, 13, 13)];
    UIImageView *codeImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 13, 13)];
    codeImage.image = HitoImage(@"home_xiepinglun_nor");
    [codeView addSubview:codeImage];
    _commentTF.leftView = codeView;
    _commentTF.leftViewMode = UITextFieldViewModeAlways;
    _commentTF.layer.cornerRadius = 15;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowOpacity = 0.8f;
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(4,4);
    
    self.tableView.tableFooterView = [UIView new];
//    [[UITableViewHeaderFooterView appearance] setTintColor:kAppThemeColor];
    
    [self.tableView registerClass:[CommontHeaderView class] forHeaderFooterViewReuseIdentifier:@"CommontHeaderView"];
    
    [self keyBoardNoti];
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 70;
    self.tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 24;
    
    
    
    self.newsDetailHeaderView.width = HitoScreenW;
//    self.newsDetailHeaderView.height = 65;
    [self.newsDetailContentView addSubview:self.newsDetailHeaderView];
    self.newsCommentHeadView.top = 0;
    self.newsCommentHeadView.width = HitoScreenW;
    self.newsCommentHeadView.height = 45;
    [self.newsDetailContentView addSubview:self.newsCommentHeadView];
    self.tableView.tableHeaderView = self.newsDetailContentView;
    [self.tableView reloadData];
    
    [self addMJ];
    
}

- (void)setData{
    
    CGFloat headerHeight = [self.newsDetailHeaderView updateWithData:self.newsDetailModel.info];
    
    NSString *htmlString = nil;
    htmlString = self.newsDetailModel.info.content;
    
    HitoWeakSelf;
    [self parserContentWithHtmlString:htmlString handleSuccessBlcok:^(NSMutableAttributedString *attributedString) {
        
        
        
        WeakSelf.newsDetailModel.contentAttributedString = attributedString;
        WeakSelf.newsDetailModel.contentHeight = [NSNumber numberWithFloat:[WeakSelf getAttributedStringHeightWithString:attributedString]];
        [WeakSelf.newsDetailContentView updateWithData:WeakSelf.newsDetailModel];
        WeakSelf.newsDetailContentView.contentLabel.top = headerHeight + 10;
        WeakSelf.newsDetailContentView.height = [WeakSelf.newsDetailModel.contentHeight floatValue] + headerHeight + WeakSelf.newsCommentHeadView.height;
        WeakSelf.newsCommentHeadView.top = [WeakSelf.newsDetailModel.contentHeight floatValue] + headerHeight;
        WeakSelf.tableView.tableHeaderView = WeakSelf.newsDetailContentView;
        [WeakSelf.tableView reloadData];
        
    }];
    
    [self.tableView reloadData];
}

- (void)showCommentDetailVcWithSection:(NSInteger)section{
    if (section < 0 || section >= self.commentLists.count) {
        return;
    }
    LENewsCommentModel *commentModel = self.commentLists[section];
    
    LECommentDetailViewController *commentDetailVc = [[LECommentDetailViewController alloc] init];
    commentDetailVc.commentModel = commentModel;
    commentDetailVc.newsId = self.newsId;
    [self.navigationController pushViewController:commentDetailVc animated:YES];
}

- (void)addMJ{
    
    HitoWeakSelf;
    //上拉加载
    LERefreshStateNoMoreDataText = @"评论已加载完";
    LERefreshFooter *refreshFooter = [LERefreshFooter footerWithRefreshingBlock:^{
        if (![WeakSelf.tableView.mj_footer isRefreshing]) {
            return;
        }
        [WeakSelf getNewsCommentsRequest];
    }];
    self.tableView.mj_footer = refreshFooter;
    [self.tableView.mj_footer setHidden:YES];
}

- (void)prepareCommentHandle{
    
    NSString *placeholder = @"回复：";
    if (_currentCommentModel) {
        NSString *userName = _currentCommentModel.userName;
        if (userName.length == 0) userName = @"";
        placeholder = [NSString stringWithFormat:@"回复：%@",userName];
        
    }else if (_currentReplyModel){
        NSString *userName = _currentReplyModel.userName;
        if (userName.length == 0) userName = @"";
        placeholder = [NSString stringWithFormat:@"回复：%@",userName];
    }
    
    _huView.hufuTF.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(13) color:kAppSubTitleColor];
    
    [_huView.hufuTF becomeFirstResponder];
    
    UIWindow *window = HitoApplication;
    [window addSubview:_huView];
    if (_huView.hufuTF.isFirstResponder) {
        CGPoint offset = self.tableView.contentOffset;
        offset.y = _currentRect.origin.y + _currentRect.size.height - (self.view.bounds.size.height - _keyBoardHeight - 49);
        [self.tableView setContentOffset:offset animated:YES];
        HitoWeakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            WeakSelf.huView.frame = CGRectMake(0, HitoScreenH - WeakSelf.keyBoardHeight - 49, HitoScreenW, 49);
        }];
    }
}

- (NSMutableArray *)outputRecursion:(NSArray *)comments result:(NSMutableArray *)result{
    
    [comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[LEReplyCommentModel class]]) {
            LEReplyCommentModel *replyModel = (LEReplyCommentModel *)obj;
            [result addObject:replyModel];
            if (replyModel.children.count > 0) {
                [self outputRecursion:replyModel.children result:result withReplyModel:replyModel];
            }
        }
    }];
    return result;
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
- (void)getNewsDetailRequest{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"id"];
    NSString *caCheKey = [NSString stringWithFormat:@"GetDetail%@",_newsId];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        WeakSelf.newsDetailModel = [[LENewsDetailModel alloc] init];
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:dataObject];
        if (array.count > 0) {
            WeakSelf.newsDetailModel.info = [array objectAtIndex:0];
        }
        [WeakSelf setData];
        //
        [WeakSelf finishTaskRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)checkFavoriteNewsRequest{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"CheckFavoriteNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        self->_isCollect = [dataObject boolValue];
        WeakSelf.collectButton.selected = self->_isCollect;
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (void)getNewsCommentsRequest{
    
    HitoWeakSelf;
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"GetComment"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    [params setObject:[NSNumber numberWithInteger:self.nextCursor] forKey:@"page"];
    [params setObject:[NSNumber numberWithInteger:DATA_LOAD_PAGESIZE_COUNT] forKey:@"limit"];
    [params setObject:[LELoginUserManager userID]?[LELoginUserManager userID]:@"" forKey:@"userId"];

    NSString *caCheKey = [NSString stringWithFormat:@"GetComment%@",_newsId];
    BOOL needCache = NO;
    if (self.nextCursor == 1) needCache = YES;
    
    [self.networkManager POST:requestUrl needCache:needCache caCheKey:caCheKey parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {

        [WeakSelf.tableView.mj_footer endRefreshing];

        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        NSArray *array = [NSArray modelArrayWithClass:[LENewsCommentModel class] json:[dataObject objectForKey:@"data"]];
        
        //重新计算评论array
        NSMutableArray *comments = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
//            NSMutableArray *children = [NSMutableArray array];
            if ([obj isKindOfClass:[LENewsCommentModel class]]) {
                LENewsCommentModel *commentModel = (LENewsCommentModel *)obj;
                
                NSMutableArray *childrenResult = [NSMutableArray array];
                [WeakSelf outputRecursion:commentModel.comments result:childrenResult];
                commentModel.comments = childrenResult;
                
//                [commentModel.comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if ([obj isKindOfClass:[LEReplyCommentModel class]]) {
//                        LEReplyCommentModel *replyModel = (LEReplyCommentModel *)obj;
//                        [children addObject:replyModel];
//
//                        for (LEReplyCommentModel *childrenModel in replyModel.children) {
//                            childrenModel.replyuId = replyModel.userId;
//                            childrenModel.replyUserName = replyModel.userName;
//                            [children addObject:childrenModel];
//                        }
//                    }
//                    if ([commentModel.comments lastObject] == obj) {
//                        commentModel.comments = children;
//                        *stop = YES;
//                    }
//                }];
                
                [comments addObject:commentModel];
            }
        }];
        
        
        if (WeakSelf.nextCursor == 1) {
            WeakSelf.commentLists = [[NSMutableArray alloc] init];
        }
        [WeakSelf.commentLists addObjectsFromArray:comments];

        
        if (!isCache) {
            if (array.count < DATA_LOAD_PAGESIZE_COUNT) {
                [WeakSelf.tableView.mj_footer setHidden:NO];
                [WeakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [WeakSelf.tableView.mj_footer setHidden:NO];
                WeakSelf.nextCursor ++;
                [WeakSelf.tableView.mj_footer resetNoMoreData];
            }
        }
        if (WeakSelf.commentLists.count == 0) {
            [WeakSelf.tableView.mj_footer setHidden:YES];
            [WeakSelf.tableView.mj_footer resetNoMoreData];
        }

        [WeakSelf.tableView reloadData];

    } failure:^(id responseObject, NSError *error) {

        [WeakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)sendCommentRequestWith:(NSString *)text{
    
    [self hufuTFResignFirstResponder];
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
    NSString *parentId = nil;
    if (_currentCommentModel) {
        parentId = _currentCommentModel.commentId;
    }else if (_currentReplyModel){
        parentId = _currentReplyModel.commentId;
    }
    if (parentId) [params setObject:parentId forKey:@"parentId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        self->_currentReplyModel = nil;
        self->_currentCommentModel = nil;
        [SVProgressHUD showCustomSuccessWithStatus:@"评论成功"];
        
        WeakSelf.huView.hufuTF.text = nil;
        
        WeakSelf.nextCursor = 1;
        WeakSelf.commentLists = [[NSMutableArray alloc] init];
        [WeakSelf getNewsCommentsRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (void)favourRequestWithCommentModel:(LENewsCommentModel *)commentModel headerView:(CommontHeaderView *)headerView section:(NSInteger)section{
    
    [self hufuTFResignFirstResponder];
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
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [params setObject:commentModel.commentId forKey:@"commentId"];
    [params setObject:[NSNumber numberWithBool:like] forKey:@"doLike"];
    [params setObject:[NSNumber numberWithInt:0] forKey:@"isCancel"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        commentModel.favour = !commentModel.favour;
//        [WeakSelf.tableView reloadData];
        
        headerView.favourImageView.highlighted = !headerView.favourImageView.highlighted;
        if (headerView.favourImageView.highlighted) {
            commentModel.favourNum ++;
            [WYCommonUtils popOutsideWithDuration:0.5 view:headerView.favourImageView];
        }else{
            commentModel.favourNum --;
            [WYCommonUtils popInsideWithDuration:0.4 view:headerView.favourImageView];
        }
        if (commentModel.favourNum <= 0) {
            commentModel.favourNum = 0;
        }
        headerView.favourLabel.text = [NSString stringWithFormat:@"%d",commentModel.favourNum];
        
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (void)collectRequest{
    
    if ([[LELoginManager sharedInstance] needUserLogin:self]) {
        return;
    }
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SaveFavoriteNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:@"收藏成功"];
        WeakSelf.collectButton.selected = !WeakSelf.collectButton.selected;
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)finishTaskRequest{
    
    if (_isFromPush) {
        LETaskListModel *taskModel = [[LELoginAuthManager sharedInstance] getTaskWithTaskType:LETaskCenterTypeReadPushInformation];
        [[LELoginAuthManager sharedInstance] updateUserTaskStateRequestWith:taskModel.taskId success:^(BOOL success) {
            [MBProgressHUD showCustomGoldTipWithTask:@"阅读推送" gold:[NSString stringWithFormat:@"+%d",[taskModel.coin intValue]]];
        }];
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (CommontHFView *)huView {
    if (!_huView) {
        _huView = [[[NSBundle mainBundle] loadNibNamed:@"CommontHFView" owner:self options:nil] firstObject];
        _huView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 49);
        HitoWeakSelf;
        _huView.commontViewWithSendBlcok = ^(NSString *message) {
            [WeakSelf sendCommentRequestWith:message];
        };
    }
    return _huView;
}

- (LENewsDetailHeaderView *)newsDetailHeaderView{
    if (!_newsDetailHeaderView) {
        _newsDetailHeaderView = [[LENewsDetailHeaderView alloc] init];
    }
    return _newsDetailHeaderView;
}

- (LENewsDetailContentView *)newsDetailContentView{
    if (!_newsDetailContentView) {
        _newsDetailContentView = [[LENewsDetailContentView alloc] init];
    }
    return _newsDetailContentView;
}

- (LENewsCommentHeadView *)newsCommentHeadView{
    if (!_newsCommentHeadView) {
        _newsCommentHeadView = [[LENewsCommentHeadView alloc] init];
    }
    return _newsCommentHeadView;
}

#pragma mark -
#pragma mark - IBActions
- (IBAction)favoAction:(UIButton *)sender {
    [self collectRequest];
}


- (IBAction)commentAction:(UIButton *)sender {
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    CGPoint offset = self.tableView.contentOffset;
    offset.y = self.tableView.tableHeaderView.height-37;
    [self.tableView setContentOffset:offset animated:YES];
}

- (IBAction)shareAction:(UIButton *)sender {
    
    _shareSheetView = [[LEShareSheetView alloc] init];
    _shareSheetView.owner = self;
    _shareSheetView.newsModel = self.newsDetailModel.info;
    [_shareSheetView showShareAction];
    
//    LEShareWindow *shareWindow = [[LEShareWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [shareWindow setCustomerSheet];
}

static int commentMaxCount = 10;
#pragma mark - UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LENewsCommentModel *commentModel = self.commentLists[section];
    if (commentModel.comments.count == 0) {
        return commentModel.comments.count;
    }
    
    //最多显示评论数
    int count = (int)commentModel.comments.count;
    if (count > commentMaxCount) {
        count = commentMaxCount;
    }
    return count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsCommentModel *commentModel = self.commentLists[indexPath.section];
    
    int count = (int)commentModel.comments.count;
    if (count > commentMaxCount) {
        count = commentMaxCount;
    }
    
    if (indexPath.row == count) {
        static NSString *cellIdentifier = @"LECommentMoreCell";
        LECommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LECommentMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (commentModel.comments.count > count) {
            [cell setCommentMoreCellType:LECommentMoreCellTypeMore];
            
            HitoWeakSelf;
            cell.commentMoreClickBolck = ^{
//                LELog(@"----%ld",indexPath.section);
                [WeakSelf showCommentDetailVcWithSection:indexPath.section];
            };
        }else{
            [cell setCommentMoreCellType:LECommentMoreCellTypeNormal];
        }
        
        return cell;
    }
    
    LEReplyCommentModel *replyModel = commentModel.comments[indexPath.row];
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    [cell updateHeaderData:replyModel];
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerIdentifier = @"CommontHeaderView";
    CommontHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (!header) {
        header = [[CommontHeaderView alloc] initWithReuseIdentifier:headerIdentifier];
    }
    
    LENewsCommentModel *commentModel = self.commentLists[section];
    [header updateHeaderData:commentModel];
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
    
    LENewsCommentModel *commentModel = self.commentLists[indexPath.section];
    
    if (indexPath.row == commentModel.comments.count) {
        return;
    }
    _currentCommentModel = nil;
    _currentReplyModel = commentModel.comments[indexPath.row];
    if ([WYCommonUtils isEqualWithUserId:_currentReplyModel.userId]) {
        _currentReplyModel = nil;
        [SVProgressHUD showCustomInfoWithStatus:@"不能回复自己"];
        return;
    }
//    _selectedCommentCell = [tableView cellForRowAtIndexPath:indexPath];
    _currentRect = [tableView rectForRowAtIndexPath:indexPath];
    
    [self prepareCommentHandle];
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

#pragma mark -
#pragma mark - CommontViewDelegate
- (void)commentWithCancelClick{
    [self removeBV];
}

- (void)commentWithSendClick:(NSString *)text{
    [self sendCommentRequestWith:text];
    [self removeBV];
}

- (void)commentWithContentText:(NSString *)text{
    
}

#pragma mark -
#pragma mark - CommontHeaderViewDelegate
- (void)commentHeaderWithFavourClick:(NSInteger)section headerView:(CommontHeaderView *)headerView{
    
//    CommontHeaderView *header = [self.tableView headerViewForSection:section];
    
    LENewsCommentModel *commentModel = self.commentLists[section];
    [self favourRequestWithCommentModel:commentModel headerView:headerView section:section];
}

- (void)commentHeaderWithCommentClick:(NSInteger)section headerView:(CommontHeaderView *)headerView{
    
    _currentCommentModel = self.commentLists[section];
    _currentReplyModel = nil;
    _currentRect = [self.tableView rectForHeaderInSection:section];
    
    [self prepareCommentHandle];
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
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    _keyBoardHeight = keyboardBounds.size.height;
    HitoWeakSelf;
    if (self.comView.comTextView.isFirstResponder) {
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            WeakSelf.comView.frame = CGRectMake(0, HitoScreenH - WeakSelf.keyBoardHeight - 107, HitoScreenW, 107);
        }];
    }else if (self.huView.hufuTF.isFirstResponder){
        
        CGPoint offset = self.tableView.contentOffset;
        offset.y = _currentRect.origin.y + _currentRect.size.height - (self.view.bounds.size.height - _keyBoardHeight - 49);
        [self.tableView setContentOffset:offset animated:YES];
        
        [UIView animateWithDuration:[duration doubleValue] animations:^{
            WeakSelf.huView.frame = CGRectMake(0, HitoScreenH - WeakSelf.keyBoardHeight - 49, HitoScreenW, 49);
        }];
    }
}


- (void)keyboardDidShow:(NSNotification *)sender {

    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}

- (IBAction)tapActionForBottomView:(UITapGestureRecognizer *)sender {
    
    _currentReplyModel = nil;
    
    UIWindow *window = HitoApplication;
    _tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    _tempView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBV)];
    [_tempView addGestureRecognizer:tap];
    
    _comView = [[[NSBundle mainBundle] loadNibNamed:@"CommontView" owner:self options:nil] firstObject];
    _comView.delegate = self;
//    _comView.comTextView.delegate = self;
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

- (void)hufuTFResignFirstResponder{
    [_huView.hufuTF resignFirstResponder];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.huView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 49);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hufuTFResignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

@end
