//
//  SearchCollectionViewController.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/25.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchSelectTextBlock)(NSString *content);

@interface SearchCollectionViewController : UICollectionViewController

HitoPropertyNSMutableArray(dataArr);
HitoPropertyNSMutableArray(historyArr);

@property (copy, nonatomic) SearchSelectTextBlock searchSelectTextBlock;

@end
