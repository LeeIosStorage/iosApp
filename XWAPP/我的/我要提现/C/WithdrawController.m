//
//  WithdrawController.m
//  XWAPP
//
//  Created by hys on 2018/5/9.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "WithdrawController.h"
#import "LEWithdrawItemView.h"
#import "LEWithdrawModel.h"

@interface WithdrawController ()

@property (strong, nonatomic) UIScrollView *mainScrollView;

@property (strong, nonatomic) UILabel *balanceTipLabel;
@property (strong, nonatomic) UILabel *rmbTipLabel;
@property (strong, nonatomic) UILabel *balanceLabel;

@property (strong, nonatomic) UILabel *withdrawWayLabel;
@property (strong, nonatomic) UIView *withdrawWayView;
@property (strong, nonatomic) NSMutableArray *withdrawWayArray;
@property (assign, nonatomic) int selectedWayIndex;

@property (strong, nonatomic) UILabel *withdrawMoneyLabel;
@property (strong, nonatomic) UIView *withdrawMoneyView;
@property (strong, nonatomic) NSMutableArray *withdrawMoneyArray;
@property (assign, nonatomic) int selectedMoneyIndex;

@property (strong, nonatomic) UIView *warmTipView;
@property (strong, nonatomic) UILabel *warmTipLabel;

@end

@implementation WithdrawController

#pragma mark -
#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaStyle];
    [self setView];
    [self getMoneyListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Private
- (void)setView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowOpacity = 0.8f;
    _bottomView.layer.shadowRadius = 4.0f;
    _bottomView.layer.shadowOffset = CGSizeMake(4,4);
    self.title = @"我要提现";
    
    self.selectedWayIndex = 0;
    self.selectedMoneyIndex = 0;
    
    self.withdrawWayArray = [[NSMutableArray alloc] init];
    self.withdrawMoneyArray = [[NSMutableArray alloc] init];
    /*
    for (int i = 0; i < 2; i ++) {
        LEWithdrawModel *model = [[LEWithdrawModel alloc] init];
        model.title = @"支付宝";
        model.way = 1;
        model.icon = @"mine_logo_zhifubao";
        if (i == 1) {
            model.title = @"微信";
            model.way = 2;
            model.icon = @"mine_logo_weixin";
        }
        [self.withdrawWayArray addObject:model];
        
        
        LEWithdrawModel *moneyModel = [[LEWithdrawModel alloc] init];
        moneyModel.money = @"1";
        moneyModel.wId = [NSString stringWithFormat:@"%d",i+1];
        if (i == 1) {
            moneyModel.money = @"5";
        }
        [self.withdrawMoneyArray addObject:moneyModel];
        
    }
    */
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 56, 0));
    }];
    self.mainScrollView.contentSize = CGSizeMake(HitoScreenW, HitoScreenH-56-HitoTopHeight+1);
    
    [self.bottomView removeFromSuperview];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(56);
    }];
    
    [self addMainScrollView];
}

- (void)addMainScrollView{
    
    [self.mainScrollView addSubview:self.balanceTipLabel];
    [self.balanceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrollView).offset(12);
        make.centerX.equalTo(self.mainScrollView);
        make.width.mas_equalTo(HitoScreenW-12*2);
        make.height.mas_equalTo(13);
    }];
    
    [self.mainScrollView addSubview:self.rmbTipLabel];
    [self.rmbTipLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.rmbTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceTipLabel);
        make.top.equalTo(self.balanceTipLabel.mas_bottom).offset(11);
    }];
    
    [self.mainScrollView addSubview:self.balanceLabel];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.balanceTipLabel);
        make.left.equalTo(self.rmbTipLabel.mas_right).offset(5);
        make.top.equalTo(self.balanceTipLabel.mas_bottom).offset(6);
    }];
    
    [self.mainScrollView addSubview:self.withdrawWayLabel];
    [self.withdrawWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.balanceTipLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(18);
    }];
    
    [self.mainScrollView addSubview:self.withdrawWayView];
    [self.withdrawWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.balanceTipLabel);
        make.top.equalTo(self.withdrawWayLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
    
    [self.mainScrollView addSubview:self.withdrawMoneyLabel];
    [self.withdrawMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.balanceTipLabel);
        make.top.equalTo(self.withdrawWayView.mas_bottom).offset(20);
    }];
    
    [self.mainScrollView addSubview:self.withdrawMoneyView];
    [self.withdrawMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.balanceTipLabel);
        make.top.equalTo(self.withdrawMoneyLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(61);
    }];
    
    [self.mainScrollView addSubview:self.warmTipView];
    [self.warmTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.balanceTipLabel);
        make.top.equalTo(self.withdrawMoneyView.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
    
    [self reloadData];
    [self refeshUI];
}

