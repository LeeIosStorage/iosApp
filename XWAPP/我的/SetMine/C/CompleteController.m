//
//  CompleteController.m
//  XWAPP
//
//  Created by HuiYiShe on 2018/5/2.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "CompleteController.h"
#import "SetNormal.h"
#import "SetPortrait.h"
#import "SetBass.h"
#import "SheetAlert.h"
#import "SetKeyBoard.h"
#import "WYCustomActionSheet.h"
#import "UIImage+ProportionalFill.h"
#import "LELoginModel.h"
#import "ZJUsefulPickerView.h"

@interface CompleteController ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) SetKeyBoard *board;
HitoPropertyNSArray(dataSource);
HitoPropertyFloat(keyBoardHeight);
HitoPropertyNSMutableArray(educationData);
HitoPropertyNSMutableArray(jobData);

@property (strong, nonatomic) LELoginModel *userModel;

@end

@implementation CompleteController

#pragma mark -
#pragma mark - Lifecycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LELog(@"");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Private
- (void)setup{
    
    [self keyBoardNoti];
    
    [self setTitle:@"完善资料"];
    
    self.userModel = [[LELoginModel alloc] init];
    self.userModel.nickname = [LELoginUserManager nickName];
    self.userModel.headImgUrl = [LELoginUserManager headImgUrl];
    self.userModel.sex = [LELoginUserManager sex];
    self.userModel.age = [LELoginUserManager age];
}

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

}



//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
    
    HitoWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        WeakSelf.board.frame = CGRectMake(0, HitoScreenH - 98 - WeakSelf.keyBoardHeight, HitoScreenW, 98);
    }];
    
}



//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
}

- (void)showImageBroswerWithSourceType:(UIImagePickerControllerSourceType )sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [SVProgressHUD showCustomInfoWithStatus:@"请检查是否有相机"];
            return;
        }
    }
    imagePickerController.sourceType = sourceType;
    
    [imagePickerController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [imagePickerController.navigationBar setTranslucent:NO];
    
    imagePickerController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:HitoPFSCRegularOfSize(17)};
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.navigationController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark - Request
- (void)uploadWithImageData:(NSData *)imageData{
    
}

#pragma mark - SetDataSource

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@[@"头像", @"昵称", @"年龄", @"性别", @"职业", @"教育经历"], @[@"账户绑定", @"电话", @"微信"]];
    }
    return _dataSource;
}

- (NSMutableArray *)educationData{
    if (!_educationData) {
        _educationData = [[NSMutableArray alloc] init];
        [_educationData addObjectsFromArray:@[@"小学", @"初中", @"高中/中专", @"大学专科(大专)", @"大学本科(大本)", @"研究生", @"硕士", @"博士"]];
    }
    return _educationData;
}

- (NSMutableArray *)jobData{
    if (!_jobData) {
        _jobData = [[NSMutableArray alloc] init];
        [_jobData addObjectsFromArray:@[@[@"通用岗位", @"IT互联网", @"文化传媒",@"金融",@"培训机构"],
                                        @{@"通用岗位": @[@"销售", @"市场", @"人力资源",@"行政",@"公关"],
                                          @"IT互联网": @[@"开发工程师", @"测试工程师",@"设计师",@"运营师",@"产品经理"],
                                          @"文化传媒": @[@"编辑策划", @"记者",@"艺人",@"经纪人"],
                                          @"金融" : @[@"咨询", @"投行",@"保险",@"财务"],
                                          @"培训机构" : @[@"学生", @"留学生",@"大学生",@"科研人员"]
                                            }
                                        ]];
    }
    return _jobData;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataSource[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SetPortrait *cell = [tableView dequeueReusableCellWithIdentifier:@"SetPortrait"];
            cell.leftLB.text = title;
            [WYCommonUtils setImageWithURL:[NSURL URLWithString:self.userModel.headImgUrl] setImage:cell.portrait setbitmapImage:[UIImage imageNamed:@"LOGO"]];
            return cell;
        } else {
            SetBass *cell = [tableView dequeueReusableCellWithIdentifier:@"SetBass"];
            cell.leftLB.text = title;
            cell.rightLB.textColor = [UIColor colorWithHexString:@"111111"];
            cell.rightIM.image = [UIImage imageNamed:@"task_jiantou"];
            NSString *rightText = @"";
            if ([title isEqualToString:@"昵称"]) {
                rightText = self.userModel.nickname;
            }else if ([title isEqualToString:@"年龄"]) {
                rightText = [NSString stringWithFormat:@"%d岁",[self.userModel.age intValue]];
            }else if ([title isEqualToString:@"性别"]) {
                if ([self.userModel.sex isEqualToString:@"1"]) {
                    rightText = @"女";
                } else {
                    rightText = @"男";
                }
            }else if ([title isEqualToString:@"职业"]) {
                
            }else if ([title isEqualToString:@"教育经历"]) {
                
            }
            
            if (rightText.length == 0) {
                rightText = @"点击填写";
                cell.rightLB.textColor = [UIColor colorWithHexString:@"999999"];
            }
            cell.rightLB.text = rightText;
            
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            SetNormal *cell = [tableView dequeueReusableCellWithIdentifier:@"SetNormal"];
            cell.leftLB.text = title;
            return cell;
        } else {
            SetBass *cell = [tableView dequeueReusableCellWithIdentifier:@"SetBass"];
            cell.leftLB.text = title;
            cell.rightIM.image = [UIImage imageNamed:@"task_jiantou"];
//            if (indexPath.row == 1) {
//                cell.rightIM.hidden = YES;
//            }
            
            cell.rightLB.textColor = [UIColor colorWithHexString:@"111111"];
            NSString *rightText = @"";
            if ([title isEqualToString:@"电话"]) {
                cell.rightIM.image = nil;
                rightText = [self numberSuitScanf:[LELoginUserManager mobile]];
            }else if ([title isEqualToString:@"微信"]) {
                if (rightText.length == 0) {
                    rightText = @"绑定微信";
                    cell.rightLB.textColor = [UIColor colorWithHexString:@"999999"];
                }
            }
            
            cell.rightLB.text = rightText;
            
            return cell;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 75;
        }
    }
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self addWindow:indexPath];
}

