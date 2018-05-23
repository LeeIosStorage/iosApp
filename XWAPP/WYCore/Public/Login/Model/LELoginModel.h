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
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *headImgUrl;
@property (strong, nonatomic) NSString *regTime;
@end