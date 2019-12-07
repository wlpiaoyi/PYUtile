//
//  PYUtile.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/10/28.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtileMacro.h"


#if __LP64__
typedef unsigned int                        kUInt32;
typedef unsigned long                      kUInt64;
typedef unsigned long long                kULong64;
typedef int                                     kInt32;
typedef long                                   kInt64;
typedef long long                             kLong64;
#else
typedef unsigned long                     kUInt32;
typedef unsigned long long              kUInt64;
typedef kUInt64                            kULong64;
typedef long                                  kInt32;
typedef long long                           kInt64;
typedef kInt64                             kLong64;
#endif

bool py_isPrisonBreakByPath(void);
bool py_isPrisonBreakByDyldimage(void);
bool py_isPrisonBreakByScheme(void);

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
void threadJoinMain(dispatch_block_t _Nullable block);
void threadJoinGlobal(dispatch_block_t _Nullable block);
///<==================================

//==================================>
void lockForSemaphore(dispatch_block_t _Nullable block, dispatch_semaphore_t _Nonnull semaphore);
void lockForDefault(dispatch_block_t _Nullable block);
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
 app cup使用率
 */
float app_cpu_usage(void);

/**
 连续控制
 */
//void controlsUdptype(NSTimeInterval timeInterval, dispatch_block_t block);

@interface PYUtile : NSObject

/**
 获取正在显示的window
 */
+(nullable UIWindow *) getCurrenWindow;

/**
 获取最顶层的View
 */
+(nonnull UIView *) getTopView:(nonnull UIView *) subView;

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
// MD5加密
/*
 *由于MD5加密是不可逆的,多用来进行验证
 */
// 32位小写
+(nonnull NSString *)MD5ForLower32Bate:(nonnull NSString *)str;
// 32位大写
+(nonnull NSString *)MD5ForUpper32Bate:(nonnull NSString *)str;
// 16为大写
+(nonnull NSString *)MD5ForUpper16Bate:(nonnull NSString *)str;
// 16位小写
+(nonnull NSString *)MD5ForLower16Bate:(nonnull NSString *)str;

@end
