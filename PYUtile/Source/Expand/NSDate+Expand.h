//
//  NSDate+convenience.h
//
//  Created by in 't Veen Tjeerd on 4/23/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSDate (Expand)

-(NSDate *) offsetYear:(int)numYears;
-(NSDate *) offsetMonth:(int)numMonths;
-(NSDate *) offsetDay:(int)numDays;
-(NSDate *) offsetHours:(int)hours;
-(NSDate *) offsetMinutes:(int)minute;
-(NSDate *) offsetSecond:(int)second;
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
-(NSDate *) clearedWithBinary:(int) binary;
-(NSString*) dateFormateDate:(NSString*) formatePattern;

+(NSDate *) dateStartOfDay:(NSDate *)date;
+(NSDate *) monthStartOfDay:(NSDate *)date;
+(NSDate *) monthEndOfDay:(NSDate *)date;
+(NSDate *) dateStartOfWeek;
+(NSDate *) dateEndOfWeek;
+(NSDate *) getTodayZero;

-(NSDate *) setCompentsWithBinary:(int) binary NS_DEPRECATED_IOS(2_0, 7_0, "Use clearedWithBinary");
@end
