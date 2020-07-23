//
//  UIImage+Convenience.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-3.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "UIImage+PYExpand.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <CoreText/CoreText.h>
#import "PYUtile.h"
#import "PYGraphicsDraw.h"

enum {
    qr_margin = 3
};


const NSString *PYColorMatrixCILinearToSRGBToneCurve = @"CILinearToSRGBToneCurve";
const NSString *PYColorMatrixCIPhotoEffectChrome = @"CIPhotoEffectChrome";
const NSString *PYColorMatrixCIPhotoEffectFade = @"CIPhotoEffectFade";
const NSString *PYColorMatrixCIPhotoEffectInstant = @"CIPhotoEffectInstant";
const NSString *PYColorMatrixCIPhotoEffectMono = @"CIPhotoEffectMono";
const NSString *PYColorMatrixCIPhotoEffectNoir = @"CIPhotoEffectNoir";
const NSString *PYColorMatrixCIPhotoEffectProcess = @"CIPhotoEffectProcess";
const NSString *PYColorMatrixCIPhotoEffectTonal = @"CIPhotoEffectTonal";
const NSString *PYColorMatrixCIPhotoEffectTransfer = @"CIPhotoEffectTransfer";
const NSString *PYColorMatrixCISRGBToneCurveToLinear = @"CISRGBToneCurveToLinear";
const NSString *PYColorMatrixCIVignetteEffect = @"CIVignetteEffect";

@implementation UIImage (PYExpand)
-(UIImage*) setImageSize:(CGSize) size{
    return [self setImageSize:size scale:[UIScreen mainScreen].scale];
}
-(UIImage*) setImageSize:(CGSize) size scale:(short) scale{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*) cutImage:(CGRect) rect{
    if(![self isKindOfClass:[UIImage class]]){// like the java's instandOf
        return nil;
    }
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };

    // determine the orientation of the image and apply a transformation to the crop rectangle to shift it to the correct position
    CGAffineTransform rectTransform;
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -self.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -self.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -self.size.width, -self.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    // adjust the transformation scale based on the image scale
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);

    // apply the transformation to the rect to create a new, shifted rect
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rect, rectTransform);
    // use the rect to crop the image
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, transformedCropSquare);
    // create a new UIImage and set the scale and orientation appropriately
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    // memory cleanup
    CGImageRelease(imageRef);
    
    return result;
}
-(UIImage*) cutImageFit:(CGSize) size{
    CGSize temp;
    if (self.size.width/size.width>self.size.height/size.height) {
        temp.height = self.size.height;
        temp.width = self.size.height/size.height*size.width;
    }else{
        temp.width = self.size.width;
        temp.height = self.size.width/size.width*size.height;
    }
    float x = (self.size.width-temp.width)/2;
    float y = (self.size.height-temp.height)/2;
    CGRect r = CGRectMake(x, y, temp.width, temp.height);
    return [self cutImage:r];
}
-(UIImage*) cutImageCenter:(CGSize) size{
    float x = (self.size.width-size.width)/2;
    float y = (self.size.height-size.height)/2;
    CGRect r = CGRectMake(x, y, size.width, size.height);
    return [self cutImage:r];
}

/**
 创建上下结构的文字图片结构
 */
