//
//  PYCalendarLunar.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarLunar.h"
#import "calendar_lunar.h"
#include <stdio.h>
#include <string.h>

@implementation PYCalendarLunar

/**
 获取年份对应的属性
 */
+(const char*) lunarZodiacWithYear:(NSInteger) year{
    if(year < PYCalendarToolsYearMin || year > PYCalendarToolsYearMax){
        return nil;
    }
    return LunarCalendarZodiac[(year - (PYCalendarToolsYearMin % 12)) % 12];
}
/**
 通过朔日获取公历日期
 */
+(bool) getYearPointer:(nullable NSInteger *) yearPointer monthPointer:(nullable NSInteger *) monthPointer dayPointer:(nullable NSInteger *) dayPointer totalLunarDays:(NSInteger) totalLunarDays{
    
    NSInteger _totalLunarDays = 0;
    for (NSInteger _year = PYCalendarToolsYearMin; _year <= PYCalendarToolsYearMax; _year++) {
        NSInteger yearDays = 365;
        if(_year != PYCalendarToolsYearMin && _year % 4 == 0){
            yearDays += 1;
        }
        _totalLunarDays += yearDays;
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= yearDays;
            *yearPointer = _year;
            break;
        }
        
    }
    NSInteger monthNum = 1;
    for (NSInteger index = 0; index < LunarCalendarMonthLength; index++) {
        NSInteger _monthDays = ((*yearPointer != PYCalendarToolsYearMin && *yearPointer % 4 == 0) ? CalendarLeapYearInfo : CalendarNonleapYearInfo)[index];
        _totalLunarDays += _monthDays;
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= _monthDays;
            *monthPointer = monthNum;
            break;
        }
        monthNum ++;
    }
    
    *dayPointer = totalLunarDays - _totalLunarDays + 1;
    
    return true;
}

/**
 根据总天数推算对应的农历时间
 */
+(bool) getLunarYearPointer:(nullable NSInteger *) lunarYearPointer lunarMonthPointer:(nullable NSInteger *) lunarMonthPointer lunarDayPointer:(nullable NSInteger *) lunarDayPointer totalLunarDays:(NSInteger)totalLunarDays{
    NSInteger lunarYear = 0;
    NSInteger lunarMonth = 0;
    NSInteger lunarDay = 0;
    unsigned int _totalLunarDays = LunarCalendarInfoStart[2];
    for (unsigned int _year = PYCalendarToolsYearMin; _year <= PYCalendarToolsYearMax; _year++) {
        _totalLunarDays += [self getLunarDaysWithYear:_year];
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= [self getLunarDaysWithYear:_year];
            lunarYear = _year;
            break;
        }
    }
    NSInteger ruiyue =  [self getDoubleLunarMonthWithYear:lunarYear];
    for (NSInteger _month = 1; _month <= 12; _month++) {
        NSInteger monthDays = [self getLunarMonthDaysWithYear:lunarYear month:_month];
        _totalLunarDays += monthDays;
        if(_totalLunarDays > totalLunarDays){
            _totalLunarDays -= monthDays;
            lunarMonth = _month;
            break;
        }
        if(_month == ruiyue){
            monthDays = [self getDoubleLunarMonthDaysWithYear:lunarYear];
            _totalLunarDays += monthDays;
            if(_totalLunarDays > totalLunarDays){
                _totalLunarDays -= monthDays;
                lunarMonth = -_month;
                break;
            }
        }
    }
    lunarDay = totalLunarDays - _totalLunarDays + 1;
    if (lunarYearPointer) {
        *lunarYearPointer = lunarYear;
    }
    if (lunarMonthPointer) {
        *lunarMonthPointer = lunarMonth;
    }
    if (lunarDayPointer) {
        *lunarDayPointer = lunarDay;
    }
    return true;
}

/**
 公历月份的总天数
 */
+(BOOL) getTotalDaysPointer:(nonnull NSInteger *) totalDaysPointer year:(NSInteger) year month:(NSInteger) month{
    BOOL result =  [self ifValidDataWithYear:year month:month day:1];
    if(result == false){
        return result;
    }
    NSInteger suffYears = year - PYCalendarToolsYearMin;
    NSInteger M4 = suffYears % 4;
    NSInteger D4 = suffYears / 4;
    NSInteger days = suffYears * 365 + D4;
    if(year % 4 == 0){
        days -= 1;
    }
    if(M4 == 0){
        NSInteger index = 1;
        for (NSInteger i = 0; i < LunarCalendarMonthLength; i++) {
            NSInteger _days = CalendarLeapYearInfo[i];
            if(index >= labs(month)){
                break;
            }
            days += _days;
            ++index;
        }
    }else{
        NSInteger index = 1;
        for (NSInteger i = 0; i < LunarCalendarMonthLength; i++) {
            NSInteger _days = CalendarNonleapYearInfo[i];
            if(index >= labs(month)){
                break;
            }
            days += _days;
            ++index;
        }
    }
    *totalDaysPointer = days;
    return result;
}
/**
 农历月份的总天数
 */
