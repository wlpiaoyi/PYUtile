//
//  PYUtileMacro.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/5.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//


#import <UIKit/UIKit.h>

int  printf(const char * __restrict, ...) __printflike(1, 2);

#define is64BitArm  __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#define kRGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define kRGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)/255.0]

#define kUTILE_STATIC_INLINE    static inline

#pragma mark APP版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#pragma mark APP构建版本号
#define kAppBundleVersion [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]
#pragma mark 获取App显示名
#define kAppDisplayName [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
#pragma mark 获取AppID
#define kAppBundleIdentifier [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleIdentifier"]
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

#pragma mark 判断经纬度是否有效
#define kCoordinateEnabled(coordinate) (coordinate.latitude > -90 && coordinate.longitude > -180 && coordinate.latitude < 90 && coordinate.longitude < 180)

#pragma mark 属性配置简写
#define kPNSNA                         @property (nonatomic, strong, nullable)
#define kPNSNN                        @property (nonatomic, strong, nonnull)
#define kPNRNA                         @property (nonatomic, readonly, nullable)
#define kPNRNN                        @property (nonatomic, readonly, nonnull)
#define kPCNA                        @property (class, nonatomic, assign)
#define kPCNRA                        @property (class, nonatomic, readonly, assign)
#define kPCNSNA                         @property (class, nonatomic, strong, nullable)
#define kPCNRNN                        @property (class, nonatomic, readonly, nonnull)
//==============
#define kPNCNA                         @property (nonatomic, copy, nullable)
#define kPNCNN                        @property (nonatomic, copy, nonnull)
#define kPNCRNA                       @property (nonatomic, copy, readonly, nullable)
#define kPNCRNN                      @property (nonatomic, copy, readonly, nonnull)
//==============
#define kPRA                              @property (nonatomic,readonly, assign)
#define kPNA                              @property (nonatomic, assign)
#define kPNANA                         @property (nonatomic, assign, nullable)
#define kPNANN                        @property (nonatomic, assign, nonnull)
#define kPNAR                            @property (nonatomic, assign, readonly)
#define kPNARA                          @property (nonatomic, assign, readonly, nullable)
#define kPNARN                          @property (nonatomic, assign, readonly, nonnull)

#pragma mark GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

#pragma mark UIResponder初始化自定义方法
#define kINITPARAMSForType(type) -(instancetype) initWithFrame:(CGRect)frame{if(self = [super initWithFrame:frame]){[self initParams##type];}return self;} -(instancetype) initWithCoder:(NSCoder *)aDecoder{ if(self = [super initWithCoder:aDecoder]){ [self initParams##type];}return self;} -(void) initParams##type
#define kViewInitParam(type) kINITPARAMSForType(type);

#pragma mark autolayout回调
#define kSOULDLAYOUTPForType(type) @property (nonatomic) CGSize __layoutSubviews_UseSize##type;
#define kSOULDLAYOUTMSTARTForType(type)  -(BOOL) __layoutSubviews_Size_Compare##type{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize##type, self.bounds.size)){return false;}self.__layoutSubviews_UseSize##type = self.bounds.size;return true;} -(void) layoutSubviews{ [super layoutSubviews]; if([self __layoutSubviews_Size_Compare##type]){
#define kSOULDLAYOUTVMSTARTForType(type) -(BOOL) __layoutSubviews_Size_Compare##type{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize##type, self.view.bounds.size)){return false;}self.__layoutSubviews_UseSize##type = self.view.bounds.size;return true;} -(void) viewDidLayoutSubviews{ [super viewDidLayoutSubviews]; if([self __layoutSubviews_Size_Compare##type]){
#define kSOULDLAYOUTMEND }}

#define kFieldAutoLayout(type) kSOULDLAYOUTPForType(type);
#define kViewLayout(type) kSOULDLAYOUTMSTARTForType(type);
#define kControllerDidLayout(type)kSOULDLAYOUTVMSTARTForType(type);
#define kVCLayoutEnd }}

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
+ (nullable classname *)shared##classname;

#pragma mark 单例化一个类m
#define SINGLETON_SYNTHESIZE_FOR_mCLASS(classname) \
\
static classname *pyshared##classname = nil; \
\
@implementation classname\
\
+ (nullable classname *)shared##classname { \
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




#pragma mark 不建议使用的==================================================================

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
