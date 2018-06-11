//
//  LEBaseModel.m
//  XWAPP
//
//  Created by hys on 2018/5/21.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#import "LEBaseModel.h"

@implementation LEBaseModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    return [self modelEncodeWithCoder:aCoder];
}

@end
