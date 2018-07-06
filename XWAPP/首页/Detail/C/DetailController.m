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
#import "LERecommendNewsView.h"
#import "HotUpButton.h"
#import "LENewsSourceView.h"

typedef NS_ENUM(NSInteger, LENewsDetailViewCType) {
    LENewsDetailViewCTypeNone         = 0,//图文
    LENewsDetailViewCTypeVideo        = 1,//视频
};

@interface DetailController ()
<UIWebViewDelegate,
UITextViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
CommontViewDelegate,
CommontHeaderViewDelegate,
LEShareSheetViewDelegate,
LECommentCellDelegate
>
{
    CGRect _currentRect;
    
    LEReplyCommentModel *_currentReplyModel;
    LENewsCommentModel *_currentCommentModel;
    
    LENewsCommentModel *_longPressCommentModel;
    
    LEShareSheetView *_shareSheetView;
    
    BOOL _isCollect;
 
    BOOL _bStatusBarHidden;
    UIStatusBarStyle _currentStatusBarStyle;
}

@property (assign, nonatomic) LENewsDetailViewCType vcType;

@property (assign, nonatomic) CGFloat keyBoardHeight;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (assign, nonatomic) CGFloat headerHeight;
@property (strong, nonatomic) LENewsDetailHeaderView *newsDetailHeaderView;
@property (strong, nonatomic) LENewsDetailContentView *newsDetailContentView;
@property (strong, nonatomic) LENewsCommentHeadView *newsCommentHeadView;

@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) CommontView *comView;
@property (nonatomic, strong) CommontHFView *huView;

@property (strong, nonatomic) NSMutableArray *commentLists;
@property (assign, nonatomic) int nextCursor;

@property (strong, nonatomic) NSTimer *readTimer;
@property (assign, nonatomic) int readDuration;

@property (strong, nonatomic) LERecommendNewsView *recommendNewsView;
@property (strong, nonatomic) NSMutableArray *recommendNewsArray;

@property (strong, nonatomic) UILabel *commentCountTipLabel;

@property (strong, nonatomic) LENewsSourceView *newsSourceView;//新闻来源

@property (strong, nonatomic) UIView *videoContainerView;//视频视图

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

- (BOOL)prefersStatusBarHidden {
    return _bStatusBarHidden;
}
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return _currentStatusBarStyle;
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.vcType == LENewsDetailViewCTypeVideo) {
//        [self.navigationItem setHidesBackButton:YES];
//        [self.navigationController.navigationBar setHidden:YES];
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
//        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        _bStatusBarHidden = YES;
        _currentStatusBarStyle = UIStatusBarStyleLightContent;
        [self setNeedsStatusBarAppearanceUpdate];
        [self addVideoView];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startTimer];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
//    [self.navigationController.navigationBar setHidden:NO];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self saveReadLogRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self getNewsDetailRequest];
    [self getRandomNewsRequest];
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
    
//    self.view.backgroundColor = kAppBackgroundColor;

    self.readDuration = 0;
    self.nextCursor = 1;
    self.commentLists = [[NSMutableArray alloc] init];
    self.recommendNewsArray = [[NSMutableArray alloc] init];
    
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
    
    [self.bottomView addSubview:self.commentCountTipLabel];
    [self.commentCountTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.commentButton.mas_right);
        make.centerY.equalTo(self.commentButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(4*2+13, 13));
    }];
    
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
    
    self.newsSourceView.top = 0;
    self.newsSourceView.width = HitoScreenW;
    [self.newsDetailContentView addSubview:self.newsSourceView];
    
    self.recommendNewsView.top = 0;
    self.recommendNewsView.left = 12;
    self.recommendNewsView.width = HitoScreenW-12*2;
    self.recommendNewsView.height = 0;
    [self.newsDetailContentView addSubview:self.recommendNewsView];
    
    self.newsCommentHeadView.top = 0;
    self.newsCommentHeadView.width = HitoScreenW;
    self.newsCommentHeadView.height = 45;
    [self.newsDetailContentView addSubview:self.newsCommentHeadView];
    
    self.tableView.tableHeaderView = self.newsDetailContentView;
    [self.tableView reloadData];
    
    [self addMJ];
    
    [self refreshCommentCountShow];
    
}

