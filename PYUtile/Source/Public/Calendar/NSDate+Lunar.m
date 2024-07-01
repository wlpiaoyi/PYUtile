//
//  NSDate+Lunar.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//
#import "NSDate+Lunar.h"
#import "PYCalendarLunar.h"
#import "pyutilea.h"

NSInteger PYCalendarTotalDay1900_1970 = 0;

@implementation NSDate(Lunar)
@dynamic totalLunarDays,lunarYear,lunarMonth,lunarDay,lunarNumDaysInMonth,lunarYearZodiac,lunarYearName;
+(NSInteger) getTotalDay1900_1970{
    if (PYCalendarTotalDay1900_1970 == 0) {
        [PYCalendarLunar getTotalDaysPointer:&PYCalendarTotalDay1900_1970 year:1970 month:1];
    }
    return PYCalendarTotalDay1900_1970;
}
+(instancetype) dateWithYear:(NSUInteger) year month:(NSUInteger) month day:(NSUInteger) day hour:(NSUInteger) hour munite:(NSUInteger) munite second:(NSUInteger) second{
    NSInteger totalDays;
    [PYCalendarLunar getTotalDaysPointer:&totalDays year:year month:month];
    totalDays += day - 2;
    totalDays -= [self getTotalDay1900_1970];
    long long int totalSeconds = totalDays;
    totalSeconds *= 3600 * 24;
    totalSeconds += 3600 * hour + munite * 60 + second;
    totalSeconds += 3600 * 24;
    totalSeconds -= [NSTimeZone localTimeZone].secondsFromGMT;
    return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)totalSeconds];
}

-(NSInteger) totalLunarDays{
    NSInteger totalLunarDays;
    [PYCalendarLunar getTotalDaysPointer:&totalLunarDays year:self.year month:self.month];
    totalLunarDays += self.day - 1;
    return totalLunarDays;
}
-(NSInteger) lunarYear{
    NSInteger lunarYear;
    [PYCalendarLunar getLunarYearPointer:&lunarYear lunarMonthPointer:nil lunarDayPointer:nil totalLunarDays:self.totalLunarDays];
    return lunarYear;
}
-(NSInteger) lunarMonth{
    NSInteger lunarMonth;
    [PYCalendarLunar getLunarYearPointer:nil lunarMonthPointer:&lunarMonth lunarDayPointer:nil totalLunarDays:self.totalLunarDays];
    return lunarMonth;
}
-(NSInteger) lunarDay{
    NSInteger lunarDay;
    [PYCalendarLunar getLunarYearPointer:nil lunarMonthPointer:nil lunarDayPointer:&lunarDay totalLunarDays:self.totalLunarDays];
    return lunarDay;
}
-(NSInteger) lunarNumDaysInMonth{
    NSInteger lunarYear;
    NSInteger lunarMonth;
    [PYCalendarLunar getLunarYearPointer:&lunarYear lunarMonthPointer:&lunarMonth lunarDayPointer:nil totalLunarDays:self.totalLunarDays];
    return [PYCalendarLunar getLunarMonthDaysWithYear:lunarYear month:lunarMonth];
}
-(NSString*) lunarDayName{
    return [[NSString alloc] initWithUTF8String:[PYCalendarLunar getLunaDayNameWithDay:self.lunarDay - 1]];
}
-(NSString*) lunarMonthName{
    NSInteger m = self.lunarMonth;
    if(m > 0) m--;
    else m++;
    return [[NSString alloc] initWithUTF8String:[PYCalendarLunar getLunarMonthNameWithMonth:m]];
}
-(NSString*) lunarYearName{
    return [[NSString alloc] initWithUTF8String:[PYCalendarLunar getLunarYearNameWithYear:self.lunarYear]];
}

-(NSString*) lunarYearZodiac {
    return [NSString stringWithUTF8String:[PYCalendarLunar lunarZodiacWithYear:self.lunarYear]];
}

@end
