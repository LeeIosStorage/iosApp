//
//  LEWalletHeaderView.m
//  XWAPP
//
//  Created by hys on 2018/6/4.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEWalletHeaderView.h"
#import "PNChart.h"
@interface LEWalletHeaderView ()

@property (strong, nonatomic) UIView *topContainerView;
@property (strong, nonatomic) UILabel *balanceLabel;
@property (strong, nonatomic) UILabel *grossEarningsLabel;
@property (strong, nonatomic) UILabel *dayGoldLabel;
@property (strong, nonatomic) UILabel *rateLabel;
@property (strong, nonatomic) UILabel *goldTipLabel;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) PNLineChart *chartView;

@end

@implementation LEWalletHeaderView

#pragma mark -
#pragma mark - Lifecycle
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupSubView];
    }
    return self;
}

#pragma mark -
#pragma mark - Private
- (void)setupSubView{
    
    [self addSubview:self.topContainerView];
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(13);
        make.top.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-13);
    }];
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topContainerView.mas_bottom).offset(6);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark -
#pragma mark - Public
- (void)updateHeaderViewData:(id)data{
    
    NSString *balanceString = @"¥ 1.61";
    NSRange range = [balanceString rangeOfString:@"."];
    NSAttributedString *balanceAttStr = [WYCommonUtils stringToColorAndFontAttributeString:balanceString range:NSMakeRange(1, range.location-1) font:HitoBoldSystemFontOfSize(40) color:[UIColor whiteColor]];
    _balanceLabel.attributedText = balanceAttStr;
    
    NSString *grossEarningsString = @"¥ 1.61";
    NSAttributedString *grossEarningsAttStr = [WYCommonUtils stringToColorAndFontAttributeString:grossEarningsString range:NSMakeRange(0, 1) font:HitoPFSCMediumOfSize(15) color:[UIColor whiteColor]];
    _grossEarningsLabel.attributedText = grossEarningsAttStr;
    
    _dayGoldLabel.text = @"10";
    _rateLabel.text = @"100金币 =0.1元";
    _goldTipLabel.text = @"当天赚取的金币按照规则自动转换为零钱";

    
    self.chartView.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
    self.chartView.layer.cornerRadius = 13;
    self.chartView.layer.masksToBounds = YES;
    [self.chartView setXLabels:@[@"",@"",@"",@"",@"",@"",@""]];
    [self.chartView setYLabels:@[@"",@"",@"",@"",@"",@"",@""]];
//    [self.chartView setPathPoints:[NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"45",@"6",@"7"]]];
//    self.chartView.showGenYLabels = YES;
//    self.chartView.showYGridLines = YES;
    self.chartView.axisColor = [UIColor blueColor];
    self.chartView.axisWidth = 1.0f;
    self.chartView.yLabelColor = [UIColor blueColor];
//    self.chartView.yLabelFormat = @"+";
    
    NSArray *data01Array = @[@21, @40, @250, @500, @23, @68, @0];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = kAppThemeColor;
    data01.lineWidth = 1.5;
    data01.itemCount = data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.inflexionPointColor = kAppThemeColor;
    data01.inflexionPointWidth = 4.0f;
    data01.showPointLabel = YES;
    data01.pointLabelColor = kAppThemeColor;
    data01.pointLabelFont = [UIFont systemFontOfSize:8];
//    data01.pointLabelFormat = @"-";
    
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    self.chartView.chartData = @[data01];
    self.chartView.yValueMin = 0;
    self.chartView.yValueMax = 500;
    self.chartView.xLabelWidth = (HitoScreenW-12*2-10*2)/6;
    self.chartView.chartMarginLeft = -((HitoScreenW-12*2-10*2)/6)/2 + 10;
    self.chartView.chartMarginBottom = -15;
    self.chartView.showSmoothLines = NO;
    self.chartView.showCoordinateAxis = NO;
    [self.chartView strokeChart];
    
    [self addSubview:self.chartView];
    
}

#pragma mark -
#pragma mark - IBActions
- (void)putForwardAction:(id)sender{
    if (self.putForwardBlock) {
        self.putForwardBlock();
    }
}

