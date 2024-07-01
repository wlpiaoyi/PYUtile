//
//  PYCalendarParam.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/13.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"
typedef struct _PYTime {
    NSInteger hour;
    NSInteger minute;
    NSInteger second;
} PYTime;
kUTILE_STATIC_INLINE PYTime PYTimeMake(NSInteger hour, NSInteger minute, NSInteger second){
    PYTime time = {hour, minute, second};
    return time;
}

typedef struct _PYDate {
    NSInteger year,month,day;
} PYDate;
kUTILE_STATIC_INLINE PYDate PYDateMake(NSInteger year, NSInteger month, NSInteger day){
    PYDate date = {year, month, day};
    return date;
}
//int PYDateMinusFotDays(PYDate date1, PYDate date2);
int PYDateCompareDate(PYDate date1, PYDate date2);
typedef struct _PYCalendarRect {
    int index;
    CGRect frame;
    PYDate date;
    PYDate lunarDate;
    bool flagEnable;
} PYCalendarRect;
kUTILE_STATIC_INLINE PYCalendarRect PYCalendarRectMake(int index, CGRect frame, PYDate date){
    PYCalendarRect rect = {index, frame, date, PYDateMake(0, 0, 0), true};
    return rect;
}
typedef struct _PYSpesalInfo {
    PYDate date;
    char *_Nonnull spesal;
    bool isLunar;
} PYSpesalInfo;
kUTILE_STATIC_INLINE PYSpesalInfo PYSpesalInfoMake(PYDate date, char * _Nonnull spesal, bool isLunar){
    PYSpesalInfo rect = { date, spesal, isLunar};
    return rect;
}

typedef struct _PYCalendarSolarTerm {
    PYDate date;
    char * _Nonnull name;
    char * _Nullable solarTerm;
} PYCalendarSolarTerm;

kUTILE_STATIC_INLINE PYCalendarSolarTerm PYCalendarSolarTermMake(PYDate date, char * _Nonnull name, char * _Nullable solarTerm){
    PYCalendarSolarTerm st =  {date, name, solarTerm};
    return st;
}

extern UIColor * _Nonnull PYCalendarBGC;
extern UIFont * _Nonnull PYCalendarWeekFont;
extern UIColor * _Nonnull PYCalendarWeekColor;
extern UIFont * _Nonnull PYCalendarDayFont;
extern UIColor * _Nonnull PYCalendarDayColor;
extern UIFont * _Nonnull PYCalendarLunarFont;
extern UIColor * _Nonnull PYCalendarLunarColor;
extern UIColor * _Nonnull PYCalendarDisableColor;
extern UIColor * _Nonnull PYCalendarWeeakEndColor;
extern UIColor * _Nonnull PYCalendarSpecial;
extern UIFont * _Nonnull PYCalendarSpesalFont;
extern BOOL PYCalendarHasWatermark;
extern BOOL PYCalendarHasSpesal;

@interface  PYCalendarParam : NSObject
+(void) loadCalendarData;
@end


