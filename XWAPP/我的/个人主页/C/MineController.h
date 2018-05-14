//
//  MineController.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/27.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineNaView;

@interface MineController : UIViewController
HitoPropertyNSArray(secondArr);
HitoPropertyNSArray(fourArr);
HitoPropertyNSArray(imageArr);
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MineNaView *naView;

@end
