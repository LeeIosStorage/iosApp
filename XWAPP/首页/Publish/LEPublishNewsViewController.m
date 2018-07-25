//
//  LEPublishNewsViewController.m
//  XWAPP
//
//  Created by hys on 2018/7/18.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEPublishNewsViewController.h"
#import <HXPhotoPicker/HXPhotoPicker.h>

static const CGFloat kPhotoViewMargin = 12.0;

@interface LEPublishNewsViewController ()
<
HXPhotoViewDelegate,
UITextViewDelegate,
UITextFieldDelegate
>
{
    BOOL _viewDidLoad;
}

@property (strong, nonatomic) NSMutableArray *uploadImageDatas;
@property (strong, nonatomic) NSMutableArray *uploadVideoUrls;

@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *contentView;//爆料内容
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) UILabel *numTipLabel;

@property (strong, nonatomic) UILabel *resourceTipLabel;//上传图片/视频

@property (strong, nonatomic) UIView *titleView;//爆料标题
@property (strong, nonatomic) UITextField *titleTextField;
@property (strong, nonatomic) UILabel *tipTextLabel; //底部提示语

@property (strong, nonatomic) UIButton *publishButton;

@end

@implementation LEPublishNewsViewController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_vcType == LEPublishNewsVcTypeVideo && !_viewDidLoad) {
        if (self.videoCamera) {
            [self.photoView goCameraViewController];
        }else{
            [self.photoView directGoPhotoViewController];
        }
        _viewDidLoad = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Private
- (void)setup{
    
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftBarButtonItemWithTitle:@"取消" color:[UIColor blackColor]];
    [self setTitle:@"我要投稿"];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 86, 0));
    }];
    
    if (_vcType == LEPublishNewsVcTypePhoto) {
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(kPhotoViewMargin);
            make.top.equalTo(self.scrollView).offset(0);
            make.width.mas_equalTo(HitoScreenW-kPhotoViewMargin*2);
        }];
    }
    
    [self.scrollView addSubview:self.resourceTipLabel];
    [self.resourceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(kPhotoViewMargin);
        if (self.vcType == LEPublishNewsVcTypePhoto) {
            make.top.equalTo(self.contentView.mas_bottom).offset(18);
        }else{
            make.top.equalTo(self.scrollView).offset(18);
        }
        make.width.mas_equalTo(HitoScreenW-kPhotoViewMargin*2);
        make.height.mas_equalTo(20);
    }];
    
    [self.scrollView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(kPhotoViewMargin);
        make.top.equalTo(self.resourceTipLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(HitoScreenW-kPhotoViewMargin*2);
    }];
    
    [self.scrollView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(kPhotoViewMargin);
        make.top.equalTo(self.photoView.mas_bottom).offset(18);
        make.width.mas_equalTo(HitoScreenW-kPhotoViewMargin*2);
    }];
    

    [self.view addSubview:self.publishButton];
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kPhotoViewMargin);
        make.right.equalTo(self.view).offset(-kPhotoViewMargin);
        make.bottom.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(44);
    }];
    
}

- (NSInteger)refreshTipLabel{
    NSInteger length = 500 - self.contentTextView.text.length;
    self.numTipLabel.text = [NSString stringWithFormat:@"还剩%ld字",length];
    self.numTipLabel.textColor = [UIColor colorWithHexString:@"999999"];
    if (length < 0) {
        self.numTipLabel.textColor = [UIColor redColor];
    }
    return length;
}

#pragma mark -
#pragma mark - Request
- (void)uploadImageNewsRequest{
    
    if (self.contentTextView.text.length < 10) {
        [SVProgressHUD showCustomInfoWithStatus:@"爆料的内容少于10个字"];
        return;
    }
    self.titleTextField.text = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (self.titleTextField.text.length == 0) {
//
//    }
    
    NSArray *imageDatas = [NSArray arrayWithArray:self.uploadImageDatas];
    
    self.publishButton.enabled = NO;
    HitoWeakSelf;
    [SVProgressHUD showCustomWithStatus:@"正在提交..."];
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"uploadNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.contentTextView.text forKey:@"content"];
    if (self.titleTextField.text.length > 0) [params setObject:self.titleTextField.text forKey:@"title"];
    [self.networkManager POST:requestUrl formFileName:@"file" fileName:@"img.jpg" fileData:imageDatas mimeType:@"image/jpeg" parameters:params responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            WeakSelf.publishButton.enabled = YES;
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:@"感谢您的投稿,等待审核."];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf backLastViewController];
        });
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        float progress = (float)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        LELog(@"上传进度:(progress:%f)---<%@>",progress,uploadProgress.localizedDescription);
        [SVProgressHUD showCustomProgress:progress status:@"正在提交"];
        
    } failure:^(id responseObject, NSError *error) {
        WeakSelf.publishButton.enabled = YES;
    }];
    
}

