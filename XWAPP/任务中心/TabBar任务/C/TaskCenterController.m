//
//  TaskCenterController.m
//  XWAPP
//
//  Created by hys on 2018/5/8.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "TaskCenterController.h"
#import "TaskCell.h"
#import "TaskCellHeader.h"
#import "YQMController.h"
@interface TaskCenterController ()

@property(nonatomic,strong)NSTimer *countDownTimer;


@end

@implementation TaskCenterController

static NSInteger  secondsCountDown = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaStyle];
    [self setUpNormalView];
    

    
}

#pragma mark - setNormalView
- (void)setUpNormalView {
    self.title = @"任务中心";
    self.daySuper.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
}

#pragma mark -initDataArr
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@[@"新手阅读奖励", @"绑定微信", @"输入邀请码得红包"], @[@"邀请收徒", @"晒晒收入", @"唤醒徒弟", @"分享到朋友圈", @"阅读资讯", @"优质评论", @"阅读推送咨询", @"问券调查"]];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    cell.leftLB.text = self.dataArr[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            cell.longLine.hidden = NO;
        } else if (indexPath.row == 1) {
            cell.rightIM.image = HitoImage(@"task_hongbao");
        }
    } else {

        cell.shortView.hidden = NO;
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TaskCellHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"TaskCellHeader" owner:self options:nil] firstObject];

    if (section == 0) {
        header.leftLB.text = @"新手任务";
        header.leftIM.image = HitoImage(@"task_xinshourenwu");
    } else {
        header.leftLB.text = @"日常任务";
        header.leftIM.image = HitoImage(@"task_richagnrenwu");
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YQMController *yqm = [[YQMController alloc] initWithNibName:@"YQMController" bundle:nil];
    [self.navigationController pushViewController:yqm animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark -SBAction

- (IBAction)qiandaoAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setBackgroundColor:HitoColorFromRGB(0xdadada)];
    } else {
        [sender setBackgroundColor:HitoColorFromRGB(0xffb636)];
    }
}
- (IBAction)openBoxAction:(UITapGestureRecognizer *)sender {
    [_boxIM setHighlighted:YES];
    _centerLB.hidden = YES;
    _topLB.hidden = NO;
    _bottomIM.hidden = NO;
    _bottomLB.hidden = NO;
    [_boxView setBackgroundColor:HitoColorFromRGB(0xdadada)];
    
    //设置定时器
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    self.bottomLB.text = [NSString stringWithFormat:@"%@",format_time];
}

//实现倒计时动作
-(void)countDownAction{
    //倒计时-1
    secondsCountDown--;
    
    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",secondsCountDown/3600];
    
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(secondsCountDown%3600)/60];
    
    NSString *str_second = [NSString stringWithFormat:@"%02ld",secondsCountDown%60];
    
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    self.bottomLB.text=[NSString stringWithFormat:@"%@",format_time];
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(secondsCountDown == 0){
        [_countDownTimer invalidate];
    }
    
}



@end
