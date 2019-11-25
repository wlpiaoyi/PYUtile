//
//  UIImage+Convenience.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-3.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

extern NSString * _Nonnull PYColorMatrixCILinearToSRGBToneCurve;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectChrome;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectFade;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectInstant;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectMono;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectNoir;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectProcess;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectTonal;
extern NSString * _Nonnull PYColorMatrixCIPhotoEffectTransfer;
extern NSString * _Nonnull PYColorMatrixCISRGBToneCurveToLinear;
extern NSString * _Nonnull PYColorMatrixCIVignetteEffect;

@interface UIImage (PYExpand)
-(nonnull UIImage*) setImageSize:(CGSize) size;
-(nonnull UIImage*) setImageSize:(CGSize) size scale:(short) scale;
-(nonnull UIImage*) cutImage:(CGRect) cutValue;
-(nonnull UIImage*) cutImageCenter:(CGSize) size;
-(nonnull UIImage*) cutImageFit:(CGSize) size;
+(nonnull UIImage*) imageWithColor:(UIColor * _Nonnull)color;
+(nonnull UIImage*) imageWithSize:(CGSize) size color:(CGColorRef _Nonnull) colorRef;
+(nonnull UIImage*) imageWithSize:(CGSize) size blockDraw:(void (^ _Nonnull) (CGContextRef _Nonnull context, CGRect rect)) blockDraw;
+(nonnull UIImage *)imageWithSize:(CGSize) size scale:(NSInteger) scale blockDraw:(void (^ _Nonnull) (CGContextRef  _Nullable context, CGRect rect)) blockDraw;
/**
 二维码
 */
//+(nonnull UIImage*) imageWithQRCode:(NSString * _Nonnull) QRCode size:(CGFloat) size;


- (nullable UIImage*) fliterMatrixWithColor:(nonnull NSString*) color;
/*可以打印出所有的过滤器以及支持的属性
 NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
 for (NSString *filterName in filters) {
 CIFilter *filter = [CIFilter filterWithName:filterName];
 NSLog(@"%@,%@",filterName,[filter attributes]);
 }
 */
- (nullable UIImage *)fliterMatrixWithColor:(nonnull NSString*) color rect:(CGRect) rect;

/**
 毛玻璃
 */
-(nonnull UIImage*) applyEffect:(CGFloat)blur tintColor:(nullable UIColor *) tintColor;


+(nonnull UIImage*) imageWithImage:(nonnull UIImage*)inImage colorMatrix:(nonnull NSString *) colorMatrix NS_DEPRECATED_IOS(2_0, 7_0, "Use fliterMatrixWithColor");
+(nonnull UIImage*) imageWithImage:(nonnull UIImage*)inImage colorMatrix:(nonnull NSString *) colorMatrix rectMatrix:(CGRect) rectMatrix NS_DEPRECATED_IOS(2_0, 7_0, "Use fliterMatrixWithColor:rect");
@end
