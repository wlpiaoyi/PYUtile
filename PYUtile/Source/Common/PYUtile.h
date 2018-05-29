//
//  PYUtile.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/10/28.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define is64BitArm  __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#define kRGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define kRGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)/255.0]

#define kUTILE_STATIC_INLINE    static inline

#pragma mark APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#pragma mark 系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
#pragma mark 获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

#pragma mark 打印日志
#ifndef __OPTIMIZE__
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif
#define kPrintLogln(f, ...)  printf([NSString stringWithFormat:@"wlpiaoyi(log)[%s]\n",f].UTF8String, ## __VA_ARGS__)
#define kPrintExceptionln(f, ...)  printf([NSString stringWithFormat:@"wlpiaoyi(exception)[%s]\n",f].UTF8String, ## __VA_ARGS__)
#define kPrintErrorln(f, ...)  printf([NSString stringWithFormat:@"wlpiaoyi(error)[%s]\n",f].UTF8String, ## __VA_ARGS__)

#pragma mark 一些常用的缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults      [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

#pragma mark 属性配置简写
#define kPNSNA                         @property (nonatomic, strong, nullable)
#define kPNSNN                        @property (nonatomic, strong, nonnull)
#define kPNRNA                         @property (nonatomic, readonly, nullable)
#define kPNRNN                        @property (nonatomic, readonly, nonnull)
//==============
#define kPNCNA                         @property (nonatomic, copy, nullable)
#define kPNCNN                        @property (nonatomic, copy, nonnull)
#define kPNCRNA                       @property (nonatomic, copy, readonly, nullable)
#define kPNCRNN                      @property (nonatomic, copy, readonly, nonnull)
//==============
#define kPNA                              @property (nonatomic, assign)
#define kPNANA                         @property (nonatomic, assign, nullable)
#define kPNANN                        @property (nonatomic, assign, nonnull)
#define kPNAR                            @property (nonatomic, assign, readonly)
#define kPNARA                          @property (nonatomic, assign, readonly, nullable)
#define kPNARN                          @property (nonatomic, assign, readonly, nonnull)

#if __LP64__
typedef unsigned int                        kUInt32;
typedef unsigned long                      kUInt64;
typedef int                                     kInt32;
typedef long                                   kInt64;
#else
typedef unsigned long                     kUInt32;
typedef unsigned long long              kUInt64;
typedef long                                  kInt32;
typedef long long                           kInt64;
#endif

#pragma mark GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

#pragma mark UIResponder初始化自定义方法
#define kINITPARAMSForType(type) -(instancetype) initWithFrame:(CGRect)frame{if(self = [super initWithFrame:frame]){[self initParams##type];}return self;} -(instancetype) initWithCoder:(NSCoder *)aDecoder{ if(self = [super initWithCoder:aDecoder]){ [self initParams##type];}return self;} -(void) initParams##type

#pragma mark autolayout回调
#define kSOULDLAYOUTPForType(type) @property (nonatomic) CGSize __layoutSubviews_UseSize##type;
#define kSOULDLAYOUTMSTARTForType(type)  -(BOOL) __layoutSubviews_Size_Compare##type{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize##type, self.bounds.size)){return false;}self.__layoutSubviews_UseSize##type = self.bounds.size;return true;} -(void) layoutSubviews{ [super layoutSubviews]; if([self __layoutSubviews_Size_Compare##type]){
#define kSOULDLAYOUTVMSTARTForType(type) -(BOOL) __layoutSubviews_Size_Compare##type{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize##type, self.view.bounds.size)){return false;}self.__layoutSubviews_UseSize##type = self.view.bounds.size;return true;} -(void) viewDidLayoutSubviews{ [super viewDidLayoutSubviews]; if([self __layoutSubviews_Size_Compare##type]){
#define kSOULDLAYOUTMEND }}

#pragma mark 格式化、拼接字符串
#define kFORMAT(f, ...)      [NSString stringWithFormat:f, ## __VA_ARGS__]

