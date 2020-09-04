//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSDate (PYExpand)
/**
 友好的时间描述1
 */
-(nonnull NSString *) dateTimeDescribe1;
/**
 友好的时间描述2
 */
-(nonnull NSString *) dateTimeDescribe2;
/**
 友好的时间描述
 */
-(nonnull NSString *) dateTimeDescribe:(nullable NSString *) timeFormate hasBeforeTime:(BOOL) hasBeforeTime dateFormate:(nullable NSString *) dateFormate;
/**
 友好的日期描述
 */
-(nonnull NSString *) dateDescribe;
/**
 友好的日期描述
 */
-(nonnull NSString *) dateDescribe:(nullable NSString *) dateFormate;
-(nonnull NSDate *) offsetYear:(int)numYears;
-(nonnull NSDate *) offsetMonth:(int)numMonths;
-(nonnull NSDate *) offsetDay:(int)numDays;
-(nonnull NSDate *) offsetHours:(int)hours;
-(nonnull NSDate *) offsetMinutes:(int)minute;
-(nonnull NSDate *) offsetSecond:(int)second;
-(int) numDaysInMonth;
-(int) firstWeekDayInMonth;
-(int) year;
-(int) month;
-(int) weekday;
-(int) day;
-(int) hour;
-(int) minute;
-(int) second;
-(int) nanosecond;
/**
 0b1111111：年月日时分秒毫，1：保持原值，0：置为0；
 毫秒会自动被清除
 */
-(nonnull NSDate *) clearedWithBinary:(int) binary;
-(nullable NSString*) dateFormateDate:(nullable NSString*) formatePattern;

+(nonnull NSDate *) dateStartOfDay:(nonnull NSDate *)date;
+(nonnull NSDate *) monthStartOfDay:(nonnull NSDate *)date;
+(nonnull NSDate *) monthEndOfDay:(nonnull NSDate *)date;
+(nonnull NSDate *) dateStartOfWeek;
+(nonnull NSDate *) dateEndOfWeek;
+(nonnull NSDate *) getTodayZero;

-(nonnull NSDate *) setCompentsWithBinary:(int) binary API_DEPRECATED_WITH_REPLACEMENT("clearedWithBinary:", ios(1.0, 2.0));
@end
