//
//  PYUtile.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/10/28.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

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

#ifndef RGB
#define RGB(R,G,B) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#endif

#ifndef RGBA
#define RGBA(R,G,B,A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
#endif

#ifndef PYUTILE_STATIC_INLINE
#define PYUTILE_STATIC_INLINE	static inline
#endif

#ifndef __OPTIMIZE__   // debug version
#    define NSLog(...) NSLog(__VA_ARGS__)
#else      // release version
#    define NSLog(...) {}
#endif

#define is64BitArm  __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64

#if __LP64__
typedef unsigned int                    PYUInt32;
typedef unsigned long                 PYUInt64;
typedef int                                    PYInt32;
typedef long                                 PYInt64;
#else
typedef unsigned long                 PYUInt32;
typedef unsigned long long         PYUInt64;
typedef long                                 PYInt32;
typedef long long                         PYInt64;
#endif

#define PYPNSNA @property (nonatomic, strong, nullable)
#define PYPNSNN @property (nonatomic, strong, nonnull)
#define PYPNRNA @property (nonatomic, readonly, nullable)
#define PYPNRNN @property (nonatomic, readonly, nonnull)
#define PYPNCNA @property (nonatomic, copy, nullable)
#define PYPNCNN @property (nonatomic, copy, nonnull)
#define PYPNANA @property (nonatomic, assign, nullable)
#define PYPNANN @property (nonatomic, assign, nonnull)
#define PYPNA @property (nonatomic, assign)
#define PYPNAR @property (nonatomic, assign, readonly)

#define PYINITPARAMS -(instancetype) initWithFrame:(CGRect)frame{if(self = [super initWithFrame:frame]){[self initParams];}return self;} -(instancetype) initWithCoder:(NSCoder *)aDecoder{ if(self = [super initWithCoder:aDecoder]){ [self initParams];}return self;}

#define PYSOULDLAYOUTP @property (nonatomic) CGSize __layoutSubviews_UseSize;
#define PYSOULDLAYOUTM -(BOOL) __layoutSubviews_Size_Compare{ if(CGSizeEqualToSize(self.__layoutSubviews_UseSize, self.bounds.size)){return false;}self.__layoutSubviews_UseSize = self.bounds.size;return true;}

extern const NSString * _Nonnull documentDir;
extern const NSString * _Nonnull cachesDir;
extern const NSString * _Nonnull bundleDir;
extern const NSString * _Nonnull systemVersion;
extern double EARTH_RADIUS;//地球半径

//==>
float boundsWidth();
float boundsHeight();
///<==

UIDeviceOrientation parseInterfaceOrientationToDeviceOrientation(UIInterfaceOrientation interfaceOrientation);
UIInterfaceOrientation parseDeviceOrientationToInterfaceOrientation(UIDeviceOrientation deviceOrientation);

//==>角度和弧度之间的转换
double parseDegreesToRadians(double degrees);
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
float cpu_usage();

@interface PYUtile : NSObject

+(nullable UIViewController *) getCurrentController;

/**
 获取plist文件的类容
 */
+(nullable NSDictionary *) getInfoPlistWithName:(nonnull NSString *) name;

//==>
//计算文字占用的大小
+(CGSize) getBoundSizeWithTxt:(nonnull NSString *) txt font:(nonnull UIFont *) font size:(CGSize) size;

//计算文字占用的大小
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
 简易发声
 */
+(BOOL) soundWithPath:(nullable NSString *) path isShake:(BOOL) isShake;

@end
