//
//  PYCalendarLocation.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/13.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarLocation.h"
#import "PYCalendarLunar.h"
#import "NSDate+PYExpand.h"
#import "calendar_lunar.h"
PYCalendarSolarTerm * PRECALENDERSOLARTERMS;
@implementation PYCalendarLocation
+(void) initialize{
}
/**
 每月的前后求余
 */
+(void) locationDaysWithDate:(nonnull NSDate *) date headPointer:(int * _Nullable) headPointer  tailPointer:(int * _Nullable) tailPointer{
    int first =  date.firstWeekDayInMonth;
    if (first == 7) {
        first = 0;
    }
    if(headPointer){
        *headPointer = first;
    }
    if(tailPointer){
        int days = date.numDaysInMonth;
        int tail = 7 - (days + first) % 7;
        if(tail == 7){
            tail = 0;
        }
        *tailPointer = tail;
    }
}
/**
 目标月份单日size
 */
+(void) locationDaySize:(CGSize * _Nonnull) daySizePointer date:(nonnull NSDate *) date bounds:(CGRect) bounds{
    int head,tail;
    int days;
    [self locationDaysWithDate:date headPointer:&head tailPointer:&tail];
    days = date.numDaysInMonth;
    int total = head + days + tail;
    *daySizePointer = CGSizeMake(bounds.size.width / 7, bounds.size.height / (total / 7));
}
/**
 目标月份每日的相对位置
 */
+(void) locationMonthWithDate:(nonnull NSDate *) date bounds:(CGRect) bounds locationsLengthPointer:(int * _Nullable) locationsLengthPointer iterator:(nullable id<PYCalendarLocation>) iterator;{
    
    int head,tail;
    int year,month,days;
    [self locationDaysWithDate:date headPointer:&head tailPointer:&tail];
    days = date.numDaysInMonth;
    year = date.year;
    month = date.month;
    int total = head + days + tail;
    CGSize daySize = CGSizeMake(bounds.size.width / 7, bounds.size.height / (total / 7));
    if(locationsLengthPointer) *locationsLengthPointer = total;
    if(iterator){
        CGRect(^blockM) (int index, CGSize daySize) =  ^(int index, CGSize daySize){
            return CGRectMake((index % 7) * daySize.width, (index / 7) * daySize.height, daySize.width, daySize.height);
        };
        CGRect(^blockW) (int index, CGSize daySize) =  ^(int index, CGSize daySize){
            return CGRectMake((index % 7) * daySize.width,  daySize.height, daySize.width, daySize.height);
        };
        bool flagM = [iterator respondsToSelector:@selector(iteratorDayIntMonth:)];
        bool flagW = [iterator respondsToSelector:@selector(iteratorDayIntWeek:)];
        int index = 0;
        if(head > 0){
            NSDate * preDate = [date offsetMonth:-1];
            int predays = preDate.numDaysInMonth - head + 1;
            int preyear = preDate.year;
            int premonth = preDate.month;
            for (int i = 0; i < head; i ++) {
                if(flagM){
                    PYCalendarRect rect = PYCalendarRectMake(index, blockM(index, daySize), PYDateMake(preyear, premonth, predays + index));
                    [iterator iteratorDayIntMonth:rect];
                }
                if(flagW){
                    PYCalendarRect rect = PYCalendarRectMake(index % 7, blockW(index, daySize), PYDateMake(preyear, premonth, predays + index));
                    [iterator iteratorDayIntWeek:rect];
                }
                index ++;
            }
        }
        for (int i = 0; i < days; i++) {
            if(flagM){
                PYCalendarRect rect = PYCalendarRectMake(index, blockM(index, daySize), PYDateMake(year, month, i + 1));
                [iterator iteratorDayIntMonth:rect];
            }
            if(flagW){
                PYCalendarRect rect = PYCalendarRectMake(index, blockW(index, daySize), PYDateMake(year, month, i + 1));
                [iterator iteratorDayIntMonth:rect];
            }
            index ++;
        }
        if(tail > 0){
            NSDate * nextDate = [date offsetMonth:1];
            int nextyear = nextDate.year;
            int nextmonth = nextDate.month;
            for (int i = 0; i<tail; i++) {
                if(flagM){
                    PYCalendarRect rect = PYCalendarRectMake(index, blockM(index, daySize), PYDateMake(nextyear, nextmonth, i + 1));
                    [iterator iteratorDayIntMonth:rect];
                }
                if(flagW){
                    PYCalendarRect rect = PYCalendarRectMake(index, blockW(index, daySize), PYDateMake(year, month, i + 1));
                    [iterator iteratorDayIntMonth:rect];
                }
                index ++;
            }
        }
    }
}

