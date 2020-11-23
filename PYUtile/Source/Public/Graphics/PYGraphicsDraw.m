//
//  PYGraphicsDraw.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/17.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYGraphicsDraw.h"
#import "PYUtile.h"
#import <CoreText/CoreText.h>

@implementation PYGraphicsDraw
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
+(void) drawLinearGradientWithContext:(nullable CGContextRef) context colorValues:(CGFloat * _Nonnull) colorValues alphas:(CGFloat * _Nonnull) alphas length:(CGFloat) length startPoint:(CGPoint) startPoint endPoint:(CGPoint) endPoint{
    [self startDraw:&context];
    
    // 创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    // 创建渐变对象
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, colorValues, alphas,length);
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    // 填充渐变色
    CGContextDrawLinearGradient(context, gradientRef, startPoint, endPoint, 0);
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    
    [self endDraw:&context];
}


/**
 画直线
 */
+(void) drawLineWithContext:(nullable CGContextRef) context startPoint:(CGPoint) startPoint endPoint:(CGPoint) endPoint  strokeColor:(nonnull CGColorRef) strokeColor strokeWidth:(CGFloat) strokeWidth lengthPointer:(CGFloat * _Nullable) lengthPointer length:(NSUInteger) length {
    [self startDraw:&context];
    
    //线宽设定
    CGContextSetLineWidth(context, strokeWidth);
    //线的边角样式（圆角型）
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    if (length){
        CGContextSetLineDash(context, 0, lengthPointer, length);
    }else{
        CGContextSetLineDash(context, 0, nil, 0);
    }
    //线条颜色
    CGContextSetStrokeColorWithColor(context, strokeColor);
    
    //移动绘图点
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    //绘制直线
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    [self endDraw:&context];
}
/**
 多边形
 */
+(void) drawPolygonWithContext:(nullable CGContextRef) context pointer:(CGPoint * _Nonnull) pointer pointerLength:(NSUInteger) pointerLength strokeColor:(nonnull CGColorRef) strokeColor fillColor:(nullable CGColorRef) fillColor strokeWidth:(CGFloat) strokeWidth{
    [self startDraw:&context];
    
    //线宽设定
    CGContextSetLineWidth(context, strokeWidth);
    //线的边角样式（圆角型）
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //线条颜色
    CGContextSetStrokeColorWithColor(context, strokeColor);
    
    CGPoint  currentPoint = pointer[0];
    
    CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
    
    NSUInteger currentIndex = 0;
    while(true){
        ++currentIndex;
        if(currentIndex >= pointerLength){
            break;
        }
        currentPoint = pointer[currentIndex];
        //绘制直线
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    }
    //封闭
    CGContextClosePath(context);
    if(fillColor != nil){
        //填充颜色
        CGContextSetFillColorWithColor(context, fillColor);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    }
    [self endDraw:&context];
}

/**
 画比例圈
 pointCenter:圆心位置
 radius:半径
 strokeColor:线条颜色
 fillColor:填充颜色
 strokeWith:线条宽度
 startDegree,endDegree:起始度数
 */
+(void) drawCircleWithContext:(nullable CGContextRef) context pointCenter:(CGPoint) pointCenter radius:(CGFloat) radius strokeColor:(nonnull CGColorRef) strokeColor fillColor:(nullable CGColorRef) fillColor strokeWidth:(CGFloat) strokeWidth startDegree:(CGFloat) startDegree endDegree:(CGFloat) endDegree{
    [self startDraw:&context];
    
    //（上下文，起点的偏移量，事例描述的时20像素的虚线10的空格，数组有2个元素）
    CGContextSetLineDash(context, 0, nil, 0);
    CGContextSetLineCap(context, kCGLineCapButt);//线的边角样式（直角型）
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, strokeWidth);//线的宽度
    
    CGContextSetStrokeColorWithColor(context, strokeColor); //线条颜色
    CGContextAddArc(context, pointCenter.x, pointCenter.y, radius, parseDegreesToRadians(startDegree), parseDegreesToRadians(endDegree), 0); //添加一个圆
    
    if (fillColor != nil) {
        CGContextSetFillColorWithColor(context, fillColor);//填充颜色
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    }
    [self endDraw:&context];
}

