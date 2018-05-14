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

@interface CompleteController ()


@property (nonatomic, strong) SetKeyBoard *board;
HitoPropertyNSArray(dataSource);
HitoPropertyFloat(keyBoardHeight);
@end

@implementation CompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaStyle];
    [self keyBoardNoti];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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


#pragma mark - SetDataSource

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@[@"头像", @"昵称", @"年级", @"性别", @"职业", @"教育经历"], @[@"账户绑定", @"电话", @"微信"]];
    }
    return _dataSource;
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SetPortrait *cell = [tableView dequeueReusableCellWithIdentifier:@"SetPortrait"];
            cell.leftLB.text = self.dataSource[indexPath.section][indexPath.row];
            return cell;
        } else {
            SetBass *cell = [tableView dequeueReusableCellWithIdentifier:@"SetBass"];
            cell.leftLB.text = self.dataSource[indexPath.section][indexPath.row];
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            SetNormal *cell = [tableView dequeueReusableCellWithIdentifier:@"SetNormal"];
            cell.leftLB.text = self.dataSource[indexPath.section][indexPath.row];
            return cell;
        } else {
            SetBass *cell = [tableView dequeueReusableCellWithIdentifier:@"SetBass"];
            cell.leftLB.text = self.dataSource[indexPath.section][indexPath.row];
            if (indexPath.row == 1) {
                cell.rightIM.hidden = YES;
            }
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
    UIWindow *window = HitoApplication;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HitoScreenW, HitoScreenH)];
    backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBV:)];
    [backView addGestureRecognizer:tap];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //相册
            SheetAlert *alert = [[[NSBundle mainBundle] loadNibNamed:@"SheetAlert" owner:self options:nil] firstObject];
            
            [alert clickCancel:^{
                //
                [backView removeFromSuperview];
            }];
            
            [alert clickAlbum:^{
                //
                [backView removeFromSuperview];

            }];
            
            [alert clickCamera:^{
                //
                [backView removeFromSuperview];

            }];
            
            
            alert.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 134);
            [backView addSubview:alert];
            [window addSubview:backView];
            [UIView animateWithDuration:0.3 animations:^{
                alert.frame = CGRectMake(0, HitoScreenH - 134, HitoScreenW, 134);
            }];
        } else if (indexPath.row == 1) {
            _board = [[[NSBundle mainBundle] loadNibNamed:@"SetKeyBoard" owner:self options:nil] firstObject];
            _board.frame = CGRectMake(0, HitoScreenH, HitoScreenW, 98);
            [_board.nameTF becomeFirstResponder];
            
            [_board clickCancelBlock:^{
                [backView removeFromSuperview];
            }];
            [_board clickSureBlock:^{
                [backView removeFromSuperview];
            }];
            
            [backView addSubview:_board];
            [window addSubview:backView];
            

            
        }
    }
}

- (void)removeBV:(UITapGestureRecognizer *)sender {
    [sender.view removeFromSuperview];
}

@end
