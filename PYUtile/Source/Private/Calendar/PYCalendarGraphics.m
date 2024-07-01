//
//  PYCalendarGraphics.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarGraphics.h"
#import <CoreText/CTStringAttributes.h>
#import "pyutilea.h"
#import "PYCalendarLunar.h"
#import "PYCalendarLocation.h"
#import "calendar_lunar.h"

NSArray *PYCalendarWeekNames;

@implementation PYCalendarGraphics
+(void) initialize{
    PYCalendarWeekNames = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
}
/**
 星期标签
 */
+(void) drawWeekWithContext:(nullable CGContextRef) context  bounds:(CGRect) bounds font:(nonnull UIFont *) font color:(nonnull UIColor*) color{
    
    CGSize fontSize = CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName]);
    CGRect rect = bounds;
    rect.size.width = bounds.size.width / [PYCalendarWeekNames count];
    rect.origin.y = bounds.origin.y + (rect.size.height - fontSize.height) / 2;
    CGFloat x = 0;
    for (NSString *weekName in PYCalendarWeekNames) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:weekName];
        [attribute setAttributes:@{(NSString*)NSForegroundColorAttributeName:color,(NSString*)NSFontAttributeName:font} range:NSMakeRange(0, attribute.length)];
        rect.origin.x = x + (rect.size.width - [PYUtile getBoundSizeWithTxt:attribute.string font:font size:fontSize].height)/2;
        [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:rect y:bounds.size.height scaleFlag:false];
        x += rect.size.width;
    }
    
}
/**
 日期标签
 */
+(CGRect) drawDayWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds borderWith:(CGFloat) borderWith dateRect:(PYCalendarRect *) dateRectP heightDay:(CGFloat) heightDay  heightLunar:(CGFloat) heightLunar fontDay:(nonnull UIFont*) fontDay fontLunar:(nullable UIFont*) fontLunar colorDay:(nonnull UIColor*) colorDay colorLunar:(nullable UIColor*) colorLunar{
    PYCalendarRect  dateRect = * dateRectP;
    NSAttributedString * attributeDay = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)dateRect.date.day] attributes:@{(NSString*)NSForegroundColorAttributeName:colorDay,(NSString*)NSFontAttributeName:fontDay}];
    PYCalendarSolarTerm lunarSt = [PYCalendarLocation getLunarStrWithDate:dateRect.date];
    (*dateRectP).lunarDate = lunarSt.date;
    NSAttributedString * attributeLunar = [[NSAttributedString alloc] initWithString:[NSString stringWithUTF8String:lunarSt.solarTerm ? lunarSt.solarTerm : lunarSt.name] attributes:@{(NSString*)NSForegroundColorAttributeName:colorLunar,(NSString*)NSFontAttributeName:fontLunar}];
    
    CGRect rectDay;
    CGRect rectLuar;
    [PYCalendarLocation locationRect:dateRect borderWith:borderWith attributeDay:attributeDay heightDay:heightDay rectDayPointer:&rectDay attributeLunar:attributeLunar heightLunar:heightLunar rectLunarPointer:&rectLuar];
    
    [PYGraphicsDraw drawTextWithContext:context attribute:attributeDay rect:rectDay y:bounds.size.height scaleFlag:false];
    [PYGraphicsDraw drawTextWithContext:context attribute:attributeLunar rect:rectLuar y:bounds.size.height scaleFlag:false];
    CGRect returnRect = CGRectMake(MIN(rectDay.origin.x, rectLuar.origin.x), rectDay.origin.y, MAX(rectDay.size.width, rectLuar.size.width), rectLuar.size.height + rectLuar.origin.y - rectDay.origin.y);
    return returnRect;
}
/**
 显示指定时间
 */