/**
 画椭圆
 */
+(void) drawEllipseWithContext:(nullable CGContextRef) context rect:(CGRect) rect strokeColor:(nonnull CGColorRef) strokeColor fillColor:(nullable CGColorRef) fillColor strokeWidth:(CGFloat) strokeWidth{
    [self startDraw:&context];
    //（上下文，起点的偏移量，事例描述的时20像素的虚线10的空格，数组有2个元素）
    CGContextSetLineDash(context, 0, nil, 0);
    CGContextSetLineCap(context, kCGLineCapButt);//线的边角样式（直角型）
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, strokeWidth);//线的宽度
    
    CGContextSetStrokeColorWithColor(context, strokeColor); //线条颜色
    CGContextStrokeEllipseInRect(context, rect);//添加一个圆
    
    if(fillColor != nil){
        CGContextSetFillColorWithColor(context, fillColor);//填充颜色
        CGContextFillEllipseInRect(context,rect);//添加一个圆
    }
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    
    [self endDraw:&context];
}

/**
 画文本
 rect:位置和区域大小
 y:反转位置 :bounds.size.height
 */
+(CGSize) drawTextWithContext:(nullable CGContextRef) context attribute:(nonnull NSAttributedString*) attribute rect:(CGRect) rect y:(CGFloat) y scaleFlag:(BOOL) scaleFlag{
    CGRect rects[] = {rect};
    return [self drawTextWithContext:context attribute:attribute rects:rects lenghtRect:1 y:y scaleFlag:scaleFlag];
}

/**
 画文本
 rect:位置和区域大小
 y:反转位置 :bounds.size.height
 */
+(CGSize) drawTextWithContext:(CGContextRef) context attribute:(NSAttributedString*) attribute rects:(CGRect *) rects lenghtRect:(NSUInteger) lengthRect y:(CGFloat) y scaleFlag:(BOOL) scaleFlag{
    [self startDraw:&context];
    if (scaleFlag) {
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);//重置绘图环境矩阵
        CGContextTranslateCTM(context, 0, y);//移动绘图环境
        CGContextScaleCTM(context, 1.0, -1.0);//翻转绘图环境
    }
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    for (NSUInteger index = 0; index < lengthRect; index++) {
        (rects[index]).origin.y = y - (rects[index]).size.height - (rects[index]).origin.y;
    }
    CGPathAddRects(pathRef, nil, rects, 1);
    
    //==>根据据attributeString的信息构建所需的空间大小
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attribute);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attribute.length), pathRef, nil);
    
    CTFrameDraw(frameRef, context);//一切信息准备就绪，坐等绘图
    
    CGSize coreTextSize =  CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attribute.length), nil, rects[0].size, nil);//计算占用空间大小
    
    [self endDraw:&context];
    
    // Clean up
    CFRelease(framesetter);
    CFRelease(frameRef);
    CFRelease(pathRef);
    
    return coreTextSize;
}

/**
 准备画布
 */
+(void) startDraw:(CGContextRef*) contextPointer{
    if (!contextPointer) {
        return;
    }
    if (!(*contextPointer)) {
        *contextPointer = UIGraphicsGetCurrentContext();
    }
    //起一个分支
    UIGraphicsPushContext(*contextPointer);
}
/**
 收起画布
 */
+(void) endDraw:(CGContextRef*) contextPointer{
    UIGraphicsPopContext();//收起分支
    //开始绘制线并在view上显示
    CGContextStrokePath(*contextPointer);
}
@end


//    CFStringRef keys[] = {};
//    CFTypeRef values[] = {};
//    CFDictionaryRef dicRef = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
