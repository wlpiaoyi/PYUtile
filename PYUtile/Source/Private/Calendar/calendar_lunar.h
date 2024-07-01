//
//  calendar_lunar.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//
#include <stdio.h>

static const char* solar_term_name[] = {
    "小寒","大寒","立春","雨水",
    "惊蛰","春分","清明","谷雨",
    "立夏","小满","芒种","夏至",
    "小暑","大暑","立秋","处暑",
    "白露","秋分","寒露","霜降",
    "立冬","小雪","大雪","冬至"
};

extern const int PYCalendarToolsYearMin;
extern const int PYCalendarToolsYearMax;
extern const unsigned int LunarCalendarInfoLength;
extern const unsigned int LunarCalendarInfo[201];

extern const unsigned int LunarCalendarDaysLength ;
extern const char * LunarCalendarDays[31];

extern const unsigned int LunarCalendarMonthLength ;
extern const char * LunarCalendarMonth[12];

extern const unsigned int LunarCalendarRunMonthLength;
extern const char * LunarCalendarRunMonth[12];

extern const unsigned int LunarCalendarZodiacLength;
extern const char * LunarCalendarZodiac[12];

extern const unsigned int LunarCalendarTianganLength;
extern const char * LunarCalendarTiangan[10];

extern const unsigned int LunarCalendarDizhiLength;
extern const char * LunarCalendarDizhi[12];

extern const float LunarCalendarSuoyue;

extern const unsigned int LunarCalendarInfoStart[6];

extern const unsigned int CalendarNonleapYearInfo[12];
extern const unsigned int CalendarLeapYearInfo[12];
struct py_date{
    int year;
    int month;
    int day;
};
double get_solar_term( int y , int n );
void  format_date( unsigned _days, struct py_date *datePointer);