+(void) drawClockTimeWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds time:(PYTime) time strokeWith:(CGFloat) strokeWith strokeColor:(nonnull CGColorRef) strokeColor  fillColor:(nonnull CGColorRef) fillColor{
    CGSize size = bounds.size;
    CGPoint centerPoint = CGPointMake(size.width / 2, size.height / 2);
    CGFloat radius = MIN(size.width, size.height) / 2 - strokeWith / 2 - 20;
    CGFloat value = time.hour % 12;
    if (value < 3) {
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:-90 endDegree:-90 + (value / 3 + ((CGFloat)time.minute) / (60 * 3))  * 90];
        return;
    }else{
       [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:-90 endDegree:0];
    }
    if (value < 6) {
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:0 endDegree:((value - 3) / 3 + ((CGFloat)time.minute) / (60 * 3))  * 90];
        return;
    }else{
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:0 endDegree:90];
    }
    if (value < 9) {
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:90 endDegree:((value - 6) / 3 + ((CGFloat)time.minute) / (60 * 3))  * 90 + 90];
        return;
    }else{
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:90 endDegree:180];
    }
    if (value < 12 && value >= 9) {
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:180 endDegree:((value - 9) / 3 + ((CGFloat)time.minute) / (60 * 3))  * 90 + 180];
        return;
    }else{
        [PYGraphicsDraw drawCircleWithContext:context pointCenter:centerPoint radius:radius strokeColor:strokeColor fillColor:fillColor strokeWidth:strokeWith startDegree:180 endDegree:270];
    }
}
/**
 时间数字
 */
+(void) drawClockNumWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds{
    [PYGraphicsDraw drawTextWithContext:context attribute:[[NSMutableAttributedString alloc] init] rect:bounds y:bounds.size.height scaleFlag:YES];
    [self drawClickWithLineB:1 circelB:10 size:bounds.size blockDraw:^(CGPoint center, CGFloat strokeWidth, NSUInteger index) {
        if(index % 5 == 0){
            int value = (int)index/5;
            value = value == 0 ? 12 : value;
            UIFont * font = [UIFont systemFontOfSize:12];
            NSMutableAttributedString * valueArg = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",value] attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor],NSFontAttributeName:font}];
            CGSize size = [PYUtile getBoundSizeWithAttributeTxt:valueArg size:CGSizeMake(999, [PYUtile getFontHeightWithSize:font.pointSize fontName:font.fontName])];
            CGPoint  p = CGPointMake(center.x - size.width/2, center.y - size.height/2);
            CGRect r = CGRectMake(p.x, p.y, size.width, size.height);
            [PYGraphicsDraw drawTextWithContext:context attribute:valueArg rect:r y:bounds.size.height scaleFlag:NO];
        }
    }];
}
/**
 时间点位
 */
+(void) drawClockPointWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds{
    CGPoint centerPoint = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    [PYGraphicsDraw drawLineWithContext:context startPoint:centerPoint endPoint:centerPoint strokeColor:[UIColor orangeColor].CGColor strokeWidth:4 lengthPointer:nil length:0];
    
    [self drawClickWithLineB:1 circelB:10 size:bounds.size blockDraw:^(CGPoint center, CGFloat strokeWidth, NSUInteger index) {
        if(index % 5 != 0){
            [PYGraphicsDraw drawLineWithContext:context startPoint:center endPoint:center strokeColor:[UIColor blackColor].CGColor strokeWidth:strokeWidth lengthPointer:nil length:0];
        }
    }];
}
+(void) drawSpecalWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds spesal:(const char *) spesal specalColor:(nonnull UIColor *) specalColor specalFont:(nonnull UIFont *) specalFont resultRect:(CGRect)resultRect calendarRect:(PYCalendarRect) calendarRect heightFontLunar:(CGFloat) heightFontLunar{
    NSAttributedString * attributeTarget = [[NSAttributedString alloc] initWithString:[NSString stringWithUTF8String:spesal] attributes:@{(NSString*)NSForegroundColorAttributeName:specalColor,(NSString*)NSFontAttributeName:specalFont}];
    CGRect rectTarget = CGRectMake(resultRect.origin.x + resultRect.size.width, calendarRect.frame.origin.y, calendarRect.frame.size.width - resultRect.size.width - (resultRect.origin.x - calendarRect.frame.origin.x), heightFontLunar*4);
    resultRect.origin.y +=  calendarRect.frame.size.height * 0.2;
    [PYGraphicsDraw drawTextWithContext:context attribute:attributeTarget rect:rectTarget y:bounds.size.height scaleFlag:false];
}