- (void)uploadVideoNewsRequest{
    
    NSArray *videoData = nil;
    if (self.uploadVideoUrls.count > 0) {
        videoData = [NSArray arrayWithObject:[NSData dataWithContentsOfURL:self.uploadVideoUrls[0]]];
    }
    
    self.publishButton.enabled = NO;
    
    self.titleTextField.text = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    HitoWeakSelf;
    [SVProgressHUD showCustomWithStatus:@"正在提交..."];
    NSString *requestUrl = [[WYAPIGenerate sharedInstance] API:@"uploadVideo"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.titleTextField.text.length > 0) [params setObject:self.titleTextField.text forKey:@"title"];
    [self.networkManager POST:requestUrl formFileName:@"file" fileName:@"video.mp4" fileData:videoData mimeType:@"video/mp4" parameters:params responseClass:nil success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            WeakSelf.publishButton.enabled = YES;
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:@"感谢您的投稿,等待审核."];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WeakSelf backLastViewController];
        });
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        float progress = (float)uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        LELog(@"上传进度:(progress:%f)---<%@>",progress,uploadProgress.localizedDescription);
        [SVProgressHUD showCustomProgress:progress status:@"正在提交"];
        
    } failure:^(id responseObject, NSError *error) {
        WeakSelf.publishButton.enabled = YES;
    }];
}

#pragma mark -
#pragma mark - IBActions
- (void)leftButtonClicked:(id)sender{
    
    BOOL show = (self.contentTextView.text.length > 0 || self.uploadImageDatas.count > 0 || self.uploadVideoUrls.count > 0);
    if (!show) {
        [self backLastViewController];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已输入内容确认退出?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    HitoWeakSelf;
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [WeakSelf backLastViewController];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)backLastViewController{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)publishAction:(id)sender{
    if (_vcType == LEPublishNewsVcTypeVideo) {
        [self uploadVideoNewsRequest];
    }else{
        [self uploadImageNewsRequest];
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (void)setVcType:(LEPublishNewsVcType)vcType{
    _vcType = vcType;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

- (HXPhotoManager *)photoManager{
    if (!_photoManager) {
        
        HXPhotoManagerSelectedType type = HXPhotoManagerSelectedTypePhoto;
        if (_vcType == LEPublishNewsVcTypeVideo) {
            type = HXPhotoManagerSelectedTypeVideo;
        }
        _photoManager = [[HXPhotoManager alloc] initWithType:type];
        _photoManager.configuration.openCamera = YES;
        _photoManager.configuration.saveSystemAblum = YES;
        _photoManager.configuration.themeColor = kAppThemeColor;
        _photoManager.configuration.lookLivePhoto = YES;
        _photoManager.configuration.photoMaxNum = 9;
        _photoManager.configuration.videoMaxNum = 1;
        _photoManager.configuration.videoMaxDuration = 500.f;
        _photoManager.configuration.showDateSectionHeader = NO;
        _photoManager.configuration.selectTogether = NO;
        _photoManager.configuration.photoCanEdit = NO;
        _photoManager.configuration.hideOriginalBtn = YES;
        _photoManager.configuration.reverseDate = YES;
    }
    return _photoManager;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (HXPhotoView *)photoView{
    if (!_photoView) {
        _photoView = [HXPhotoView photoManager:self.photoManager];
        _photoView.delegate = self;
        _photoView.outerCamera = YES;
        _photoView.previewShowDeleteButton = YES;
        _photoView.showAddCell = YES;
        [_photoView.collectionView reloadData];
    }
    return _photoView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = kAppTitleColor;
        tipLabel.font = HitoPFSCRegularOfSize(17);
        tipLabel.text = @"爆料内容：";
        [_contentView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_contentView);
            make.top.equalTo(self->_contentView).offset(18);
            make.height.mas_equalTo(20);
        }];
        
        UITextView *textView = [[UITextView alloc] init];
        textView.layer.cornerRadius = 8;
        textView.layer.masksToBounds = YES;
        textView.textColor = kAppTitleColor;
        textView.font = HitoPFSCRegularOfSize(15);
        textView.delegate = self;
        _contentTextView = textView;
        [_contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_contentView);
            make.top.equalTo(tipLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(150);
        }];
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.backgroundColor = [UIColor whiteColor];
        placeholderLabel.textColor = [UIColor colorWithHexString:@"a9a9aa"];
        placeholderLabel.font = HitoPFSCRegularOfSize(15);
        placeholderLabel.text = @"请输入您要爆料的内容，越详细越好，10-500字之间";
        placeholderLabel.numberOfLines = 0;
        _placeholderLabel = placeholderLabel;
        [_contentView addSubview:placeholderLabel];
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_contentView).offset(6);
            make.right.equalTo(self->_contentView).offset(-6);
            make.top.equalTo(textView).offset(6);
        }];
        
        UILabel *numTipLabel = [[UILabel alloc] init];
        numTipLabel.backgroundColor = [UIColor whiteColor];
        numTipLabel.textColor = [UIColor colorWithHexString:@"999999"];
        numTipLabel.layer.cornerRadius = 3;
        numTipLabel.layer.masksToBounds = YES;
        numTipLabel.font = HitoPFSCRegularOfSize(14);
        numTipLabel.text = @"还剩500字";
        numTipLabel.numberOfLines = 0;
        _numTipLabel = numTipLabel;
        [_contentView addSubview:numTipLabel];
        [numTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self->_contentView).offset(-6);
            make.right.equalTo(self->_contentView).offset(-6);
        }];
        
    }
    return _contentView;
}

