//
//  calendar_lunar.c
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#include "calendar_lunar.h"
#include <string.h>
static const double x_1900_1_6_2_5 = 693966.08680556;
const int PYCalendarToolsYearMin = 1900;
const int PYCalendarToolsYearMax = 2100;
const unsigned int LunarCalendarInfoLength = 201;
const unsigned int LunarCalendarInfo[201] = {
    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
    0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
    0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
    0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
    0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
    
    0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,
    0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
    0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,
    0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
    0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
    
    0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
    0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
    0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
    0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
    0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,
    
    
    0x04b63,0x0937f,0x049f8,0x04970,0x064b0,0x068a6,0x0ea5f,0x06b20,0x0a6c4,0x0aaef,
    0x092e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,
    0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,
    0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x04b55,0x04b6f,0x0a570,0x054e4,0x0d260,
    0x0e968,0x0d520,0x0daa0,0x06aa6,0x056df,0x04ae0,0x0a9d4,0x0a4d0,0x0d150,0x0f252,
    0x0d520};

const unsigned int LunarCalendarDaysLength = 31;
const char * LunarCalendarDays[31] = {"初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十", "三一"};

const unsigned int LunarCalendarMonthLength = 12;
const char * LunarCalendarMonth[12] = {"正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月",  "十月", "冬月", "腊月"};

const unsigned int LunarCalendarRunMonthLength = 12;
const char * LunarCalendarRunMonth[12] = {"正月", "闰二月", "闰三月", "闰四月", "闰五月", "闰六月", "闰七月", "闰八月", "闰九月",  "闰十月", "闰冬月", "腊月"};

const unsigned int LunarCalendarZodiacLength = 12;
const char * LunarCalendarZodiac[12] = {"鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"};

const unsigned int LunarCalendarTianganLength = 10;
const char * LunarCalendarTiangan[10] =  {"甲","乙","丙","丁","戊","己","庚","辛","壬","癸"};

const unsigned int LunarCalendarDizhiLength = 12;
const char * LunarCalendarDizhi[12] =  {"子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"};

const float LunarCalendarSuoyue = 29.5306;

const unsigned int LunarCalendarInfoStart[6] = {12,1,30,1,1};

const unsigned int CalendarNonleapYearInfo[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
const unsigned int CalendarLeapYearInfo[12] = {31,29,31,30,31,30,31,31,30,31,30,31};

double get_solar_term( int y , int n ){
    static const int termInfo[] = {
        0,21208 ,42467 ,63836 ,85337 ,107014,
        128867,150921,173149,195551,218072,240693,
        263343,285989,308563,331033,353350,375494,
        397447,419210,440795,462224,483532,504758
    };
    return x_1900_1_6_2_5+365.2422*((double)y - 1900.0)+termInfo[n]/(60.0*24.0);
}

void  format_date( unsigned _days, struct py_date * datePointer){
    static const int mdays[] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365};
    int y , m , d , diff;
    unsigned days;
    
    days = 100 * (_days - _days/(3652425L/(3652425L-3652400L)) );
    y    = days / 36524; days %= 36524;
    m    = 1 + days/3044;        /* [1..12] */
    d    = 1 + (days%3044)/100;    /* [1..31] */
    
    diff =y*365+y/4-y/100+y/400+mdays[m-1]+d-((m<=2&&((y&3)==0)&&((y%100)!=0||y%400==0))) - _days;
    
    if( diff > 0 && diff >= d )    /* ~0.5% */
    {
        if( m == 1 )
        {
            --y; m = 12;
            d = 31 - ( diff - d );
        }
        else
        {
            d = mdays[m-1] - ( diff - d );
            if( --m == 2 )
                d += ((y&3)==0) && ((y%100)!=0||y%400==0);
        }
    }
    else
    {
        if( (d -= diff) > mdays[m] )    /* ~1.6% */
        {
            if( m == 2 )
            {
                if(((y&3)==0) && ((y%100)!=0||y%400==0))
                {
                    if( d != 29 )
                        m = 3 , d -= 29;
                }
                else
                {
                    m = 3 , d -= 28;
                }
            }
            else
            {
                d -= mdays[m];
                if( m++ == 12 )
                    ++y , m = 1;
            }
        }
    }
    if (datePointer) {
        struct py_date date =  {y, m, d};
        *datePointer = date;
    }
}


