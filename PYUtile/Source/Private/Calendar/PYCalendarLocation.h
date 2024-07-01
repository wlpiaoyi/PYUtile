//
//  PYCalendarLocation.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/13.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCalendarParam.h"

@protocol PYCalendarLocation<NSObject>
@optional
-(void) iteratorDayIntMonth:(PYCalendarRect) rect;
-(void) iteratorDayIntWeek:(PYCalendarRect) rect;
@end

@interface PYCalendarLocation : UIView
/**
 每月的前后求余
 */
+(void) locationDaysWithDate:(nonnull NSDate *) date headPointer:(int * _Nullable) headPointer  tailPointer:(int * _Nullable) tailPointer;
/**
 目标月份单日size
 */
+(void) locationDaySize:(CGSize * _Nonnull) daySizePointer date:(nonnull NSDate *) date bounds:(CGRect) bounds;
/**
 目标月份每日的相对位置
 */
+(void) locationMonthWithDate:(nonnull NSDate *) date bounds:(CGRect) bounds locationsLengthPointer:(int * _Nullable) locationsLengthPointer iterator:(nullable id<PYCalendarLocation>) iterator;
/**
 计算日期绝对位置
 */
+(void) locationRect:(PYCalendarRect) cRect borderWith:(CGFloat) borderWith attributeDay:(nonnull NSAttributedString *) attributeDay heightDay:(CGFloat) heightDay rectDayPointer:(CGRect * _Nonnull) rectDayPointer attributeLunar:(nonnull NSAttributedString *) attributeLunar heightLunar:(CGFloat) heightLunar rectLunarPointer:(CGRect * _Nonnull) rectLunarPointer;
/**
 获取农历信息
 */
+(PYCalendarSolarTerm) getLunarStrWithDate:(PYDate) date;

@end
