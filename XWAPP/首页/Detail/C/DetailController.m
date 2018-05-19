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

@interface DetailController ()
<UIWebViewDelegate,
UITextViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
CommontViewDelegate
>
{
    CGFloat _keyBoardHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) LENewsDetailHeaderView *newsDetailHeaderView;
@property (strong, nonatomic) LENewsDetailContentView *newsDetailContentView;
@property (strong, nonatomic) LENewsCommentHeadView *newsCommentHeadView;

@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) CommontView *comView;
@property (nonatomic, strong) CommontHFView *huView;

@property (strong, nonatomic) NSMutableArray *commentLists;

@end

@implementation DetailController

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    LELog(@"dealloc");
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
    
    [self getNewsCommentsRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [[UITableViewHeaderFooterView appearance] setTintColor:kAppThemeColor];
    
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

#pragma mark -
#pragma mark - Request
- (void)getNewsDetailRequest{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetDetail"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"id"];
    NSString *caCheKey = [NSString stringWithFormat:@"GetDetail%@",_newsId];
    [self.networkManager POST:requesUrl needCache:YES caCheKey:caCheKey parameters:params responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        WeakSelf.newsDetailModel = [[LENewsDetailModel alloc] init];
        NSArray *array = [NSArray modelArrayWithClass:[LENewsListModel class] json:dataObject];
        if (array.count > 0) {
            WeakSelf.newsDetailModel.info = [array objectAtIndex:0];
        }
        [WeakSelf setData];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

- (void)getNewsCommentsRequest{
    
    for (int i = 0; i < 100 ; i ++ ) {
    
        LENewsCommentModel *model = [[LENewsCommentModel alloc] init];
        if (i%2 == 0) {
            
            model.commentId = [NSString stringWithFormat:@"%d",i+1];
            model.content = @"此时，就产生了一个问题：正常情况下， label2 的最右边是不可能只距离父视图20px的，这就使得肯定有一个 UILabel 不能使用它的 intrinsicContentSize 了，那么应该修改哪个 UILabel 的宽度来让 label2 满足这个约束呢？解决方案还是设置优先级，但这次我们需要设置的是两种约束的优先级";
            model.userName = @"疯子";
            model.avatarUrl = @"http://p1.qzone.la/upload/20150102/a3zs6l69.jpg";
            model.date = @"2018-05-19 14:09:09";
            model.area = @"浙江杭州";
            model.favourNum = 2009;
            model.favour = YES;
            
            LEReplyCommentModel *replyModel = [LEReplyCommentModel new];
            replyModel.content = @"李旺回复张三: 当然，你也可以自己通过数字来设置它们的优先级。";
            NSMutableArray *replyMA = [NSMutableArray array];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            model.comments = replyMA;
        }else{
            model.commentId = [NSString stringWithFormat:@"%d",i+1];
            model.content = @"大家可能有时会发现，我们在设置 UILabel 的约束时，可以不设置它的大小约束，这样它就会根据自己的内容（文字）来确定它的大小。如一下场景：";
            model.userName = @"用户昵称";
            model.avatarUrl = @"http://www.qqxoo.com/uploads/allimg/161020/1356023128-13.jpg";
            model.date = @"2018-05-20 14:09:09";
            model.area = @"杭州西湖";
            model.favourNum = 209;
            model.favour = NO;
            
            LEReplyCommentModel *replyModel = [LEReplyCommentModel new];
            replyModel.content = @"李旺回复张三: 两个 UILabel 的宽度和高度都根据它们的内容来设置了。而这是为什么呢？原来 UIView 具有一个属性：";
            NSMutableArray *replyMA = [NSMutableArray array];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            [replyMA addObject:replyModel];
            model.comments = replyMA;
        }
        
        
        [self.commentLists addObject:model];
        
    }
    
    [self.tableView reloadData];
    
}

- (void)sendCommentRequestWith:(NSString *)text{
    
    LELog(@"准备评论<<<<%@>>>>",text);
    if (text.length == 0) {
        return;
    }
    
    [SVProgressHUD showInfoWithStatus:@"请求失败了!"];
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"commentSave"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_newsId.length) [params setObject:_newsId forKey:@"id"];
    if (text.length) [params setObject:text forKey:@"content"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [WeakSelf getNewsCommentsRequest];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
    
}

#pragma mark -
#pragma mark - Set And Getters
- (CommontHFView *)huView {
    if (!_huView) {
        _huView = [[[NSBundle mainBundle] loadNibNamed:@"CommontHFView" owner:self options:nil] firstObject];
        _huView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 49);
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
    
}


- (IBAction)commentAction:(UIButton *)sender {
    
}

- (IBAction)shareAction:(UIButton *)sender {
    
}

#pragma mark - UITableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LENewsCommentModel *commentModel = self.commentLists[section];
    return commentModel.comments.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.commentLists.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LENewsCommentModel *commentModel = self.commentLists[indexPath.section];
    LEReplyCommentModel *replyModel = commentModel.comments[indexPath.row];
    
    if (indexPath.row == commentModel.comments.count-1) {
        static NSString *cellIdentifier = @"LECommentMoreCell";
        LECommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[LECommentMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (commentModel.comments.count > 5) {
            [cell setCommentMoreCellType:LECommentMoreCellTypeMore];
        }else{
            [cell setCommentMoreCellType:LECommentMoreCellTypeNormal];
        }
        
        return cell;
    }
    
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
    CommentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_huView.hufuTF becomeFirstResponder];
    
    CGRect rect = [cell convertRect:cell.frame toView:self.view];

    if (rect.origin.y / 2 + rect.size.height>= HitoScreenH - 216) {
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 216, 0); 
        [_commentTF becomeFirstResponder];
        [_tableView scrollToRowAtIndexPath:[_tableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        HitoWeakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            WeakSelf.huView.frame = CGRectMake(0, HitoScreenH - _keyBoardHeight - 49, HitoScreenW, 49);
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_huView.hufuTF resignFirstResponder];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.huView.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 49);
}


@end
