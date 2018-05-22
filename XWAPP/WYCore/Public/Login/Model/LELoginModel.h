//
//  LELoginModel.h
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEBaseModel.h"

@interface LELoginModel : LEBaseModel

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *icon;

@end
