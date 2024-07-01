//
//  PYCalendarGraphics.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCalendarParam.h"
extern NSArray * _Nonnull PYCalendarWeekNames;

@interface PYCalendarGraphics : NSObject

/**
 星期标签
 */
+(void) drawWeekWithContext:(nullable CGContextRef) context  bounds:(CGRect) bounds font:(nonnull UIFont *) font color:(nonnull UIColor*) color;
/**
 日期标签
 */
+(CGRect) drawDayWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds borderWith:(CGFloat) borderWith dateRect:(PYCalendarRect *_Nonnull) dateRect heightDay:(CGFloat) heightDay  heightLunar:(CGFloat) heightLunar fontDay:(nonnull UIFont*) fontDay fontLunar:(nullable UIFont*) fontLunar colorDay:(nonnull UIColor*) colorDay colorLunar:(nullable UIColor*) colorLunar;
/**
 显示指定时间
 */
+(void) drawClockTimeWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds time:(PYTime) time strokeWith:(CGFloat) strokeWith strokeColor:(nonnull CGColorRef) strokeColor  fillColor:(nonnull CGColorRef) fillColor;
/**
 时间数字
 */
+(void) drawClockNumWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds;
/**
 时间点位
 */
+(void) drawClockPointWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds;
+(void) drawSpecalWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds spesal:(nonnull const char *) spesal specalColor:(nonnull UIColor *) specalColor specalFont:(nonnull UIFont *) specalFont resultRect:(CGRect)resultRect calendarRect:(PYCalendarRect) calendarRect heightFontLunar:(CGFloat) heightFontLunar;
+(void) drawMarkWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds mark:(nonnull const char *) mark markFont:(nonnull UIFont *) markFont markColor:(nonnull UIColor *) markColor resultRect:(CGRect)resultRect calendarRect:(PYCalendarRect) calendarRect;

@end