- (void)setData{
    
    [self refreshCommentCountShow];
    
    _headerHeight = [self.newsDetailHeaderView updateWithData:self.newsDetailModel.info];
    [self.newsSourceView updateWithData:self.newsDetailModel.info];
    
    NSString *htmlString = nil;
    htmlString = self.newsDetailModel.info.content;
    
    HitoWeakSelf;
    [self parserContentWithHtmlString:htmlString handleSuccessBlcok:^(NSMutableAttributedString *attributedString) {
        
        WeakSelf.newsDetailModel.contentAttributedString = attributedString;
        WeakSelf.newsDetailModel.contentHeight = [NSNumber numberWithFloat:[WeakSelf getAttributedStringHeightWithString:attributedString]];
        [WeakSelf.newsDetailContentView updateWithData:WeakSelf.newsDetailModel];
        [WeakSelf refreshHeadViewShow];
        
    }];
    
    [self.tableView reloadData];
}

- (void)refreshHeadViewShow{
    
    CGFloat recommendViewHeight = self.recommendNewsArray.count*70;
    if (recommendViewHeight > 0) {
        recommendViewHeight += 17;
    }
    
    CGFloat newsSourceHeight = self.newsSourceView.height;
    if (newsSourceHeight == 0) {
        newsSourceHeight = 45;
    }
    
    self.newsDetailContentView.contentLabel.top = _headerHeight + 10;
    self.newsDetailContentView.height = [self.newsDetailModel.contentHeight floatValue] + _headerHeight + self.newsCommentHeadView.height + recommendViewHeight + newsSourceHeight;
    
    self.newsSourceView.top = [self.newsDetailModel.contentHeight floatValue] + _headerHeight;
    self.newsSourceView.height = newsSourceHeight;
//    self.newsSourceView.backgroundColor = kAppThemeColor;
    
    self.recommendNewsView.top = self.newsSourceView.top + self.newsSourceView.height;
    self.recommendNewsView.height = self.recommendNewsArray.count*70;
    
    self.newsCommentHeadView.top = self.recommendNewsView.top + recommendViewHeight;
    
    self.tableView.tableHeaderView = self.newsDetailContentView;
    [self.tableView reloadData];
    
}

- (void)refreshCommentCountShow{
    int commentCount = self.newsDetailModel.info.commentCount;
    self.commentCountTipLabel.hidden = YES;
    if (commentCount > 0) {
        self.commentCountTipLabel.hidden = NO;
        NSString *commentCountStr = [NSString stringWithFormat:@"%d",commentCount];
        self.commentCountTipLabel.text = commentCountStr;
        CGFloat width = [WYCommonUtils widthWithText:commentCountStr font:HitoPFSCRegularOfSize(11) lineBreakMode:NSLineBreakByWordWrapping] + 4*2;
        if (width < 11 + 4*2) {
            width = 11+4*2;
        }
        [self.commentCountTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
    }
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

- (void)startTimer{
    //设置定时器
    if (_readTimer) {
        [self stopTimer];
    }
    _readTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countReadNewsTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_readTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [_readTimer invalidate];
    _readTimer = nil;
}

- (void)countReadNewsTime{
    _readDuration ++;
    LELog(@"read news time:%d秒",_readDuration);
}


- (void)commontLongPressHandle:(CGRect)rect{
    
    [self becomeFirstResponder];
    UIMenuController *menuCtl = [UIMenuController sharedMenuController];
    NSArray *popMenuItems = [NSArray arrayWithObjects:[[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyReplyTextAction:)],[[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(copyReportTextAction:)], nil];
    
    [menuCtl setMenuVisible:NO];
    [menuCtl setMenuItems:popMenuItems];
    [menuCtl setArrowDirection:UIMenuControllerArrowDown];
    [menuCtl setTargetRect:rect inView:self.view];
    [menuCtl setMenuVisible:YES animated:YES];
}

-(void)copyReplyTextAction:(id)sender
{
    UIPasteboard *copyBoard = [UIPasteboard generalPasteboard];
    copyBoard.string = _longPressCommentModel.content;
    [copyBoard setPersistent:YES];
    _longPressCommentModel = nil;
}

-(void)copyReportTextAction:(id)sender
{
    NSString *commentId = _longPressCommentModel.commentId;
    [SVProgressHUD showCustomWithStatus:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showCustomSuccessWithStatus:@"举报成功"];
    });
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    UIMenuController * menuCtl = [UIMenuController sharedMenuController];
//    BOOL bSameMenuInst = menuCtl == sender;
    
    if (action == @selector(copyReplyTextAction:) || action == @selector(copyReportTextAction:)) {
        return YES;
    }
    return NO;
}

#pragma mark - 视频
- (void)addVideoView{
    
    if (!self.videoContainerView) {
        self.videoContainerView = [[UIView alloc] init];
//        self.videoContainerView.backgroundColor = kAppThemeColor;
        [self.view addSubview:self.videoContainerView];
        [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
            make.height.mas_equalTo(HitoActureHeight(200));
        }];
        
        HotUpButton *backButton = [HotUpButton buttonWithType:UIButtonTypeSystem];
        [backButton setImage:[UIImage imageNamed:@"btn_back_pre"] forState:UIControlStateNormal];
        [backButton setTintColor:[UIColor whiteColor]];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoContainerView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoContainerView).offset(12);
            make.top.equalTo(self.videoContainerView).offset(20);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(HitoActureHeight(200), 0, 0, 0));
        }];
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
        [WeakSelf finishTaskRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)getRandomNewsRequest{
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetRandomNews"];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:nil parameters:nil responseClass:nil needHeaderAuth:NO success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:dataObject];
        WeakSelf.recommendNewsArray = [NSMutableArray arrayWithArray:array];
        WeakSelf.recommendNewsView.recommendNewsArray = WeakSelf.recommendNewsArray;
        [WeakSelf refreshHeadViewShow];
        
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
            if (success) {
                [MBProgressHUD showCustomGoldTipWithTask:@"阅读推送" gold:[NSString stringWithFormat:@"+%d",[taskModel.coin intValue]]];
            }
        }];
    }
}