- (void)addWindow:(NSIndexPath *)indexPath {
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row];
    if ([title isEqualToString:@"头像"]) {
        HitoWeakSelf;
        WYCustomActionSheet *actionSheet = [[WYCustomActionSheet alloc] initWithTitle:nil actionBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [WeakSelf showImageBroswerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            } else if (buttonIndex == 1){
                [WeakSelf showImageBroswerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机拍照",@"相册选择"]];
        
        [actionSheet showInView:self.view];
    }else if ([title isEqualToString:@"昵称"]) {
        [self editNickNameShow];
    }else if ([title isEqualToString:@"年龄"]) {
        [self editAgeShow];
    }else if ([title isEqualToString:@"性别"]) {
        
        HitoWeakSelf;
        WYCustomActionSheet *actionSheet = [[WYCustomActionSheet alloc] initWithTitle:nil actionBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                WeakSelf.userModel.sex = @"0";
            } else if (buttonIndex == 1){
                WeakSelf.userModel.sex = @"1";
            }
            [WeakSelf.tableView reloadData];
        } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"男",@"女"]];
        
        [actionSheet showInView:self.view];
        
    }else if ([title isEqualToString:@"职业"]) {
        [self editJobShow];
    }else if ([title isEqualToString:@"教育经历"]) {
        [self editEducationShow];
    }else if ([title isEqualToString:@"电话"]) {
        
    }else if ([title isEqualToString:@"微信"]) {
        
    }
}

#pragma mark - edit
- (void)editNickNameShow{
    
    UIWindow *window = HitoApplication;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    backView.backgroundColor = kAppMaskOpaqueBlackColor;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBV:)];
//    [backView addGestureRecognizer:tap];
    
    _board = [[[NSBundle mainBundle] loadNibNamed:@"SetKeyBoard" owner:self options:nil] firstObject];
    _board.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 98);
    [_board.nameTF becomeFirstResponder];
    
    [_board clickCancelBlock:^{
        [backView removeFromSuperview];
    }];
    HitoWeakSelf;
    [_board clickSureBlock:^{
        WeakSelf.userModel.nickname = WeakSelf.board.nameTF.text;
        [WeakSelf.tableView reloadData];
        [backView removeFromSuperview];
    }];
    [backView addSubview:_board];
    [window addSubview:backView];
}

- (void)removeBV:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}

- (void)editAgeShow{
    
    ZJUsefulPickerView *pickerView = [ZJUsefulPickerView showDatePickerWithToolBarText:nil withStyle:nil withCancelHandler:^{
        
    } withDoneHandler:^(NSDate *selectedDate) {
//        pickerView
    }];
    
}

- (void)editJobShow{
    
    [ZJUsefulPickerView showMultipleAssociatedColPickerWithToolBarText:nil withDefaultValues:nil withData:self.jobData withCancelHandler:^{
        
    } withDoneHandler:^(NSArray *selectedValues) {
        NSLog(@"%@---", selectedValues);
    }];
}

- (void)editEducationShow{
    [ZJUsefulPickerView showSingleColPickerWithToolBarText:nil withData:self.educationData withDefaultIndex:0 withCancelHandler:^{
        
        
    } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        NSLog(@"%@---%ld", selectedValue, selectedIndex);
        
    }];
}

#pragma mark -
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString  *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    {
        UIImage* imageAfterScale = image;
        if (image.size.width != image.size.height) {
            CGSize cropSize = image.size;
            cropSize.height = MIN(image.size.width, image.size.height);
            cropSize.width = MIN(image.size.width, image.size.height);
            imageAfterScale = [image imageCroppedToFitSize:cropSize];
        }
//        _avatarImage = imageAfterScale;
        NSData* imageData = UIImageJPEGRepresentation(imageAfterScale, WY_IMAGE_COMPRESSION_QUALITY);
        [self uploadWithImageData:imageData];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