+(BOOL) getTotalLunarDaysPointer:(NSInteger * ) totalLunarDaysPointer year:(NSInteger) year month:(NSInteger) month{
    BOOL result = [self ifValidLunarDataWithYear:year month:month day:1];
    if(result == false){
        return result;
    }
    NSInteger days = LunarCalendarInfoStart[2];
    for (NSInteger _year = PYCalendarToolsYearMin; _year < year; _year++) {
        days += [self getLunarDaysWithYear:_year];
    }
    
    NSInteger ruiyue = [self getDoubleLunarMonthWithYear:year];
    for (NSInteger _months = 1; _months < labs(month);  _months++) {
        if(ruiyue > 0 && ruiyue == labs(month) - 1){
            days += [self getDoubleLunarMonthDaysWithYear:year]; //self.doubleLunarMonthDays(year: year)
        }else if(month < -1 && labs(month) == ruiyue){
            break;
        }
        days += [self getLunarMonthDaysWithYear:year month:_months]; //self.lunarMonthDays(year: year, month: _months)
    }
    *totalLunarDaysPointer = days;
    return result;
}
/**
 返回当前农历日名称
 */
+(nonnull char *) getLunaDayNameWithDay:(NSInteger) day{
    return (char *)LunarCalendarDays[day];
}
/**
 返回当前农历月名称
 */
+(nonnull char *) getLunarMonthNameWithMonth:(NSInteger) month{
    if(month < 0){
        return (char *)LunarCalendarRunMonth[-month];
    }
    return (char *)LunarCalendarMonth[month];
}
/**
 返回农历年名称
 */
+(nonnull char *) getLunarYearNameWithYear:(NSInteger) year{
    NSInteger suffixYear = year - 1864;
    char * a = (char *)LunarCalendarTiangan[suffixYear % LunarCalendarTianganLength];
    char * b = (char *)LunarCalendarDizhi[suffixYear % LunarCalendarDizhiLength];
    char * c = malloc(8);
    strcpy(c, a);
    strcat(c, b);
    return (char *)c;
}
/**
 返回农历年闰月 0b*[4.]0000
 */
+(NSInteger) getDoubleLunarMonthWithYear:(NSInteger) year{
    return (LunarCalendarInfo[year - PYCalendarToolsYearMin] & 0xf);
}
/**
 返回农历年闰月的天数 0b[1.][12.][4.]0
 */
+(NSInteger) getDoubleLunarMonthDaysWithYear:(NSInteger) year{
    if([self getDoubleLunarMonthWithYear:year] != 0){
        return (((LunarCalendarInfo[year - PYCalendarToolsYearMin] & 0x10000) != 0) ? 30 : 29);
    } else {
        return 0;
    }
}

/**
 返回农历年月份的总天数0b*[12.][4.] 011011010010
 */
+(NSInteger) getLunarMonthDaysWithYear:(NSInteger) year month:(NSInteger) month{
    return (((LunarCalendarInfo[year - PYCalendarToolsYearMin] & (0x10000 >> labs(month))) != 0) ? 30 : 29);
}

/**
 返回农历年总天数
 */
+(NSInteger) getLunarDaysWithYear:(NSInteger) year{
    NSInteger i = 0x8000;
    NSInteger sum = 348;
    for (i = 0x8000; i > 0x8; i >>= 1){
        if ((LunarCalendarInfo[year - PYCalendarToolsYearMin] & i) != 0){
            sum += 1;
        }
    }
    return (sum + [self getDoubleLunarMonthDaysWithYear:year]);
}


+(BOOL) ifValidLunarDataWithYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day{
    if(year > PYCalendarToolsYearMax){
        return false;
    }
    if(year < PYCalendarToolsYearMin){
        return false;
    }
    if(month < 1){
        return false;
    }
    if(month > 13){
        return false;
    }
    
    if([self getDoubleLunarMonthWithYear:year] == 0 && month > 12){
        return false;
    }
    if(day < 1){
        return false;
    }
    if(day > 29 && [self getLunarMonthDaysWithYear:year month:month] < day){
        return false;
    }
    return true;
}
+(BOOL) ifValidDataWithYear:(NSInteger) year month:(NSInteger) month day:(NSInteger) day{
    if(year > PYCalendarToolsYearMax){
        return false;
    }
    if(year < PYCalendarToolsYearMin){
        return false;
    }
    if(month < 1){
        return false;
    }
    if(month > 12){
        return false;
    }
    if(day < 1){
        return false;
    }
    if(year % 4 == 0 && (CalendarLeapYearInfo[month - 1] < day)){
        return false;
    }else if(CalendarNonleapYearInfo[month - 1] < day){
        return false;
    }
    return true;
}
/**
 获取指定年份的24节气
 */
+(PYCalendarSolarTerm *) getSolarTermsWithYear:(int) year {
    int i;
    if( year < 1900 || year > PYCalendarToolsYearMax )
        year = 2008;
    PYCalendarSolarTerm sts[50];
    for( i = 0; i < 24; ++i ) {
        struct py_date d;
        format_date( (unsigned)get_solar_term( year , i ),&d);
        PYDate date = PYDateMake(d.year, d.month, d.day);
        PYCalendarSolarTerm st = PYCalendarSolarTermMake(date, "", (char *)solar_term_name[i]);
        sts[i] = st;
    }
    PYCalendarSolarTerm * stsResult;
    stsResult = sts;
    return stsResult;
}
@end