#pragma mark -
#pragma mark - Set And Getters
- (UIView *)topContainerView{
    if (!_topContainerView) {
        _topContainerView = [[UIView alloc] init];
        
        
        UIImageView *bottomImageView = [[UIImageView alloc] init];
        bottomImageView.backgroundColor = [UIColor whiteColor];
        bottomImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        bottomImageView.layer.shadowOpacity = 0.1f;
        bottomImageView.layer.shadowRadius = 4.0f;
        bottomImageView.layer.shadowOffset = CGSizeMake(4,4);
        bottomImageView.layer.cornerRadius = 13;
        [_topContainerView addSubview:bottomImageView];
        
        UIImageView *topImageView = [[UIImageView alloc] init];
        topImageView.image = [[UIImage imageNamed:@"mine_qianbao_back_top"] stretchableImageWithLeftCapWidth:0 topCapHeight:30];
        [_topContainerView addSubview:topImageView];
        [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self->_topContainerView);
            make.height.mas_equalTo(155);
        }];
        
        [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self->_topContainerView);
            make.top.equalTo(topImageView.mas_bottom).offset(-13);
            make.height.mas_equalTo(65);
        }];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 13;
        [button setTitle:@"提现" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"f9473d"] forState:UIControlStateNormal];
        [button.titleLabel setFont:HitoPFSCRegularOfSize(13)];
        [button addTarget:self action:@selector(putForwardAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topContainerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(61, 26));
            make.top.equalTo(self->_topContainerView).offset(24);
            make.right.equalTo(self->_topContainerView).offset(-12);
        }];
        
        //当前余额
        UILabel *balanceTipLabel = [[UILabel alloc] init];
        balanceTipLabel.textColor = [UIColor whiteColor];
        balanceTipLabel.font = HitoPFSCRegularOfSize(10);
        balanceTipLabel.text = @"当前余额";
        [_topContainerView addSubview:balanceTipLabel];
        [balanceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self->_topContainerView).offset(16);
            make.top.equalTo(self->_topContainerView).offset(21);
        }];
        
        UILabel *balanceLabel = [[UILabel alloc] init];
        balanceLabel.textColor = [UIColor whiteColor];
        balanceLabel.font = HitoPFSCMediumOfSize(15);//
        _balanceLabel = balanceLabel;
        [_topContainerView addSubview:balanceLabel];
        [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceTipLabel);
            make.top.equalTo(balanceTipLabel.mas_bottom).offset(5);
        }];
        
        //累计收益
        UILabel *grossEarningsTipLabel = [[UILabel alloc] init];
        grossEarningsTipLabel.textColor = [UIColor whiteColor];
        grossEarningsTipLabel.font = HitoPFSCRegularOfSize(10);
        grossEarningsTipLabel.text = @"累计收益";
        [_topContainerView addSubview:grossEarningsTipLabel];
        [grossEarningsTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceTipLabel);
            make.top.equalTo(balanceLabel.mas_bottom).offset(5);
        }];
        
        UILabel *grossEarningsLabel = [[UILabel alloc] init];
        grossEarningsLabel.textColor = [UIColor whiteColor];
        grossEarningsLabel.font = HitoPFSCMediumOfSize(23);
        _grossEarningsLabel = grossEarningsLabel;
        [_topContainerView addSubview:grossEarningsLabel];
        [grossEarningsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceTipLabel);
            make.top.equalTo(grossEarningsTipLabel.mas_bottom).offset(2);
        }];
        
        //今日金币
        UILabel *dayGoldTipLabel = [[UILabel alloc] init];
        dayGoldTipLabel.textColor = [UIColor whiteColor];
        dayGoldTipLabel.font = HitoPFSCRegularOfSize(10);
        dayGoldTipLabel.text = @"今日金币";
        [_topContainerView addSubview:dayGoldTipLabel];
        [dayGoldTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(grossEarningsTipLabel.mas_right).offset(80);
            make.centerY.equalTo(grossEarningsTipLabel);
        }];
        
        UILabel *dayGoldLabel = [[UILabel alloc] init];
        dayGoldLabel.textColor = [UIColor whiteColor];
        dayGoldLabel.font = HitoPFSCMediumOfSize(23);
        _dayGoldLabel = dayGoldLabel;
        [_topContainerView addSubview:dayGoldLabel];
        [dayGoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(dayGoldTipLabel);
            make.centerY.equalTo(grossEarningsLabel);
        }];
        
        
        UILabel *rateLabel = [[UILabel alloc] init];
        rateLabel.textColor = kAppTitleColor;
        rateLabel.font = HitoPFSCRegularOfSize(12);
        _rateLabel = rateLabel;
        [_topContainerView addSubview:rateLabel];
        [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceTipLabel);
            make.top.equalTo(topImageView.mas_bottom).offset(6);
        }];
        
        UILabel *goldTipLabel = [[UILabel alloc] init];
        goldTipLabel.textColor = kAppTitleColor;
        goldTipLabel.font = HitoPFSCRegularOfSize(12);
        _goldTipLabel = goldTipLabel;
        [_topContainerView addSubview:goldTipLabel];
        [goldTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(balanceTipLabel);
            make.top.equalTo(rateLabel.mas_bottom).offset(4);
        }];
        
    }
    return _topContainerView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor colorWithHexString:@"666666"];
        tipLabel.font = HitoPFSCRegularOfSize(11);
        tipLabel.text = @"过去七日收益";
        [_lineView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self->_lineView);
        }];
        
        UIImageView *leftLine = [UIImageView new];
        leftLine.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
        [_lineView addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tipLabel.mas_left).offset(-6);
            make.centerY.equalTo(tipLabel);
            make.size.mas_equalTo(CGSizeMake(45, 0.5));
        }];
        
        UIImageView *rightLine = [UIImageView new];
        rightLine.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
        [_lineView addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipLabel.mas_right).offset(6);
            make.centerY.equalTo(tipLabel);
            make.size.mas_equalTo(CGSizeMake(45, 0.5));
        }];
        
    }
    return _lineView;
}

- (PNLineChart *)chartView{
    if (!_chartView) {
        _chartView = [[PNLineChart alloc] initWithFrame:CGRectMake(12, 265, SCREEN_WIDTH-24, 122.0)];
        _chartView.backgroundColor = [UIColor darkGrayColor];
    }
    return _chartView;
}

@end