- (void)refeshUI{
    
    NSString *balanceString = [NSString stringWithFormat:@"%.2f",[LELoginUserManager balance]];
    self.balanceLabel.text = balanceString;
    
    [self.withdrawWayArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LEWithdrawModel class]]) {
            LEWithdrawModel *model = (LEWithdrawModel *)obj;
            model.isSelected = NO;
            if (idx == self->_selectedWayIndex) {
                model.isSelected = YES;
            }
            LEWithdrawItemView *itemView = (LEWithdrawItemView *)[self.withdrawWayView viewWithTag:idx+10];
            if (itemView) {
                [itemView updateItemViewData:model];
            }
        }
    }];
    
    [self.withdrawMoneyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LEWithdrawModel class]]) {
            LEWithdrawModel *model = (LEWithdrawModel *)obj;
            model.isSelected = NO;
            if (idx == self->_selectedMoneyIndex) {
                model.isSelected = YES;
            }
            LEWithdrawItemView *itemView = (LEWithdrawItemView *)[self.withdrawMoneyView viewWithTag:idx+10];
            if (itemView) {
                [itemView updateItemViewData:model];
            }
        }
    }];
    
}

- (void)reloadData{
    [self.withdrawMoneyView removeAllSubviews];
    CGFloat width = (HitoScreenW-12*2-2*18)/3;
    CGFloat height = 61;
    int index = 0;
    for (LEWithdrawModel *model in self.withdrawMoneyArray) {
        int line = index%3;
        int row = index/3;
        CGFloat left = line*(width+18);
        CGFloat top = row*(height+18);
        LEWithdrawItemView *itemView = [[LEWithdrawItemView alloc] init];
        itemView.tag = index+10;
        [itemView.clickButton addTarget:self action:@selector(moneyClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [itemView updateItemViewData:model];
        [self.withdrawMoneyView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.withdrawMoneyView).offset(left);
            make.top.equalTo(self.withdrawMoneyView).offset(top);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        index ++;
    }
    
    int row = index/3;
    if (index%3 != 0) {
        row += 1;
    }
    CGFloat moneyViewH = row*height + (row>0?row-1:0)*18;
    [self.withdrawMoneyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moneyViewH);
    }];
    CGFloat viewHeight = moneyViewH +230 + 70;
    
    if (viewHeight < (HitoScreenH-56-HitoTopHeight+1)) {
        viewHeight = HitoScreenH-56-HitoTopHeight+1;
    }
    self.mainScrollView.contentSize = CGSizeMake(HitoScreenW, viewHeight);
    
}

#pragma mark -
#pragma mark - Request
- (void)getMoneyListRequest{
    
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"GetCashConfig"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        
        [WeakSelf.withdrawMoneyArray removeAllObjects];
//        for (int i = 0; i < 5; i ++) {
//            LEWithdrawModel *moneyModel = [[LEWithdrawModel alloc] init];
//            moneyModel.money = [NSString stringWithFormat:@"%d",i+1];
//            moneyModel.wId = [NSString stringWithFormat:@"%d",i+1];
//            [WeakSelf.withdrawMoneyArray addObject:moneyModel];
//        }
        
        [WeakSelf reloadData];
        [WeakSelf refeshUI];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

- (void)applyCashRequestWay:(NSInteger)way moneyModel:(LEWithdrawModel *)moneyModel{
    
    [SVProgressHUD showCustomWithStatus:nil];
    HitoWeakSelf;
    NSString *requesUrl = [[WYAPIGenerate sharedInstance] API:@"ApplyCash"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:way] forKey:@"cashType"];
    [params setObject:[LELoginUserManager userID] forKey:@"userId"];
    [params setObject:[NSString stringWithFormat:@"%.2f",[moneyModel.money doubleValue]] forKey:@"money"];
    [self.networkManager POST:requesUrl needCache:NO caCheKey:nil parameters:params responseClass:nil needHeaderAuth:YES success:^(WYRequestType requestType, NSString *message, BOOL isCache, id dataObject) {
        
        if (requestType != WYRequestTypeSuccess) {
            return ;
        }
        [SVProgressHUD showCustomInfoWithStatus:@"提现申请发送成功,请耐心等待."];
        
    } failure:^(id responseObject, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark - IBActions

- (void)wayClickAction:(UIButton *)sender {
    int index = (int)[sender superview].tag-10;
    _selectedWayIndex = index;
    [self refeshUI];
}

- (void)moneyClickAction:(UIButton *)sender {
    int index = (int)[sender superview].tag-10;
    _selectedMoneyIndex = index;
    [self refeshUI];
}

- (IBAction)withdrawAction:(UIButton *)sender {
    
    [SVProgressHUD showCustomInfoWithStatus:@"功能即将上线."];
    return;
    NSInteger way = 0;
    if (_selectedWayIndex >= 0 && _selectedWayIndex < self.withdrawWayArray.count) {
        LEWithdrawModel *model = self.withdrawWayArray[_selectedWayIndex];
        way = model.way;
    }
    LEWithdrawModel *moneyModel = nil;
    if (_selectedMoneyIndex >= 0 && _selectedMoneyIndex < self.withdrawMoneyArray.count) {
        moneyModel = self.withdrawMoneyArray[_selectedMoneyIndex];
    }
    if (!moneyModel) {
        return;
    }
    
    [self applyCashRequestWay:way moneyModel:moneyModel];
}

#pragma mark -
#pragma mark - Set And Getters
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
    }
    return _mainScrollView;
}

- (UILabel *)balanceTipLabel{
    if (!_balanceTipLabel) {
        _balanceTipLabel = [[UILabel alloc] init];
        _balanceTipLabel.textColor = kAppTitleColor;
        _balanceTipLabel.font = HitoPFSCRegularOfSize(11);
        _balanceTipLabel.text = @"当前余额";
    }
    return _balanceTipLabel;
}

- (UILabel *)rmbTipLabel{
    if (!_rmbTipLabel) {
        _rmbTipLabel = [[UILabel alloc] init];
        _rmbTipLabel.text = @"¥";
        _rmbTipLabel.textColor = kAppTitleColor;
        _rmbTipLabel.font = HitoPFSCRegularOfSize(15);
    }
    return _rmbTipLabel;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = kAppTitleColor;
        _balanceLabel.font = HitoBoldSystemFontOfSize(40);
    }
    return _balanceLabel;
}