+(void) drawMarkWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds mark:(const char *) mark markFont:(nonnull UIFont *) markFont markColor:(nonnull UIColor *) markColor resultRect:(CGRect)resultRect calendarRect:(PYCalendarRect) calendarRect{
    NSAttributedString * attributeTarget = [[NSAttributedString alloc] initWithString:[NSString stringWithUTF8String:mark] attributes:@{(NSString*)NSForegroundColorAttributeName:[UIColor whiteColor] ,(NSString*)NSFontAttributeName:markFont}];
    CGRect rectTarget = CGRectMake(calendarRect.frame.origin.x, calendarRect.frame.origin.y, 0, 0);
    rectTarget.size = [PYUtile getBoundSizeWithAttributeTxt:attributeTarget size:CGSizeMake(999, markFont.pointSize)];
    rectTarget.origin.y +=  calendarRect.frame.size.height * 0.1;
    rectTarget.origin.x += (resultRect.origin.x - calendarRect.frame.origin.x - rectTarget.size.width)/2;
    CGRect rectCirl = rectTarget;
    CGFloat cirlbw = MIN(calendarRect.frame.size.height, calendarRect.frame.size.width) * 0.02;
    rectCirl.origin.y = bounds.size.height - rectCirl.origin.y - rectCirl.size.height;
    rectCirl.origin.y -= cirlbw;
    rectCirl.origin.x -= cirlbw;
    rectCirl.size.width += cirlbw *2;
    rectCirl.size.height += cirlbw *2;
    [PYGraphicsDraw drawEllipseWithContext:context rect:rectCirl strokeColor:markColor.CGColor fillColor:markColor.CGColor strokeWidth:1];
    rectTarget.size.width += 1;
    rectTarget.size.height += 1;
    [PYGraphicsDraw drawTextWithContext:context attribute:attributeTarget rect:rectTarget y:bounds.size.height scaleFlag:false];
}

+(void) drawClickWithLineB:(CGFloat)  lineB circelB:(CGFloat) circelB size:(CGSize) size blockDraw:(void (^)(CGPoint center, CGFloat strokeWidth, NSUInteger index)) blockDraw{
    
    CGFloat radius = MIN(size.width, size.height) / 2;
    CGFloat offx = size.width > size.height ? (size.width - size.height) / 2 : 0;
    CGFloat offy = size.width < size.height ? (size.height - size.width) / 2 : 0;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat vx = 0;
    CGFloat vy = 0;
    for (NSUInteger num = 0; num < 60; num ++) {
        if (num < 15) {
            
            vx = sin(parseDegreesToRadians(((CGFloat)num) / 15 * 90));
            vy = cos(parseDegreesToRadians(((CGFloat)num) / 15 * 90));
            
            x = ( vx + 1) * radius;
            y = (1 - vy) * radius;
            
            x -= lineB * vx;
            x -= circelB * vx;
            
            y += lineB * vy;
            y += circelB * vy;
            
        }else if(num >= 15 && num < 30){
            vx = cos(parseDegreesToRadians(((CGFloat)num - 15) / 15 * 90));
            vy = sin(parseDegreesToRadians(((CGFloat)num - 15) / 15 * 90));
            
            x = (1 + vx) * radius;
            y = (1 + vy) * radius;
            
            x -= lineB * vx;
            x -= circelB * vx;
            
            y -= lineB * vy;
            y -= circelB * vy;
            
        }else if(num >= 30 && num < 45){
            
            vx =  sin(parseDegreesToRadians(((CGFloat)num - 30) / 15 * 90));
            vy = cos(parseDegreesToRadians(((CGFloat)num - 30) / 15 * 90));
            
            x = (1 - vx) * radius;
            y = (1 + vy) * radius;
            
            x += lineB * vx;
            x += circelB * vx;
            
            y -= lineB * vy;
            y -= circelB * vy;
            
        }else{
            
            vx = cos(parseDegreesToRadians(((CGFloat)num - 45) / 15 * 90));
            vy = sin(parseDegreesToRadians(((CGFloat)num - 45) / 15 * 90));
            
            x = (1 - vx) * radius;
            y = (1 - vy) * radius;
            
            x += lineB * vx;
            x += circelB * vx;
            
            y += lineB * vy;
            y += circelB * vy;
        }
        x += offx;
        x += offy;
        blockDraw(CGPointMake(x, y), lineB * 2, num);
    }
}

@end