#pragma mark 字体
#define kFont(s)              [UIFont systemFontOfSize:s weight:UIFontWeightMedium]
#define kFontL(s)             [UIFont systemFontOfSize:s weight:UIFontWeightLight]
#define kFontR(s)             [UIFont systemFontOfSize:s weight:UIFontWeightRegular]
#define kFontB(s)             [UIFont systemFontOfSize:s weight:UIFontWeightBold]
#define kFontT(s)             [UIFont systemFontOfSize:s weight:UIFontWeightThin]

#pragma mark 通知
#define kNOTIF_ADD(obs, n, f)          [[NSNotificationCenter defaultCenter] addObserver:obs selector:@selector(f) name:n object:nil]
#define kNOTIF_POST(n, o)               [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define kNOTIF_REMV(obs, n)             [[NSNotificationCenter defaultCenter] removeObserver:obs name:n object:nil]

#pragma mark GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

#pragma mark 弱引用/强引用
#define kWeak(type)        __weak typeof(type) py_weak_or_assign_##type = type;
#define kAssign(type)       __unsafe_unretained typeof(type) py_weak_or_assign_##type = type;
#define kStrong(type)       __strong typeof(type) type = py_weak_or_assign_##type;

#pragma mark 单例化一个类h
#define SINGLETON_SYNTHESIZE_FOR_hCLASS(classname, superclassname, delegate)\
\
@interface classname : superclassname delegate \
\
+ (classname *)shared##classname;