- (void)saveReadLogRequest{
    
//    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"SaveReadLog"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"newsId"];
    if ([LELoginUserManager userID]) [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    if (self.readDuration <= 0) {
        return;
    }
    [params setObject:[NSNumber numberWithInt:self.readDuration] forKey:@"second"];
    
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark - Set And Getters
- (void)setIsVideo:(BOOL)isVideo{
    _isVideo = isVideo;
    if (_isVideo) {
        self.vcType = LENewsDetailViewCTypeVideo;
    }
}

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

- (LERecommendNewsView *)recommendNewsView{
    if (!_recommendNewsView) {
        _recommendNewsView = [[LERecommendNewsView alloc] init];
        
        HitoWeakSelf;
        _recommendNewsView.didSelectRowAtIndex = ^(NSInteger index) {
            LENewsListModel *newsModel = [WeakSelf.recommendNewsArray objectAtIndex:index];
            DetailController *detail = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailController"];
            detail.newsId = newsModel.newsId;
            [WeakSelf.navigationController pushViewController:detail animated:YES];
        };
    }
    return _recommendNewsView;
}

- (UILabel *)commentCountTipLabel{
    if (!_commentCountTipLabel) {
        _commentCountTipLabel = [[UILabel alloc] init];
        _commentCountTipLabel.textColor = [UIColor whiteColor];
        _commentCountTipLabel.font = HitoPFSCRegularOfSize(11);
        _commentCountTipLabel.textAlignment = NSTextAlignmentCenter;
        _commentCountTipLabel.layer.cornerRadius = 6.5;
        _commentCountTipLabel.layer.masksToBounds = YES;
        _commentCountTipLabel.hidden = YES;
        _commentCountTipLabel.backgroundColor = [UIColor colorWithHexString:@"ee3626"];
    }
    return _commentCountTipLabel;
}

- (LENewsSourceView *)newsSourceView{
    if (!_newsSourceView) {
        _newsSourceView = [[LENewsSourceView alloc] init];
    }
    return _newsSourceView;
}

#pragma mark -
#pragma mark - IBActions
- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    cell.delegate = self;
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

- (void)commontViewLongPressAction:(NSInteger)section headerView:(CommontHeaderView *)headerView{
    
    _longPressCommentModel = self.commentLists[section];
    CGRect rect = [headerView convertRect:headerView.contentLabel.frame toView:self.view];
    [self commontLongPressHandle:rect];
}

#pragma mark -
#pragma mark - LECommentCellDelegate
- (void)CommentCellLongPressActionWithCell:(CommentCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        LENewsCommentModel *commentModel = self.commentLists[indexPath.section];
        if (indexPath.row == commentModel.comments.count) {
            return;
        }
        _longPressCommentModel = [[LENewsCommentModel alloc] init];
        LEReplyCommentModel *replyModel = commentModel.comments[indexPath.row];
        _longPressCommentModel.commentId = replyModel.commentId;
        _longPressCommentModel.content = replyModel.content;
        
        CGRect rect = [cell convertRect:cell.contentView.frame toView:self.view];
        [self commontLongPressHandle:rect];
    }
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