- (UILabel *)resourceTipLabel{
    if (!_resourceTipLabel) {
        _resourceTipLabel = [[UILabel alloc] init];
        _resourceTipLabel.textColor = kAppTitleColor;
        _resourceTipLabel.font = HitoPFSCRegularOfSize(17);
        _resourceTipLabel.text = @"上传图片：";
        if (_vcType == LEPublishNewsVcTypeVideo) {
            _resourceTipLabel.text = @"上传视频：";
        }
        
    }
    return _resourceTipLabel;
}

- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = kAppTitleColor;
        tipLabel.font = HitoPFSCRegularOfSize(17);
        tipLabel.text = @"文章标题：";
        if (_vcType == LEPublishNewsVcTypeVideo) {
            tipLabel.text = @"视频标题：";
        }
        [_titleView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self->_titleView);
            make.height.mas_equalTo(20);
        }];
        
        UIView *tmpView = [[UIView alloc] init];
        tmpView.backgroundColor = [UIColor whiteColor];
        tmpView.layer.cornerRadius = 8;
        tmpView.layer.masksToBounds = YES;
        [_titleView addSubview:tmpView];
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_titleView);
            make.top.equalTo(tipLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(44);
        }];
        
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = kAppTitleColor;
        textField.font = HitoPFSCRegularOfSize(15);
        textField.delegate = self;
        textField.borderStyle = UITextBorderStyleNone;
        NSString *placeholder = @"请输入文章标题，20字以内";
        textField.attributedPlaceholder = [WYCommonUtils stringToColorAndFontAttributeString:placeholder range:NSMakeRange(0, placeholder.length) font:HitoPFSCRegularOfSize(14) color:[UIColor colorWithHexString:@"a9a9aa"]];
        _titleTextField = textField;
        [tmpView addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tmpView).offset(12);
            make.right.equalTo(tmpView).offset(-12);
            make.top.equalTo(tmpView).offset(4);
            make.bottom.equalTo(tmpView).offset(-4);
        }];
        
        [_titleView addSubview:self.tipTextLabel];
        [self.tipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_titleView);
            make.top.equalTo(tmpView.mas_bottom).offset(10);
        }];
        
    }
    return _titleView;
}

- (UILabel *)tipTextLabel{
    if (!_tipTextLabel) {
        _tipTextLabel = [[UILabel alloc] init];
        _tipTextLabel.textColor = kAppSubTitleColor;
        _tipTextLabel.font = HitoPFSCRegularOfSize(12);
        _tipTextLabel.numberOfLines = 0;
        NSString *text = @"注：若您未输入文章标题，则默认您同意授权本平台自拟标题";
        _tipTextLabel.attributedText = [WYCommonUtils stringToColorAndFontAttributeString:text range:NSMakeRange(0, 2) font:HitoPFSCRegularOfSize(12) color:kAppThemeColor];
    }
    return _tipTextLabel;
}

- (UIButton *)publishButton{
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_publishButton setTitle:@"提交" forState:UIControlStateNormal];
        [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_publishButton addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
        _publishButton.titleLabel.font = HitoPFSCRegularOfSize(15);
        _publishButton.backgroundColor = kAppThemeColor;
        _publishButton.layer.cornerRadius = 8;
        _publishButton.layer.masksToBounds = YES;
    }
    return _publishButton;
}