#pragma mark 单例化一个类m
#define SINGLETON_SYNTHESIZE_FOR_mCLASS(classname) \
\
static classname *pyshared##classname = nil; \
\
@implementation classname\
\
+ (classname *)shared##classname { \
@synchronized(self) { \
if (pyshared##classname == nil){\
pyshared##classname = [[self alloc] init]; \
[pyshared##classname initShareParams##classname];\
}\
} \
return pyshared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone { \
@synchronized(self) { \
if (pyshared##classname == nil) { \
pyshared##classname = [super allocWithZone:zone]; \
[pyshared##classname initShareParams##classname];\
return pyshared##classname; \
} \
} \
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone {return self;}\
- (void) initShareParams##classname

#pragma mark 常用沙盒路径
extern const NSString * _Nonnull documentDir;
extern const NSString * _Nonnull cachesDir;
extern const NSString * _Nonnull bundleDir;
extern const NSString * _Nonnull systemVersion;

#pragma mark 地球半径
extern double EARTH_RADIUS;

//==>
#pragma mark 窗口大小
float boundsWidth(void);
float boundsHeight(void);
///<==

//==================================>
#pragma mark 线程操作
void threadJoinMain(dispatch_block_t block);
void threadJoinGlobal(dispatch_block_t block);
///<==================================

//==================================>
void lockForSemaphore(dispatch_block_t block, dispatch_semaphore_t semaphore);
void lockForDefault(dispatch_block_t block);
///<==================================

UIDeviceOrientation parseInterfaceOrientationToDeviceOrientation(UIInterfaceOrientation interfaceOrientation);
UIInterfaceOrientation parseDeviceOrientationToInterfaceOrientation(UIDeviceOrientation deviceOrientation);

//==>
#pragma mark 角度和弧度之间的转换
/**
 角度转换弧度
 */
double parseDegreesToRadians(double degrees);
/**
 弧度转换角度
 */
double parseRadiansToDegrees(double radians);
///<==

/**
 经纬度转换距离 (KM)
 */
double parseCoordinateToDistance(double lat1, double lng1, double lat2, double lng2);

/**
 生成UUID
 */
NSString * _Nullable PYUUID(NSUInteger length);

/**
 cup使用率
 */
float cpu_usage(void);

@interface PYUtile : NSObject

/**
 获取正在显示的window
 */
+(nullable UIWindow *) getCurrenWindow;

/**
 获取当前正在显示的controller(直接从window遍历)
 */
+(nullable UIViewController *) getCurrentController;

/**
 获取当前正在显示的controller(直接从指定controller遍历)
 */
+(nonnull UIViewController *) getCurrentController:(nonnull UIViewController *) parentVc;

/**
 获取plist文件的类容
 */
+(nullable NSDictionary *) getInfoPlistWithName:(nonnull NSString *) name;

//==>

/**
 计算文字占用的大小
 */
+(CGSize) getBoundSizeWithTxt:(nonnull NSString *) txt font:(nonnull UIFont *) font size:(CGSize) size;

/**
 计算文字占用的大小
 */
+(CGSize) getBoundSizeWithAttributeTxt:(nonnull NSAttributedString *) attributeTxt size:(CGSize) size;

/**
 计算指定字体对应的高度
 */
+(CGFloat) getFontHeightWithSize:(CGFloat) size fontName:(nonnull NSString *) fontName;

/**
 计算指定高度对应的字体大小
 */
+(CGFloat) getFontSizeWithHeight:(CGFloat) height fontName:(nonnull NSString *) fontName;
///<==

/**
 汉字转拼音
 */
+ (nonnull NSString *) chineseToSpell:(nonnull NSString *)sourceString;

/**
 添加不向服务器备份的Document下的路径
 */
+(BOOL) addSkipBackupAttributeToItemAtURL:(nonnull NSString *)url;

/**
 手机型号
 */
+(nullable NSString *) getDeviceInfo;

/**
 简易发声
 */
+(BOOL) soundWithPath:(nullable NSString *) path isShake:(BOOL) isShake;

@end

#pragma mark 不建议使用的
#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0)
#endif
#ifndef IOS8_OR_LATER
#define IOS8_OR_LATER (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0)
#endif
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_9_0)
#endif
#ifndef IOS10_OR_LATER
#define IOS10_OR_LATER (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)
#endif
#define PYINITPARAMS kINITPARAMS
#define PYSOULDLAYOUTP kSOULDLAYOUTP;
#define PYSOULDLAYOUTMSTART kSOULDLAYOUTMSTART
#define PYSOULDLAYOUTVMSTART kSOULDLAYOUTVMSTART
#define PYSOULDLAYOUTMEND kSOULDLAYOUTMEND
#define PYPNSNA kPNSNA
#define PYPNSNN kPNSNN
#define PYPNRNA kPNRNA
#define PYPNRNN kPNRNN
#define PYPNCNA kPNCNA
#define PYPNCNN kPNCNN
#define PYPNANA kPNANA
#define PYPNANN kPNANN
#define PYPNA kPNA
#define PYPNAR kPNAR
#define PYPNARA kPNARA
#define PYPNARN kPNARN
#define kSOULDLAYOUTP @property (nonatomic) CGSize __layoutSubviews_UseSize;
#define kINITPARAMS -(instancetype) initWithFrame:(CGRect)frame{if(self = [super initWithFrame:frame]){[self initParams];}return self;} -(instancetype) initWithCoder:(NSCoder *)aDecoder{ if(self = [super initWithCoder:aDecoder]){ [self initParams];}return self;} -(void) initParams
#define kSOULDLAYOUTMSTART -(BOOL) __layoutSubviews_Size_Compare{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize, self.bounds.size)){return false;}self.__layoutSubviews_UseSize = self.bounds.size;return true;} -(void) layoutSubviews{ [super layoutSubviews]; if([self __layoutSubviews_Size_Compare ]){
#define kSOULDLAYOUTVMSTART -(BOOL) __layoutSubviews_Size_Compare{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize, self.view.bounds.size)){return false;}self.__layoutSubviews_UseSize = self.view.bounds.size;return true;} -(void) viewDidLayoutSubviews{ [super viewDidLayoutSubviews]; if([self __layoutSubviews_Size_Compare ]){