/**
 计算日期绝对位置
 */
+(void) locationRect:(PYCalendarRect) cRect borderWith:(CGFloat) borderWith attributeDay:(nonnull NSAttributedString *) attributeDay heightDay:(CGFloat) heightDay rectDayPointer:(CGRect * _Nonnull) rectDayPointer attributeLunar:(nonnull NSAttributedString *) attributeLunar heightLunar:(CGFloat) heightLunar rectLunarPointer:(CGRect * _Nonnull) rectLunarPointer{
    
    CGRect rDay = cRect.frame;
    rDay.size = CGSizeMake(999, heightDay);
    rDay.size = [PYUtile getBoundSizeWithAttributeTxt:attributeDay size:rDay.size];
    CGRect rLunar = cRect.frame;
    rLunar.size = CGSizeMake(999, heightLunar);
    rLunar.size = [PYUtile getBoundSizeWithAttributeTxt:attributeLunar size:rLunar.size];
    
    CGRect r = cRect.frame;
    r.size = CGSizeMake(MAX(rDay.size.width, rLunar.size.width), rDay.size.height + borderWith + rLunar.size.height);
    r.origin.x += (cRect.frame.size.width - r.size.width) / 2;
    r.origin.y += (cRect.frame.size.height - r.size.height) / 2;
    
    rDay.origin.x = r.origin.x + (r.size.width - rDay.size.width)/2;
    rDay.origin.y = r.origin.y;
    
    rLunar.origin.x = r.origin.x + (r.size.width - rLunar.size.width)/2;
    rLunar.origin.y = rDay.origin.y + borderWith + rDay.size.height;
    
    rDay.size.width += 1;
    rDay.size.height += 1;
    rLunar.size.width += 1;
    rLunar.size.height += 1;
    
    *rectDayPointer = rDay;
    *rectLunarPointer = rLunar;
    
}

+(PYCalendarSolarTerm) getLunarStrWithDate:(PYDate) date{
    
    NSInteger lunarYear;
    NSInteger lunarMonth;
    NSInteger lunarDay;
    NSInteger totalLunarDays;
    [PYCalendarLunar getTotalDaysPointer:&totalLunarDays year:date.year month:date.month];
    totalLunarDays += date.day - 1;
    [PYCalendarLunar getLunarYearPointer:&lunarYear lunarMonthPointer:&lunarMonth lunarDayPointer:&lunarDay totalLunarDays:totalLunarDays];
    char * name = (char *)LunarCalendarDays[lunarDay - 1];
    if(lunarDay == 1){
        name = (char *)LunarCalendarMonth[lunarMonth - 1];
        if(lunarMonth == 1){
            name =  [PYCalendarLunar getLunarYearNameWithYear:lunarYear];
        }
    }
    PYCalendarSolarTerm lunarSt = PYCalendarSolarTermMake(PYDateMake(lunarYear, lunarMonth, lunarDay), name, nil);
    
    @synchronized(self) {
        if (PRECALENDERSOLARTERMS == nil || PRECALENDERSOLARTERMS[0].date.year != date.year) {
            PRECALENDERSOLARTERMS = [PYCalendarLunar getSolarTermsWithYear:(int)date.year];
        }
    }
    
    int ii = 0;
    for (int i = 0; i < 24; i++) {
        PYCalendarSolarTerm st = PRECALENDERSOLARTERMS[i];
        ii = i;
        if (st.date.year == date.year && st.date.month == date.month && st.date.day == date.day) {
            lunarSt.solarTerm = st.solarTerm;
            break;
        }
    }
    return lunarSt;
}


@end
