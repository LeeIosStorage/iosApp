//
//  SysMarco.h
//  XWAPP
//
//  Created by HuiYiShe on 2018/4/23.
//  Copyright © 2018年 HuiYiShe. All rights reserved.
//

#ifndef SysMarco_h
#define SysMarco_h


/***************************系统版本*****************************/

//获取手机系统的版本

#define HitoSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//是否为iOS7及以上系统

#define HitoiOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//是否为iOS8及以上系统

#define HitoiOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

//是否为iOS9及以上系统

#define HitoiOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

//是否为iOS10及以上系统

#define HitoiOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

//是否为iOS11及以上系统

#define HitoiOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)



/***************************沙盒路径*****************************/

//沙盒路径

#define HitoHomePath NSHomeDirectory()

//获取沙盒 Document

#define HitoPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache

#define HitoPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 temp

#define HitoPathTemp NSTemporaryDirectory()



/***************************打印日志*****************************/

//输出语句

#ifdef DEBUG

# define NSLog(FORMAT, ...) printf("[%s<%p>行号:%d]:\n%s\n",__FUNCTION__,self,__LINE__,[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#else

# define NSLog(FORMAT, ...)

#endif



/***************************系统高度*****************************/

//屏幕的宽高

#define HitoScreenW [UIScreen mainScreen].bounds.size.width

#define HitoScreenH [UIScreen mainScreen].bounds.size.height

//屏幕大小

#define HitoScreenSize [UIScreen mainScreen].bounds

//比例宽和高(以6s为除数)

#define HitoActureHeight(height)  roundf(height/375.0 * HitoScreenW)

#define HitoActureWidth(Width)  roundf(Width/667.0 * HitoScreenH)

//状态栏的高度

#define HitoStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

//导航栏的高度

#define HitoNavBarHeight 44.0

//iphoneX-SafeArea的高度

#define HitoSafeAreaHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

//分栏+iphoneX-SafeArea的高度

#define HitoTabBarHeight (49+HitoSafeAreaHeight)

//导航栏+状态栏的高度

#define HitoTopHeight (HitoStatusBarHeight + HitoNavBarHeight)



/***************************视图,类初始化*****************************/

//property属性快速声明

#define HitoPropertyString(s)      @property(nonatomic,copy)NSString * s

#define HitoPropertyNSInteger(s)   @property(nonatomic,assign)NSInteger s

#define HitoPropertyFloat(s)       @property(nonatomic,assign)float s

#define HitoPropertyLongLong(s)    @property(nonatomic,assign)long long s

#define HitoPropertyNSDictionary(s)@property(nonatomic,strong)NSDictionary * s

#define HitoPropertyNSArray(s)     @property(nonatomic,strong)NSArray * s

#define HitoPropertyNSMutableArray(s)    @property(nonatomic,strong)NSMutableArray * s



//获取视图宽高XY等信息

#define HitoviewH(view1) view1.frame.size.height

#define HitoviewW(view1) view1.frame.size.width

#define HitoviewX(view1) view1.frame.origin.x

#define HitoviewY(view1) view1.frame.origin.y

//获取self.view的宽高

#define HitoSelfViewW (self.view.frame.size.width)

#define HitoSelfViewH (self.view.frame.size.height)

///实例化

#define HitoViewAlloc(view,x,y,w,h) [[view alloc]initWithFrame:CGRectMake(x, y, w, h)]

#define HitoAllocInit(Controller,cName) Controller *cName = [[Controller alloc]init]





/***************************图片,颜色,字号*****************************/

//默认图片

#define HitoPlaceholderImage [UIImage imageNamed:@"XXX"]

//定义UIImage对象

#define HitoImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//基本颜色

#define HitoClearColor [UIColor clearColor]

#define HitoWhiteColor [UIColor whiteColor]

#define HitoBlackColor [UIColor blackColor]

#define HitoGrayColor [UIColor grayColor]

#define HitoGray2Color [UIColor lightGrayColor]

#define HitoBlueColor [UIColor blueColor]

#define HitoRedColor [UIColor redColor]

///颜色 a代表透明度,1为不透明,0为透明

#define HitoRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

// rgb颜色转换（16进制->10进制）

#define HitoColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//分割线颜色

#define LineColor [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:0.2]

//加粗

#define HitoBoldSystemFontOfSize(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]

//字号

#define HitoSystemFontOfSize(FONTSIZE) [UIFont systemFontOfSize:FONTSIZE]

#define HitoPFSCMediumOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Medium"size:FONTSIZE]

#define HitoPFSCLightOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Light"size:FONTSIZE]

#define HitoPFSCThinOfSize(FONTSIZE) [UIFont fontWithName:@"PingFangSC-Thin"size:FONTSIZE]



/***************************通知和本地存储*****************************/

//创建通知

#define HitoAddNotification(selectorName,key) [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectorName) name:key object:nil];

//发送通知

#define HitoSendNotification(key) [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];

//移除通知

#define HitoRemoveNotification(key) [[NSNotificationCenter defaultCenter]removeObserver:self name:key object:nil];

//本地化存储

//#define HitoUserDefaults(NSUserDefaults,defu) NSUserDefaults * defu = [NSUserDefaults standardUserDefaults];

#define HitoUserDefaults(value, key)  [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];



/***************************其他*****************************/

//主窗口

#define HitoApplication [UIApplication sharedApplication].keyWindow

//字符串拼接

#define HitoStringWithFormat(format,...)[NSString stringWithFormat:format,##__VA_ARGS__]

//GCD代码只执行一次

#define HitoDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//强引用

#define HitoWeakSelf __weak typeof(self)WeakSelf = self;

//成功标识

#define HitoSuccess @"success"

//失败标识

#define HitoFailure @"failure"

//登录状态标识

#define HitoSucTitle @"登录成功"

#define HitoFaiTitle @"登录失败"

//网络状态标识

#define HitoFaiNetwork @"网络错误"



#endif /* SysMarco_h */