-(UILabel *)withdrawWayLabel{
    if (!_withdrawWayLabel) {
        _withdrawWayLabel = [[UILabel alloc] init];
        _withdrawWayLabel.textColor = kAppTitleColor;
        _withdrawWayLabel.font = HitoPFSCRegularOfSize(14);
        _withdrawWayLabel.text = @"提现方式";
    }
    return _withdrawWayLabel;
}

- (UIView *)withdrawWayView{
    if (!_withdrawWayView) {
        _withdrawWayView = [[UIView alloc] init];
        
        CGFloat width = (HitoScreenW-12*3)/2;
        int index = 0;
        for (LEWithdrawModel *model in self.withdrawWayArray) {
            LEWithdrawItemView *itemView = [[LEWithdrawItemView alloc] init];
            itemView.tag = index+10;
            [itemView.clickButton addTarget:self action:@selector(wayClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [itemView updateItemViewData:model];
            [_withdrawWayView addSubview:itemView];
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self->_withdrawWayView).offset((width+12)*index);
                make.top.bottom.equalTo(self->_withdrawWayView);
                make.width.mas_equalTo(width);
            }];
            index ++;
        }
        
    }
    return _withdrawWayView;
}

-(UILabel *)withdrawMoneyLabel{
    if (!_withdrawMoneyLabel) {
        _withdrawMoneyLabel = [[UILabel alloc] init];
        _withdrawMoneyLabel.textColor = kAppTitleColor;
        _withdrawMoneyLabel.font = HitoPFSCRegularOfSize(14);
        _withdrawMoneyLabel.text = @"提现金额";
    }
    return _withdrawMoneyLabel;
}

- (UIView *)withdrawMoneyView{
    if (!_withdrawMoneyView) {
        _withdrawMoneyView = [[UIView alloc] init];
    }
    return _withdrawMoneyView;
}

- (UIView *)warmTipView{
    if (!_warmTipView) {
        _warmTipView = [[UIView alloc] init];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.text = @"温馨提示";
        tipLabel.textColor = [UIColor colorWithHexString:@"999999"];
        tipLabel.font = HitoPFSCRegularOfSize(15);
        [_warmTipView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_warmTipView).offset(12);
            make.top.equalTo(self->_warmTipView);
        }];
        
        UILabel *tipTextLabel = [[UILabel alloc] init];
        tipTextLabel.text = @"我们将很快上线此功能,敬请期待.";//提现申请将在一个工作日内审批，当天申请，隔天到账
        tipTextLabel.textColor = [UIColor colorWithHexString:@"999999"];
        tipTextLabel.font = HitoPFSCRegularOfSize(12);
        _warmTipLabel = tipTextLabel;
        [_warmTipView addSubview:tipTextLabel];
        [tipTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_warmTipView).offset(12);
            make.top.equalTo(tipLabel.mas_bottom).offset(12);
        }];
        
    }
    return _warmTipView;
}

@end
