//
//  PYGraphicsDraw.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/17.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface PYGraphicsDraw : NSObject
/**
 绘制渐变色彩
 colorValues : (CGFloat[]){
 0.01f, 0.99f, 0.01f, 1.0f,
 0.01f, 0.99f, 0.99f, 1.0f}
 alphas : (CGFloat[]){
 0.5f,
 0.9f}
 length : 2
 */
+(void) drawLinearGradientWithContext:(nullable CGContextRef) context colorValues:(CGFloat * _Nonnull) colorValues alphas:(CGFloat * _Nonnull) alphas length:(CGFloat) length startPoint:(CGPoint) startPoint endPoint:(CGPoint) endPoint;
/**
 画直线
 */
+(void) drawLineWithContext:(nullable CGContextRef) context startPoint:(CGPoint) startPoint endPoint:(CGPoint) endPoint  strokeColor:(nonnull CGColorRef) strokeColor strokeWidth:(CGFloat) strokeWidth lengthPointer:(CGFloat * _Nullable) lengthPointer length:(NSUInteger) length;

/**
 多边形
 */
+(void) drawPolygonWithContext:(nullable CGContextRef) context pointer:(CGPoint * _Nonnull) pointer pointerLength:(NSUInteger) pointerLength strokeColor:(nonnull CGColorRef) strokeColor fillColor:(nullable CGColorRef) fillColor strokeWidth:(CGFloat) strokeWidth;

/**
 画比例圈
 pointCenter:圆心位置
 radius:半径
 strokeColor:线条颜色
 fillColor:填充颜色
 strokeWith:线条宽度
 startDegree,endDegree:起始度数
 */
+(void) drawCircleWithContext:(nullable CGContextRef) context pointCenter:(CGPoint) pointCenter radius:(CGFloat) radius strokeColor:(nonnull CGColorRef) strokeColor fillColor:(nullable CGColorRef) fillColor strokeWidth:(CGFloat) strokeWidth startDegree:(CGFloat) startDegree endDegree:(CGFloat) endDegree;

/**
 画椭圆
 */
+(void) drawEllipseWithContext:(nullable CGContextRef) context rect:(CGRect) rect strokeColor:(nonnull CGColorRef) strokeColor fillColor:(nullable CGColorRef) fillColor strokeWidth:(CGFloat) strokeWidth;

/**
 画文本
 rect:位置和区域大小
 y:反转位置 :bounds.size.height
 */
+(CGSize) drawTextWithContext:(nullable CGContextRef) context attribute:(nonnull NSAttributedString*) attribute rect:(CGRect) rect y:(CGFloat) y scaleFlag:(BOOL) scaleFlag;
/**
 画文本
 rect:位置和区域大小
 y:反转位置 :bounds.size.height
 */
+(CGSize) drawTextWithContext:(nullable CGContextRef) context attribute:(nonnull NSAttributedString*) attribute rects:(CGRect * _Nonnull) rects lenghtRect:(NSUInteger) lengthRect y:(CGFloat) y scaleFlag:(BOOL) scaleFlag;

/**
 准备画布
 */
+(void) startDraw:(CGContextRef _Nullable * _Nullable) contextPointer;

/**
 收起画布
 */
+(void) endDraw:(CGContextRef _Nonnull * _Nonnull) contextPointer;


@end
