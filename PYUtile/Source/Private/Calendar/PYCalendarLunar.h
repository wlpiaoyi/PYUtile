//
//  PYCalendarLunar.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCalendarParam.h"

@interface PYCalendarLunar : NSObject
/**
 获取年份对应的属性
 */
+(nullable const char *) lunarZodiacWithYear:(NSInteger) year;
/**
 根据朔日推算对应的公历日期
 */
+(bool) getYearPointer:(nullable NSInteger *) yearPointer monthPointer:(nullable NSInteger *) monthPointer dayPointer:(nullable NSInteger *) dayPointer totalLunarDays:(NSInteger) totalLunarDays;
/**
 根据朔日推算对应的农历时间
 */
+(bool) getLunarYearPointer:(nullable NSInteger *) lunarYearPointer lunarMonthPointer:(nullable NSInteger *) lunarMonthPointer lunarDayPointer:(nullable NSInteger *) lunarDayPointer totalLunarDays:(NSInteger)totalLunarDays;
/**
 公历日期朔日
 */
+(BOOL) getTotalDaysPointer:(nonnull NSInteger *) totalDaysPointer year:(NSInteger) year month:(NSInteger) month;
/**
 农历日期朔日
 */
+(BOOL) getTotalLunarDaysPointer:(nonnull NSInteger *) totalLunarDaysPointer year:(NSInteger) year month:(NSInteger) month;
/**
 返回当前农历日名称
 */
+(nonnull char *) getLunaDayNameWithDay:(NSInteger) day;
/**
 返回当前农历月名称
 */
+(nonnull char *) getLunarMonthNameWithMonth:(NSInteger) month;
/**
 返回农历年名称
 */
+(nonnull char *) getLunarYearNameWithYear:(NSInteger) year;
/**
 返回农历年闰月 0b*[4.]0000
 */
+(NSInteger) getDoubleLunarMonthWithYear:(NSInteger) year;
/**
 返回农历年闰月的天数 0b[1.][12.][4.]0
 */
+(NSInteger) getDoubleLunarMonthDaysWithYear:(NSInteger) year;
/**
 返回农历年月份的总天数0b*[12.][4.] 011011010010
 */
+(NSInteger) getLunarMonthDaysWithYear:(NSInteger) year month:(NSInteger) month;
/**
 返回农历年总天数
 */
+(NSInteger) getLunarDaysWithYear:(NSInteger) year;
+(nullable PYCalendarSolarTerm *) getSolarTermsWithYear:(int) year;
@end