+(UIImage *) createImageWithTitle:(NSString *) title font:(UIFont *) font color:(UIColor *) color image:(UIImage *) image offH:(CGFloat) offH imageOffH:(CGFloat) imageOffH direction:(short) direction{
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:title attributes:@{(NSString *)kCTForegroundColorAttributeName:color,(NSString *)kCTFontAttributeName:font}];
    CGSize tSize = [PYUtile getBoundSizeWithAttributeTxt:attribute size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
    UIImage * tImage = [UIImage imageWithSize:tSize blockDraw:^(CGContextRef  _Nonnull context, CGRect rect) {
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:CGRectMake(0, 0, 400, 400) y:rect.size.height scaleFlag:YES];
    }];
    
    tSize = CGSizeMake(tImage.size.width, tImage.size.height);
    tImage = [tImage setImageSize:tSize];
    
    tSize = tImage.size;
    CGSize tS = CGSizeMake(MAX(tSize.width, image.size.width), tSize.height + offH + image.size.height + imageOffH);
    CGRect tFrame, iFrame;
    switch (direction) {
        case 0:{
            tFrame = CGRectMake((tS.width - tSize.width)/2, 0, tImage.size.width, tImage.size.height);
            iFrame = CGRectMake((tS.width - image.size.width)/2, tFrame.size.height + tFrame.origin.y + offH + imageOffH, image.size.width, image.size.height);
        }
            break;
        default:{
            iFrame = CGRectMake((tS.width - image.size.width)/2, imageOffH, image.size.width, image.size.height);
            tFrame = CGRectMake((tS.width - tSize.width)/2, iFrame.size.height + iFrame.origin.y + offH, tImage.size.width, tImage.size.height);
        }
            break;
    }
    UIGraphicsBeginImageContextWithOptions(tS, NO, [UIScreen mainScreen].scale);
    [tImage drawInRect:tFrame];
    [image drawInRect:iFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    UIImage *image = [self imageWithSize:CGSizeMake(1.0f, 1.0f) color:[color CGColor]];
    return image;
}
+ (UIImage *)imageWithSize:(CGSize) size color:(CGColorRef) colorRef{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, colorRef);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)imageWithSize:(CGSize) size blockDraw:(void (^ _Nonnull) (CGContextRef context, CGRect rect)) blockDraw{
    return [self imageWithSize:size scale:[UIScreen mainScreen].scale blockDraw:blockDraw];
}
+ (UIImage *)imageWithSize:(CGSize) size scale:(NSInteger) scale blockDraw:(void (^ _Nonnull) (CGContextRef context, CGRect rect)) blockDraw{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    blockDraw(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(scale > 1)image = [image setImageSize:size scale:scale];
    return image;
}


//==>滤镜功能
- (nullable UIImage*) fliterMatrixWithColor:(NSString*) color{
    CGRect rect = CGRectMake(0, 0, 0, 0);
    rect.size = self.size;
    return [self fliterMatrixWithColor:color rect:rect];
}
/*可以打印出所有的过滤器以及支持的属性
 NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
 for (NSString *filterName in filters) {
 CIFilter *filter = [CIFilter filterWithName:filterName];
 NSLog(@"%@,%@",filterName,[filter attributes]);
 
 }
 */
- (nullable UIImage *)fliterMatrixWithColor:(nonnull NSString*) color rect:(CGRect) rect{
    @try {
        rect.size.width *= self.scale;
        rect.size.height *= self.scale;
        CIImage *ciImage = [[CIImage alloc] initWithImage:self];
        CIFilter *filter = [CIFilter filterWithName:color];
        [filter setValue:ciImage forKey:kCIInputImageKey];
        [filter setDefaults];
        //创建基于GPU的CIContext
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgImage = [context createCGImage:outputImage fromRect:rect];
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:self.scale orientation:UIImageOrientationUp];
        CGImageRelease(cgImage);
        return image;
    }
    @catch (NSException *exception) {
        return nil;
    }
}
///<==
/**
 毛玻璃
 @blur 透明度
 @tintColor 毛玻璃颜色
 
 //创建基于 GPU 的 CIContext 对象
 EAGLContext *eaglctx = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
 CIContext * context = [CIContext contextWithEAGLContext:eaglctx];
 
 CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
 //设置filter
 CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
 [filter setValue:inputImage forKey:kCIInputImageKey];
 [filter setValue:@(2) forKey:kCIInputRadiusKey];
 //模糊图片
 CIImage *result=[filter valueForKey:kCIOutputImageKey];
 CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
 image = [UIImage imageWithCGImage:outImage];
 CGImageRelease(outImage);
 */
-(UIImage * _Nonnull) applyEffect:(CGFloat)blur tintColor:(nullable UIColor *) tintColor{
    
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL){
        NSLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    uint32_t boxSize = (uint32_t)(blur * MIN(outBuffer.width, outBuffer2.height) * .1);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef outputContext = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    
    // Add in color tint.
    if (tintColor) {
        CGRect imageRect = {CGPointZero, self.size};
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(outputContext);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    
    
    return returnImage;
}

+ (UIImage*)imageWithImage:(UIImage*)inImage colorMatrix:(NSString*) colorMatrix {
    return [inImage fliterMatrixWithColor:colorMatrix];
}
+ (UIImage*)imageWithImage:(UIImage*)inImage colorMatrix:(NSString*) colorMatrix rectMatrix:(CGRect) rectMatrix{
    return [inImage fliterMatrixWithColor:colorMatrix rect:rectMatrix];
}

+(nonnull UIImage *) createQRCodeImageWithString:(nonnull NSString *) string withSize:(CGFloat) withSize{
    CIImage * ciimage = [self __PY_CREATE_QRCODECIIMAGE_WITH_RULSTRING:string];
    return [self __PY_CREATE_NONINTERPOLATED_UIIMAGE_FROM_CIIMAGE:ciimage WITHSIE:withSize];
}
+ (UIImage *) __PY_CREATE_NONINTERPOLATED_UIIMAGE_FROM_CIIMAGE:(CIImage *)image WITHSIE:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (CIImage *) __PY_CREATE_QRCODECIIMAGE_WITH_RULSTRING:(NSString *)urlString{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}


@end