#pragma mark -
#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 282, 0));
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 86, 0));
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if ([self refreshTipLabel] < 0) {
        self.contentTextView.text = [textView.text substringWithRange:NSMakeRange(0, 500)];
    }
    [self refreshTipLabel];
    
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
    }else{
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        return NO;
    }
    
    if (!string.length && range.length > 0) {
        return YES;
    }
    NSString *oldString = [textField.text copy];
    NSString *newString = [oldString stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _titleTextField && textField.markedTextRange == nil) {
        if (newString.length > 20 && textField.text.length >= 20) {
            return NO;
        }
    }
    return YES;
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.contentTextView resignFirstResponder];
    [self.titleTextField resignFirstResponder];
}

#pragma mark -
#pragma mark - HXPhotoViewDelegate

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    //    NSSLog(@"所有:%ld - 照片:%ld - 视频:%ld",allList.count,photos.count,videos.count);
//    NSSLog(@"所有:%@ - 照片:%@ - 视频:%@",allList,photos,videos);
//    for (HXPhotoModel *model in allList) {
//        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
//            NSURL *fileURL = model.fileURL;
//            NSData *videoData = [NSData dataWithContentsOfURL:fileURL];
//            LELog(@"Video fileURL:%@",[fileURL absoluteString]);
//        }else{
//
//            NSURL *fileURL = model.fileURL;
//            NSData *imageData = [NSData dataWithContentsOfURL:fileURL];
//            imageData = [NSData dataWithContentsOfFile:[fileURL absoluteString]];
//            UIImage *image1 = [UIImage imageWithData:imageData];
//            UIImage *image = model.previewPhoto;
//        }
//    }
    
    self.uploadImageDatas = [NSMutableArray array];
    self.uploadVideoUrls = [NSMutableArray array];
    HitoWeakSelf;
    if (photos.count > 0) {
        // 获取图片
        [self.toolManager getSelectedImageList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
            for (UIImage *image in imageList) {
                NSData *imageData = UIImageJPEGRepresentation(image, WY_IMAGE_COMPRESSION_QUALITY);
                [WeakSelf.uploadImageDatas addObject:imageData];
            }
        } failed:^{
            
        }];
    }
    
    if (videos.count > 0) {
        [SVProgressHUD showCustomWithStatus:@"处理中"];
        [HXPhotoTools selectListWriteToTempPath:allList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
//            NSSLog(@"requestIds - image : %@ \nsessions - video : %@",imageRequestIds,videoSessions);
//            [SVProgressHUD dismiss];
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
//            NSSLog(@"allUrl - %@\nimageUrls - %@\nvideoUrls - %@",allUrl,imageUrls,videoUrls);
            LELog(@"videoUrls:%@",videoUrls);
            [SVProgressHUD dismiss];
            for (NSURL *videoUrl in videoUrls) {
                NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
                [WeakSelf.uploadVideoUrls addObject:videoUrl];
            }
        } error:^{
            LELog(@"写入视频失败");
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)photoView:(HXPhotoView *)photoView imageChangeComplete:(NSArray<UIImage *> *)imageList {
    NSSLog(@"%@",imageList);
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + 106 + 50 + kPhotoViewMargin*2 + 140);
//    [self updateViewConstraints];
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(frame));
    }];
    
    [self.scrollView layoutIfNeeded];
    LELog(@"frame=%@",NSStringFromCGRect(self.titleView.frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.titleView.frame.origin.y + self.titleView.frame.size.height);
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (BOOL)photoViewShouldDeleteCurrentMoveItem:(HXPhotoView *)photoView {
    return YES;
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
//    [UIView animateWithDuration:0.25 animations:^{
//        self.bottomView.alpha = 0.5;
//    }];
//    NSSLog(@"长按手势开始了 - %ld",indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
//    CGPoint point = [longPgr locationInView:self.view];
//    if (point.y >= self.bottomView.hx_y) {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bottomView.alpha = 1;
//        }];
//    }else {
//        [UIView animateWithDuration:0.25 animations:^{
//            self.bottomView.alpha = 0.5;
//        }];
//    }
//    NSSLog(@"长按手势改变了 %@ - %ld",NSStringFromCGPoint(point), indexPath.item);
}
- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
//    CGPoint point = [longPgr locationInView:self.view];
//    if (point.y >= self.bottomView.hx_y) {
//        self.needDeleteItem = YES;
//        [self.photoView deleteModelWithIndex:indexPath.item];
//    }else {
//        self.needDeleteItem = NO;
//    }
    NSSLog(@"长按手势结束了 - %ld",indexPath.item);
//    [UIView animateWithDuration:0.25 animations:^{
//        self.bottomView.alpha = 0;
//    }];
}

@end
