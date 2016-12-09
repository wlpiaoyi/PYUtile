//
//  UIImage+Convenience.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-3.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

extern const NSString * _Nonnull PYColorMatrixCILinearToSRGBToneCurve;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectChrome;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectFade;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectInstant;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectMono;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectNoir;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectProcess;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectTonal;
extern const NSString * _Nonnull PYColorMatrixCIPhotoEffectTransfer;
extern const NSString * _Nonnull PYColorMatrixCISRGBToneCurveToLinear;
extern const NSString * _Nonnull PYColorMatrixCIVignetteEffect;

@interface UIImage (Expand)
-(UIImage * _Nonnull) setImageSize:(CGSize) size;
-(UIImage * _Nonnull) cutImage:(CGRect) cutValue;
-(UIImage * _Nonnull) cutImageCenter:(CGSize) size;
-(UIImage * _Nonnull) cutImageFit:(CGSize) size;
+(UIImage * _Nonnull) imageWithColor:(UIColor * _Nonnull)color;
+(UIImage * _Nonnull) imageWithSize:(CGSize) size color:(CGColorRef _Nonnull) colorRef;
+(UIImage * _Nonnull) imageWithSize:(CGSize) size blockDraw:(void (^ _Nonnull) (CGContextRef _Nonnull context, CGRect rect)) blockDraw;
/**
 二维码
 */
+(UIImage * _Nonnull) imageWithQRCode:(NSString * _Nonnull) QRCode size:(CGFloat) size;
/*滤镜功能*/
+(UIImage * _Nonnull) imageWithImage:(UIImage * _Nonnull)inImage colorMatrix:(NSString * _Nonnull) colorMatrix;
+(UIImage * _Nonnull) imageWithImage:(UIImage * _Nonnull)inImage colorMatrix:(NSString * _Nonnull) colorMatrix rectMatrix:(CGRect) rectMatrix;
/**
 毛玻璃
 */
-(UIImage * _Nonnull) applyEffect:(CGFloat)blur tintColor:(nullable UIColor *) tintColor;
@end
