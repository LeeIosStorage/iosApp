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
HXPhotoViewDelegate
>

@property (strong, nonatomic) NSMutableArray *uploadImageDatas;
@property (strong, nonatomic) NSMutableArray *uploadVideoUrls;

@property (strong, nonatomic) HXPhotoManager *photoManager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property (strong, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UILabel *tipTextLabel;

@property (strong, nonatomic) UIButton *publishButton;

@end

@implementation LEPublishNewsViewController

#pragma mark -
#pragma mark - Lifecycle
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftBarButtonItemWithTitle:@"取消" color:[UIColor blackColor]];
    [self setTitle:@"我要投稿"];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(kPhotoViewMargin);
//        make.right.equalTo(self.view).offset(-kPhotoViewMargin);
        make.top.equalTo(self.scrollView).offset(kPhotoViewMargin);
        make.height.mas_equalTo(0);
        make.width.mas_equalTo(HitoScreenW-kPhotoViewMargin*2);
    }];
    
    [self.scrollView addSubview:self.tipTextLabel];
    [self.tipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(kPhotoViewMargin);
        make.width.mas_equalTo(HitoScreenW-kPhotoViewMargin*2);
        make.top.equalTo(self.photoView.mas_bottom).offset(5);
    }];

    [self.view addSubview:self.publishButton];
    [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kPhotoViewMargin);
        make.right.equalTo(self.view).offset(-kPhotoViewMargin);
        make.bottom.equalTo(self.view).offset(-kPhotoViewMargin);
        make.height.mas_equalTo(44);
    }];
    
}

#pragma mark -
#pragma mark - IBActions
- (void)leftButtonClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
//        _photoView.backgroundColor = kAppThemeColor;
    }
    return _photoView;
}

- (UILabel *)tipTextLabel{
    if (!_tipTextLabel) {
        _tipTextLabel = [[UILabel alloc] init];
        _tipTextLabel.textColor = kAppTitleColor;
        _tipTextLabel.font = HitoPFSCRegularOfSize(14);
        _tipTextLabel.numberOfLines = 0;
        _tipTextLabel.text = @"注：若您未输入文章标题，则默认您同意授权本平台自拟标题";
    }
    return _tipTextLabel;
}

- (UIButton *)publishButton{
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_publishButton setTitle:@"提交" forState:UIControlStateNormal];
        [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishButton.titleLabel.font = HitoPFSCRegularOfSize(16);
        _publishButton.backgroundColor = kAppThemeColor;
        _publishButton.layer.cornerRadius = 8;
        _publishButton.layer.masksToBounds = YES;
    }
    return _publishButton;
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
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin);
    [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetMaxY(frame));
    }];
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
